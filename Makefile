# Note, 'v' version prefix added below
VERSION = 0.54.0
COMMIT := v$(VERSION)
DOCKER ?= $(shell which docker)
IIDFILE:= $(shell mktemp /var/tmp/XXXXXX.id)
USERID  = $(shell id -u):$(shell id -g)

default: copy

build:
	$(DOCKER) build --build-arg REF=$(COMMIT) -t build-hugo-$(USER) --iidfile $(IIDFILE) .

clean:
	rm -rf $(PWD)/dist

copy: build clean
	mkdir -p $(PWD)/dist
	$(DOCKER) run --rm -v $(PWD)/dist:/dist $$(cat $(IIDFILE)) sh -c \
		'cp /go/bin/hugo /dist && chown $(USERID) -R /dist'

