DOCKER_IMAGE_TAG=renoise-8-bit-sample-loader

.PHONY: test
test:
	docker run --rm -t -v $(shell pwd):/app -w /app $(DOCKER_IMAGE_TAG) \
		busted --lua=luajit

.PHONY: build
build:
	docker build -t $(DOCKER_IMAGE_TAG) .
