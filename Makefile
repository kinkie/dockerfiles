# define PUSH to push upon build
TARGETS=$(sort $(patsubst %/,%,$(dir $(wildcard */Dockerfile))))
.PHONY: $(TARGETS)
ARM_BLACKLIST=centos-6
CPU=$(shell uname -m)

default: help

list:
	@echo $(TARGETS)

$(TARGETS):
	mkdir -p $@/local
	rsync -a --delete local $@/
	docker build --pull -t farm-$@ -f $@/Dockerfile $@
	rm -rf $@/local
	if test -n "$(PUSH)"; then TAG=squidcache/buildfarm:$(CPU)-$@; docker tag farm-$@ $$TAG && docker push $$TAG; fi

all: $(TARGETS)

push:
	for d in $(TARGETS); do TAG=squidcache/buildfarm:$(CPU)-$$d; docker tag farm-$$d $$TAG && docker push $$TAG; done

clean:
	-for d in $(TARGETS); do test -d $$d/local && rm -rf $$d/local; done

clean-images:
	docker image prune -f

help:
	@echo "possible targets: list, all, clean, clean-images"
	@echo "                  $(TARGETS)"
