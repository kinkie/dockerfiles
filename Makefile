# REGISTRY:=ghcr.io/kinkie/dockerfiles
REGISTRY:=squidcache
TEST_REPO:=https://github.com/squid-cache/squid

SYSTEM:=$(shell uname -s)
# define PUSH to push upon build
ALL_TARGETS:=$(sort $(patsubst %/,%,$(dir $(wildcard */Dockerfile))))
# if a dir has a file named "skip" or "skip-build" (enforced later), don't build for it
TARGETS:=$(filter-out $(patsubst %/,%,$(dir $(wildcard */skip))),$(ALL_TARGETS))
BUILD_TARGETS:=$(filter-out $(patsubst %/,%,$(dir $(wildcard */skip-build))),$(TARGETS))
# IS_PARALLEL=$(if $(findstring jobserver,$(MFLAGS)),1)
.PHONY: $(ALL_TARGETS) exclude-list update-image

# must be one of amd64, arm/v7l, arm64/v8, riscv64
ALL_PLATFORMS=amd64 i386 arm64 arm riscv64 mips64le ppc64le

BUILDOPTS=
BUILDOPTS+=--pull
EXTRATAG:=

DATE:=$(shell date +%y%m%d)
SED:=sed

default: help

list:
	@echo "all possible targets:"; echo "$(ALL_TARGETS)"; echo
	@echo "actual targets:"; echo "$(TARGETS)"; echo
	@echo "'make all' will build:"; echo "$(BUILD_TARGETS)"; echo

targets:
	@for tgt in $(TARGETS); do echo "- $$tgt"; done

exclude-list:
	@for CPU in $(ALL_PLATFORMS); do \
		for OS in $(TARGETS) ; do \
			if ! grep -q "PLATFORMS.*\<$$CPU\>" $$OS/Dockerfile; then \
                echo "          - { platform: $$CPU, os: $$OS }" ;\
			fi ; \
        done; \
    done # | $(SED) 's/\<arm\>/&\/v7/g'

combination-filter:
	@for CPU in $(ALL_PLATFORMS); do \
		for OS in $(TARGETS) ; do \
			if ! grep -q "PLATFORMS.*\<$$CPU\>" $$OS/Dockerfile; then \
                echo -n "!(OS == \"$$OS\" && CPU == \"$$CPU\") && " ; \
			fi ; \
        done; \
    done ; echo "true"

# form: test_<os>_<arch>
test_%:
	@os=$(word 2,$(subst _, ,$@)); \
	arch=$(word 3,$(subst _, ,$@)); \
	echo "testing os: $$os, arch: $$arch. Output in test-$$os-$$arch.out" ;\
	docker run -i --rm --platform $$arch \
		"$(REGISTRY)/buildfarm$(EXTRATAG)-$$os:latest" bash -c \
		"export pjobs=\"-j`nproc` -l`nproc`\" && cd && git clone --depth=1 $(TEST_REPO) && cd squid && ./test-builds.sh --verbose layer-02-maximus" \
		>test-$$os-$$arch.out 2>test-$$os-$$arch.err && \
		touch test-$$os-$$arch.ok || \
		touch test-$$os-$$arch.fail ; \
	docker ps --format '{{.Image}}' | grep -q "buildfarm$(EXTRATAG)-$$os:latest" || \
        docker rmi "$(REGISTRY)/buildfarm$(EXTRATAG)-$$os:latest"

test:
	@targets=""; \
	for os in $(TARGETS) ; do \
		for arch in $(ALL_PLATFORMS); do \
			if grep -q "PLATFORMS.*\<$$arch\>" $$os/Dockerfile; then \
				targets="$${targets} test_$${os}_$${arch}" ;\
			fi ;\
		done ;\
	done; \
	$(MAKE) $$targets

# assume it's run on amd64
$(ALL_TARGETS):
	-rm $@.ok $@.fail
	@TGT=$@; \
	IMAGELABELBASE="$(REGISTRY)/buildfarm$(EXTRATAG)-$$TGT" ; \
	IMAGELABEL="-t $$IMAGELABELBASE:latest -t $$IMAGELABELBASE:$(DATE)" ;\
	PLATFORM=`grep PLATFORMS $$TGT/Dockerfile | $(SED) 's!.*PLATFORMS  *!!;s!\<!linux/!g;s!\<arm\>!arm/v7!g;s! !,!g'` ;\
	echo "docker buildx build $$IMAGELABEL --platform $$PLATFORM --push $$TGT" ; \
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
	-rm log-* *.log *.out *.err *.ok *.fail

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
	PLATFORM="$$(docker manifest inspect $(REGISTRY)/buildfarm-$(DISTRO) | jq '.manifests[].platform.architecture' | grep -v unknown | $(SED) 's/"//g;s/\/$$//' | tr '\n'  ',' | $(SED) 's/,$$//;s/arm$$/arm\/v7l/')"; \
    echo "platforms: $$PLATFORM"; \
    docker buildx build -t "$(REGISTRY)/buildfarm$(EXTRATAG)-$(DISTRO)" --platform "$$PLATFORM" --push --squash --build-arg distro=$(DISTRO) $${proxy:+--build-arg http_proxy=$$proxy} -f update-image/Dockerfile.update-image update-image

help:
	@echo "possible targets:"
	@echo "  list, targets, exclude-list"
	@echo "  all: build targets in 'make list'"
	@echo "  promote, promote-<target>, update-image DISTRO=<image>"
	@echo "  test: try a squid build on all cpu-arch combos with latest image"
