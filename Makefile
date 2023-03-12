# Note, 'v' version prefix added below
VERSION = 0.111.2
RELEASE:= v$(VERSION)
GO_REL  = 1.19.7
ifeq ($(origin DRIVER), undefined)
  ifneq ($(shell which podman 2>/dev/null || echo 0), 0)
    DRIVER := $(shell which podman)
  else ifneq ($(shell which docker 2>/dev/null || echo 0), 0)
    DRIVER := $(shell which docker)
  else
    $(error Could not find podman nor docker, please set DRIVER or install the necessary packages)
  endif
endif
IIDFILE:= $(shell mktemp /var/tmp/XXXXXX.id)
USERID := $(shell id -u):$(shell id -g)

default: copy

build:
	$(DRIVER) build --build-arg GO_REL=$(GO_REL) --build-arg RELEASE=$(RELEASE) -t build-hugo-$(USER) --iidfile $(IIDFILE) .

clean:
	rm -rf $(PWD)/dist

copy: build clean
	mkdir -p $(PWD)/dist
	$(DRIVER) run --rm -v $(PWD)/dist:/dist:Z $$(cat $(IIDFILE)) sh -c \
		'cp /go/bin/hugo /dist && chown $(USERID) /dist/hugo'
	# We do not know if DRIVER is rootless or not, so just in case try unshare.
	$(DRIVER) unshare chown 0:0 $(PWD)/dist/hugo 2>/dev/null || echo
