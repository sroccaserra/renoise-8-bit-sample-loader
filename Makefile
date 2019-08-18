DOCKER_IMAGE_TAG=renoise-8-bit-sample-loader

test:
	docker run --rm -t -v $(shell pwd):/app -w /app $(DOCKER_IMAGE_TAG) \
		busted --lua=luajit

build:
	docker build -t $(DOCKER_IMAGE_TAG) .
