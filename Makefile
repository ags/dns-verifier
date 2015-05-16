PROJECT ?= agsmith/dns-verifier
TAG     ?= v1
IMAGE    = $(PROJECT):$(TAG)

.PHONY: test run repl

build: Dockerfile
	docker build --rm -t $(IMAGE) .

test: build
	docker run --rm -it $(IMAGE) cabal test

run: build
	docker run --rm -it -p 3000:3000 $(IMAGE)

repl: build
	docker run --rm -it $(IMAGE) cabal repl
