# Note, 'v' version prefix added below
VERSION = 0.57.2
COMMIT := v$(VERSION)
GO_REL  = 1.12.9
DOCKER ?= $(shell which docker)
IIDFILE:= $(shell mktemp /var/tmp/XXXXXX.id)
USERID  = $(shell id -u):$(shell id -g)

default: copy

build:
	$(DOCKER) build --build-arg GO_REL=$(GO_REL) --build-arg COMMIT=$(COMMIT) -t build-hugo-$(USER) --iidfile $(IIDFILE) .

clean:
	rm -rf $(PWD)/dist

copy: build clean
	mkdir -p $(PWD)/dist
	$(DOCKER) run --rm -v $(PWD)/dist:/dist -u $(USERID) $$(cat $(IIDFILE)) sh -c \
		'cp /go/bin/hugo /dist'

