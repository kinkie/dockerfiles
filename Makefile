TARGETS=$(sort $(patsubst %-light,%,$(patsubst %/,%,$(dir $(wildcard */Dockerfile)))))
.PHONY: $(TARGETS)

default: help

list:
	@echo $(TARGETS)

$(TARGETS):
	mkdir -p $@/local
	rsync -a --delete local $@/
	docker build --pull -t farm-$(subst -light,,$@) -f $@/Dockerfile $@
	rm -rf $@/local

all: $(TARGETS)

push:
	for d in $(TARGETS); do docker tag farm-$$d squidcache/buildfarm:$$d && docker push squidcache/buildfarm:$$d; done

clean:
	for d in $(TARGETS); do test -d $$d/local && rm -rf $$d/local; done

clean-images:
	docker image prune -f

help:
	@echo "possible targets: list, all, clean, clean-images"
	@echo "                  $(TARGETS)"
