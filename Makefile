# REGISTRY:=ghcr.io/kinkie/dockerfiles
REGISTRY:=docker.io/squidcache

SYSTEM:=$(shell uname -s)
# define PUSH to push upon build
ALL_TARGETS:=$(sort $(patsubst %/,%,$(dir $(wildcard */Dockerfile))))
# if a dir has a file named "skip" or "skip-build" (enforced later), don't build for it
TARGETS:=$(filter-out $(patsubst %/,%,$(dir $(wildcard */skip))),$(ALL_TARGETS))
BUILD_TARGETS:=$(filter-out $(patsubst %/,%,$(dir $(wildcard */skip-build))),$(TARGETS))
# IS_PARALLEL=$(if $(findstring jobserver,$(MFLAGS)),1)
.PHONY: $(ALL_TARGETS) exclude-list update-image

# must be one of amd64, arm/v7l, arm64/v8, riscv64
ALL_PLATFORMS=amd64 arm64 arm riscv64 mips64le ppc64le

BUILDOPTS=
BUILDOPTS+=--pull
#BUILDIOTS+=--no-cache
ifeq ("$(SYSTEM)", "Darwin")
EXTRATAG:=-mac
else
EXTRATAG:=
endif

DATE:=$(shell date +%y%m%d)

default: help

list:
	@echo "all possible targets:"; echo "$(ALL_TARGETS)"; echo
	@echo "actual targets:"; echo "$(TARGETS)"; echo
	@echo "'make all' will build:"; echo "$(BUILD_TARGETS)"; echo

targets:
	@echo "$(TARGETS)"

# TODO: platforms doesn't have i386
exclude-list:
	@for CPU in $(ALL_PLATFORMS); do \
		for OS in $(TARGETS) ; do \
            grep -q "PLATFORMS.*\<$$CPU\>" $$OS/Dockerfile || \
                echo "          - { platform: $$CPU, os: $$OS }" ;\
        done; \
    done # | sed 's/\<arm\>/&\/v7/g'

# assume it's run on amd64
$(ALL_TARGETS):
	-rm $@.ok $@.fail
	@TGT=$@; \
	IMAGELABELBASE="$(REGISTRY)/buildfarm$(EXTRATAG)-$$TGT" ; \
	IMAGELABEL="-t $$IMAGELABELBASE:latest -t $$IMAGELABELBASE:$(DATE)" ;\
	PLATFORM=`grep PLATFORMS $$TGT/Dockerfile | sed 's!.*PLATFORMS  *!!;s!\<!linux/!g;s!\<arm\>!arm/v7!g;s! !,!g'` ;\
	echo "building $$TGT on $$PLATFORM , tag $$IMAGELABEL" ; \
    if docker buildx build $$IMAGELABEL --platform $$PLATFORM --push $$TGT ; then \
	  touch $$TGT.ok; else touch $$TGT.fail ; \
	fi


#	if docker buildx build --builder squid --progress=plain $${proxy:+--build-arg http_proxy=$$proxy} -t "$$IMAGELABEL" $$PLATFORM --output type=image,name=$(REGISTRY)/$$TGT,push=true $$TGT >>$@.log 2>&1 ; \

all: $(BUILD_TARGETS)

# promote "latest" image to "stable" in the repository
promote-%:
	d="$(patsubst promote-%,%,$@)"; \
    docker buildx imagetools create -t $(REGISTRY)/buildfarm$(EXTRATAG)-$$d:oldstable $(REGISTRY)/buildfarm-$$d:stable ; \
	docker buildx imagetools create -t $(REGISTRY)/buildfarm$(EXTRATAG)-$$d:stable $(REGISTRY)/buildfarm-$$d:latest

promote:
	for d in $(TARGETS); do \
		make promote-$$d ; \
	done

clean:
	-rm log-* *.log

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

update-image:
	@if [ -z "$(DISTRO)" ]; then echo "use: make update-image DISTRO=distribution" ; exit 1; fi
	PLATFORM="$$(docker manifest inspect $(REGISTRY)/buildfarm-$(DISTRO) | jq '.manifests[].platform.architecture' | grep -v unknown | sed 's/"//g;s/\/$$//' | tr '\n'  ',' | sed 's/,$$//;s/arm$$/arm\/v7l/')"; \
    echo "platforms: $$PLATFORM"; \
    docker buildx build -t "$(REGISTRY)/buildfarm$(EXTRATAG)-$(DISTRO)" --platform "$$PLATFORM" --push --squash --build-arg distro=$(DISTRO) $${proxy:+--build-arg http_proxy=$$proxy} -f update-image/Dockerfile.update-image update-image

help:
	@echo "possible targets: list, all, clean, clean-images, push, push-latest, promote, all-with-logs, combination-filter"
	@echo "BUILDOPTS: $(BUILDOPTS)"
	@echo "images that can be built: $(TARGETS)"
