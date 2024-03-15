.PHONY: force
IMAGE_NAME = pantori-frontend
DOCKER_TAG = $(shell git rev-parse --short HEAD)

unit:
	flutter test test/unit_tests/service_test.dart

integration:
	flutter test test/integration_tests/backend_test.dart

build: force
	flutter build web --web-renderer html
	docker build -t $(IMAGE_NAME) .

run: force
	docker run -p 8080:80 $(IMAGE_NAME)

build-and-push:
	docker build --platform=linux/amd64 -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(DOCKER_TAG)
	aws lightsail push-container-image --region us-east-1 --service-name pantori-app --label frontend --image $(IMAGE_NAME):$(DOCKER_TAG)