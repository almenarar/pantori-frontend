# Makefile for building and running Flutter web app with Nginx Docker container
.PHONY: force
# Set the name for your Docker image
IMAGE_NAME = flutter-web-nginx

unit:
	flutter test test/unit_tests/service_test.dart

integration:
	flutter test test/integration_tests/backend_test.dart

# Build the Docker image
build: force
	docker build -t $(IMAGE_NAME) .

# Run the Docker container
run: force
	docker run -p 8080:80 $(IMAGE_NAME)
