CPU:=$(shell uname -m)
SYSTEM:=$(shell uname -s)
# define PUSH to push upon build
ALL_TARGETS:=$(sort $(patsubst %/,%,$(dir $(wildcard */Dockerfile))))
# if a dir has a file named "skip" or "skip-build" (enforced later), don't build for it
TARGETS:=$(filter-out $(patsubst %/,%,$(dir $(wildcard */skip))),$(ALL_TARGETS))
# nor if it has a file "skip-`uname -m`"
TARGETS:=$(filter-out $(patsubst %/,%,$(dir $(wildcard */skip-$(CPU)))),$(TARGETS))
HAVE_DOCKER_BUILDX:=$(shell docker buildx >/dev/null 2>&1 && docker buildx ls | grep -q squid && echo yes)
BUILDX_ALL_TARGETS:=$(patsubst %,buildx-%,$(ALL_TARGETS))
BUILDX_TARGETS:=$(patsubst %,buildx-%,$(TARGETS))
PUSH_TARGETS:=$(patsubst %,push-%,$(TARGETS))
IS_PARALLEL=$(if $(findstring jobserver,$(MFLAGS)),1)
.PHONY: $(ALL_TARGETS) $(BUILDX_ALL_TARGETS) combination-filter update-image

# archutectures must be one of amd64, arm/v7l, arm64/v8
ARCH:=$(uname -m)

BUILDOPTS=
BUILDOPTS+=--pull
#BUILDIOTS+=--no-cache
ifeq ("$(SYSTEM)", "Darwin")
EXTRATAG:=-mac
else
EXTRATAG:=
endif

DATE=$(shell date +%y%m%d)

# ifneq ("$(LOG)", "")
# LOGCMD=2>&1 | tee -a $(LOG)
# endif

# args: distro, tag
make_manifest = \
	docker manifest rm squidcache/buildfarm-$(1):$(2) || true &&  \
	docker manifest create squidcache/buildfarm-$(1):$(2) \
		squidcache/buildfarm-x86_64-$(1):$(2) \
	$(if $(wildcard $(1)/skip-aarch64),, squidcache/buildfarm-aarch64-$(1):$(2)) \
	$(if $(wildcard $(1)/skip-armv7l),, squidcache/buildfarm-armv7l-$(1):$(2))

# args: distro, tag
push_manifest = \
	docker manifest push squidcache/buildfarm-$(1):$(2)

# args: distro, tag
push_image = \
	 docker push squidcache/buildfarm$(EXTRATAG)-$(CPU)-$(1):$(2)

prep = \
	mkdir -p "$1/local" && \
	rsync -a --delete local/all/* "$1/local"

testme:
	$(call make_manifest,centos-stream-8,latest)

default: help

list:
	@echo "all possible targets:"; echo "$(ALL_TARGETS)"; echo
	@echo "actual targets:"; echo "$(TARGETS)"; echo
	@echo "make all will build: "; echo "$(filter-out $(patsubst %/,buildx-%,$(dir $(wildcard */skip-build))),$(BUILDX_TARGETS))"

targets:
	@echo "$(TARGETS)"

buildx-targets:
	@echo "$(BUILDX_TARGETS)"

combination-filter:
	@for OS in $(TARGETS) ; do for CPU in armv7l aarch64 i386 amd64; do [ -e "$$OS/skip-$$CPU" ] && echo -n "!(OS == \"$$OS\" && CPU == \"$$CPU\") && " ; done; done || true; echo "true"

$(ALL_TARGETS):
	@(echo; echo; echo; echo "building $@") 
	$(call prep,$@)
	docker build $(BUILDOPTS) -t squidcache/buildfarm$(EXTRATAG)-$(CPU)-$@:latest -t squidcache/buildfarm$(EXTRATAG)-$(CPU)-$@:$(DATE) -f $@/Dockerfile $@ 2>&1 | tee $@.log
	rm -rf $@/local
	if test -n "$(PUSH)"; then $(call push_image,$@,latest) ; $(call push_image,$@,$(DATE)) ; fi 2>&1 | tee -a $@.log
	$(call make_manifest,$@,latest) 2>&1 | tee -a $@.log
	if test -n "$(PUSH)"; then $(call push_manifest,$@,latest) ; fi 2>&1 | tee -a $@.log
	mv $@.log $@.done.log

# assume it's run on amd64
$(BUILDX_ALL_TARGETS):
	@TGT=`echo $@ | sed 's/buildx-//'` ; \
	IMAGELABEL="squidcache/buildfarm$(EXTRATAG)-$$TGT:$${TAG:-latest}" ; \
	test -e $$TGT/skip-amd64 || PLATFORM="$$PLATFORM$${PLATFORM+,}amd64" ; \
	test -e $$TGT/skip-i386 || PLATFORM="$$PLATFORM$${PLATFORM+,}i386" ; \
	test -e $$TGT/skip-aarch64 || PLATFORM="$$PLATFORM$${PLATFORM+,}linux/arm64" ; \
	test -e $$TGT/skip-armv7l || PLATFORM="$$PLATFORM$${PLATFORM+,}linux/arm/v7" ; \
	echo "building $$TGT on $$PLATFORM , tag $$IMAGELABEL. Output in $@.log" ; \
    if [ "$(SYSTEM)" != "Darwin" ]; then PLATFORM="--platform $$PLATFORM"; else PLATFORM=""; fi; \
	$(call prep,$$TGT) >$@.log 2>&1 ; \
    echo "docker buildx build --progress=plain $${proxy:+--build-arg http_proxy=$$proxy} -t \"$$IMAGELABEL\" $$PLATFORM --push $$TGT" && \
	if docker buildx build --progress=plain $${proxy:+--build-arg http_proxy=$$proxy} -t "$$IMAGELABEL" $$PLATFORM --push $$TGT >>$@.log 2>&1 ; \
	then echo "SUCCESS for $$TGT"; mv $@.log $@.ok.log; else echo "FAILURE for $$TGT -log in $@.fail.log"; mv $@.log $@.fail.log; fi


# buildx all
all: $(filter-out $(patsubst %/,buildx-%,$(dir $(wildcard */skip-build))),$(BUILDX_TARGETS))

all-legacy: $(TARGETS)

push: $(PUSH_TARGETS)
#	$(call push_manifest,gentoo,latest)
#	for d in $(TARGETS); do $(call push_image,$$d,latest); $(call make_manifest,$$d,latest); $(call push_manifest,$$d,latest); done

prep-%:
	echo $@
	d="$(patsubst prep-%,%,$@)"; \
	$(call prep,$$d)

push-%:
	d="$(patsubst push-%,%,$@)"; \
	$(call push_image,$$d,latest) ; \
	$(call make_manifest,$$d,latest) ; \
	$(call push_manifest,$$d,latest) 

# promote "latest" image to "stable" in the repository
promote-%:
	d="$(patsubst promote-%,%,$@)"; \
    docker buildx imagetools create -t squidcache/buildfarm$(EXTRATAG)-$$d:oldstable squidcache/buildfarm-$$d:stable ; \
	docker buildx imagetools create -t squidcache/buildfarm$(EXTRATAG)-$$d:stable squidcache/buildfarm-$$d:latest 

promote:
	for d in $(TARGETS); do \
		make promote-$$d ; \
	done

clean:
	-for d in $(TARGETS); do test -d $$d/local && rm -rf $$d/local; done
	-rm *.log

clean-images:
	docker container prune -f
	docker image prune -f

clean-dangling-images:
	docker container prune -f
	docker images | grep -F '<none>' | awk '{print $$3}' | xargs -r docker rmi

clean-all-images: clean-images clean-dangling-images
	docker container prune -f
	docker images | grep -v -F -e REPOSITORY -e '<none>' | awk '{print $$1 ":" $$2 }' | uniq | xargs -r docker rmi
	docker images | grep -v -F -e REPOSITORY | awk '{print $$3}' | uniq | xargs -r docker rmi

## todo: need to call prep to update local
update-image:
	@if [ -z "$(DISTRO)" ]; then echo "use: make update-image DISTRO=distribution" ; exit 1; fi
	PLATFORM="$$(docker manifest inspect squidcache/buildfarm-$(DISTRO) | jq '.manifests[].platform.architecture' | grep -v unknown | sed 's/"//g;s/\/$$//' | tr '\n'  ',' | sed 's/,$$//;s/arm$$/arm\/v7l/')"; \
    echo "platforms: $$PLATFORM"; \
    $(call prep,update-image); \
    docker buildx build -t "squidcache/buildfarm$(EXTRATAG)-$(DISTRO)" --platform "$$PLATFORM" --push --squash --build-arg distro=$(DISTRO) $${proxy:+--build-arg http_proxy=$$proxy} -f update-image/Dockerfile.update-image update-image

help:
	@echo "possible targets: list, all, clean, clean-images, push, push-latest, promote, all-with-logs"
	@echo "BUILDOPTS: $(BUILDOPTS)"
	@echo "images that can be built: $(TARGETS)"

### old stuff
#promote-%:
#	d="$(patsubst promote-%,%,$@)"; \
# 	docker pull squidcache/buildfarm-$(CPU)-$$d:stable && \
# 	docker tag squidcache/buildfarm-$(CPU)-$$d:stable squidcache/buildfarm-$(CPU)-$$d:oldstable ;\
# 	docker pull squidcache/buildfarm-$(CPU)-$$d:latest && \
# 	docker tag squidcache/buildfarm-$(CPU)-$$d:latest squidcache/buildfarm-$(CPU)-$$d:stable ;\
# 	$(call push_image,$$d,oldstable); \
# 	$(call push_image,$$d,stable); \
# 	$(call make_manifest,$$d,oldstable); \
# 	$(call push_manifest,$$d,oldstable); \
# 	$(call make_manifest,$$d,stable); \
# 	$(call push_manifest,$$d,stable)

#promote:
#	for d in $(TARGETS); do \
#		docker pull squidcache/buildfarm-$(CPU)-$$d:stable && \
#		docker tag squidcache/buildfarm-$(CPU)-$$d:stable squidcache/buildfarm-$(CPU)-$$d:oldstable ;\
#		docker pull squidcache/buildfarm-$(CPU)-$$d:latest && \
#		docker tag squidcache/buildfarm-$(CPU)-$$d:latest squidcache/buildfarm-$(CPU)-$$d:stable ;\
#		$(call push_image,$$d,oldstable); \
#		$(call push_image,$$d,stable); \
#		$(call make_manifest,$$d,oldstable); \
#		$(call push_manifest,$$d,oldstable); \
#		$(call make_manifest,$$d,stable); \
#		$(call push_manifest,$$d,stable); \
#	done
