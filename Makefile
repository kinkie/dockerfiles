# define PUSH to push upon build
ALL_TARGETS:=$(sort $(patsubst %/,%,$(dir $(wildcard */Dockerfile))))
# if a dir has a file named "skip", don't build for it
TARGETS:=$(filter-out $(patsubst %/,%,$(dir $(wildcard */skip))),$(ALL_TARGETS))
CPU:=$(shell uname -m)
# nor if it has a file "skip-`uname -m`"
TARGETS:=$(filter-out $(patsubst %/,%,$(dir $(wildcard */skip-$(CPU)))),$(TARGETS))
.PHONY: $(ALL_TARGETS)
BUILDOPTS=
BUILDOPTS+=--pull
#BUILDIOTS+=--no-cache
HAVE_EXPERIMENTAL=$(shell grep experimental /etc/docker/daemon.json)
ifneq ("$(HAVE_EXPERIMENTAL)", "")
BUILDOPTS+=--squash
endif

ifneq ("$(LOG)", "")
LOGCMD=2>&1 | tee -a $(LOG)
endif

default: help

list:
	@echo "all possible targets:"; echo "$(ALL_TARGETS)"; echo
	@echo "actual targets:"; echo "$(TARGETS)"

targets:
	@echo "$(TARGETS)"

$(ALL_TARGETS):
	(echo; echo; echo; echo "building $@") $(LOGCMD)
	mkdir -p $@/local
	rsync -a --delete local $@/
	docker build $(BUILDOPTS) -t squidcache/buildfarm:$(CPU)-$@ -t squidcache/buildfarm-$(CPU)-$@:latest -f $@/Dockerfile $@ 2>&1 | tee $@.log $(LOGCMD)
	rm -rf $@/local
	if test -n "$(PUSH)"; then docker push -a squidcache/buildfarm-$(CPU)-$@ ; fi

all: $(TARGETS)

all-with-logs:
	for t in $(TARGETS); do make $$t 2>&1 | tee $$t.log || mv $$t.log $$t-failed.log; done

# push locally-built images to the repository
push:
	for d in $(TARGETS); do TAG=squidcache/buildfarm-$(CPU)-$$d ; docker push -a $$TAG; done

push-latest:
	docker images | grep latest | grep squidcache/buildfarm-armv7l| awk '{print $$1}'|xargs -n 1 docker push -a

# promote "latest" image to "stable" in the repository
promote:
	for d in $(TARGETS); do TAG=squidcache/buildfarm-$(CPU)-$$d; docker tag $$TAG:latest $$TAG:stable; docker push $$TAG:stable; done

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
