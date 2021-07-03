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

default: help

list:
	@echo "all possible targets:"; echo "$(ALL_TARGETS)"; echo
	@echo "actual targets:"; echo "$(TARGETS)"

targets:
	@echo "$(TARGETS)"

centos-stream-%: base-centos-stream-%

$(ALL_TARGETS):
	mkdir -p $@/local
	rsync -a --delete local $@/
	if test -x "$@/pre-build" ; then  (cd $@; ./pre-build); fi
	docker build $(BUILDOPTS) -t squidcache/buildfarm:$(CPU)-$@ -t squidcache/buildfarm-$(CPU)-$@:latest -f $@/Dockerfile $@
	rm -rf $@/local
	if test -n "$(PUSH)"; then docker push -a squidcache/buildfarm-$(CPU)-$@ ; fi

all: $(TARGETS)

all-with-logs:
	for t in $(TARGETS); do make $$t 2>&1 | tee $$t.log || mv $$t.log $$t-failed.log; done

# push locally-built images to the repository
push:
	for d in $(TARGETS); do TAG=squidcache/buildfarm-$(CPU)-$$d ; docker push -a $$TAG; done

# promote "latest" image to "stable" in the repository
promote:
	for d in $(TARGETS); do TAG=squidcache/buildfarm-$(CPU)-$$d; docker tag $$TAG:latest $$TAG:stable; docker push $$TAG:stable; done

clean:
	-for d in $(TARGETS); do test -d $$d/local && rm -rf $$d/local; done
	-rm *.log

clean-images:
	docker image prune -f

clean-all-images:
	docker ps -a | grep -vF IMAGE | awk '{print $1}' | sort -u | xargs docker rm
	docker images | awk '{print $1 ":" $2}'| sort -u | xargs docker rmi

help:
	@echo "possible targets: list, all, clean, clean-images, push, promote, all-with-logs"
	@echo "BUILDOPTS: $(BUILDOPTS)"
	@echo "images that can be built: $(TARGETS)"
