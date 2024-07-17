.PHONY: force
IMAGE_NAME = pantori-frontend
DOCKER_TAG = $(shell git rev-parse --short HEAD)

open-coverage:
	open coverage/html/index.html

unit:
	flutter test --coverage test/unit_tests/goods/service_test.dart test/unit_tests/auth/service_test.dart test/unit_tests/categories/service_test.dart
	genhtml coverage/lcov.info -o coverage/html

integration:
	flutter test test/integration_tests/goods/backend_test.dart test/integration_tests/categories/backend_test.dart

build: force
	flutter build web --web-renderer html
	docker build -t $(IMAGE_NAME) .

run-debug: force
	flutter run -d chrome --web-renderer html

run-container: force
	docker run -p 8080:80 $(IMAGE_NAME)

build-and-push:
	flutter build web --web-renderer html
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 471112738977.dkr.ecr.us-east-1.amazonaws.com
	docker build --platform=linux/amd64 -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME):latest 471112738977.dkr.ecr.us-east-1.amazonaws.com/$(IMAGE_NAME):$(DOCKER_TAG)
	docker push 471112738977.dkr.ecr.us-east-1.amazonaws.com/$(IMAGE_NAME):$(DOCKER_TAG)