# define PUSH to push upon build
ALL_TARGETS:=$(sort $(patsubst %/,%,$(dir $(wildcard */Dockerfile))))
# if a dir has a file named "skip", don't build for it
TARGETS:=$(filter-out $(patsubst %/,%,$(dir $(wildcard */skip))),$(ALL_TARGETS))
CPU:=$(shell uname -m)
# nor if it has a file "skip-`uname -m`"
TARGETS:=$(filter-out $(patsubst %/,%,$(dir $(wildcard */skip-$(CPU)))),$(TARGETS))
.PHONY: $(ALL_TARGETS)

# archutectures must be one of amd64, arm/v7l, arm64/v8
ARCH:=$(uname -m)

BUILDOPTS=
BUILDOPTS+=--pull
#BUILDIOTS+=--no-cache
HAVE_EXPERIMENTAL=$(shell grep experimental /etc/docker/daemon.json)
ifneq ("$(HAVE_EXPERIMENTAL)", "")
BUILDOPTS+=--squash
endif

# ifneq ("$(LOG)", "")
# LOGCMD=2>&1 | tee -a $(LOG)
# endif

# args: distro, tag
make_manifest = \
	docker manifest create squidcache/buildfarm-$(1):$(2) \
		--amend squidcache/buildfarm-x86_64-$(1):$(2) \
	$(if $(wildcard $(1)/skip-aarch64),, --amend squidcache/buildfarm-aarch64-$(1):$(2)) \
	$(if $(wildcard $(1)/skip-armv7l),, --amend squidcache/buildfarm-armv7l-$(1):$(2))

# args: distro, tag
push_manifest = \
	docker manifest push squidcache/buildfarm-$(1):$(2)

# args: distro, tag
push_image = \
     docker push squidcache/buildfarm-$(CPU)-$(1):$(2)

testme:
	$(call make_manifest,centos-stream-8,latest)

default: help

list:
	@echo "all possible targets:"; echo "$(ALL_TARGETS)"; echo
	@echo "actual targets:"; echo "$(TARGETS)"

targets:
	@echo "$(TARGETS)"

$(ALL_TARGETS):
	(echo; echo; echo; echo "building $@") 
	mkdir -p $@/local
	rsync -a --delete local/all/* $@/local
	rsync -a --delete local/`uname -m`/* $@/local
	docker build $(BUILDOPTS) -t squidcache/buildfarm-$(CPU)-$@:latest -t squidcache/buildfarm-$@:latest -f $@/Dockerfile $@ 2>&1 | tee $@.log
	rm -rf $@/local
	if test -n "$(PUSH)"; then $(call push_image,$@,latest) ; fi 2>&1 | tee -a $@.log
	$(call make_manifest,$@,latest) 2>&1 | tee -a $@.log
	if test -n "$(PUSH)"; then $(call push_manifest,$@,latest) ; fi 2>&1 | tee -a $@.log
	mv $@.log $@.done.log

all: $(TARGETS)

push:
	for d in $(TARGETS); do $(call push_image,$$d,latest); $(call make_manifest,$$d,latest); $(call push_manifest,$$d,latest); done

# promote "latest" image to "stable" in the repository
promote:
	for d in $(TARGETS); do \
		docker tag squidcache/buildfarm-$(CPU)-$$d:latest squidcache/buildfarm-$(CPU)-$$d:stable ;\
		$(call push_image,$$d,stable); \
		$(call make_manifest,$$d,stable); \
		$(call push_manifest,$$d,stable); \
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

help:
	@echo "possible targets: list, all, clean, clean-images, push, push-latest, promote, all-with-logs"
	@echo "BUILDOPTS: $(BUILDOPTS)"
	@echo "images that can be built: $(TARGETS)"
