# Pantori

This project aims to help users manage goods and expiration dates efficiently, preventing food waste. The system consists of a [Golang API](https://github.com/almenarar/pantori-backend) for goods registration, a NoSQL database (currently AWS DynamoDB in production) for data storage, and a Flutter frontend web application for user interaction (served via Nginx).

## Table of Contents
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the Project](#running-the-project-locally)
- [Project Structure](#project-structure)
- [External Dependencies](#external-dependencies)
- [Testing](#testing)

## Getting Started

### Prerequisites

Make sure you have the following software installed on your machine:

- Docker: [Install Docker](https://www.docker.com/get-started)
- Flutter: [Install Flutter](https://flutter.dev/)

### Installation

Clone the repository and install flutter files:

```bash
git clone https://github.com/almenarar/pantori-frontend.git
cd pantori-frontend
flutter pub get
```

### Running the project locally
This will require the backend running, don't forget to check [here first](https://github.com/almenarar/pantori-backend).

Use the provided Makefile to build and run the application. With flutter:

```bash
make run-debug
```

With nginx docker container:

```bash
make build
make run-container
```

## Project Structure

WIP. This project also follows the Hexagonal Architecture, more on that [here](https://github.com/almenarar/pantori-backend).

## External Dependencies

- [Equatable](https://pub.dev/packages/equatable)
- [intl](https://pub.dev/packages/intl)

## Testing

You can run unit tests with:

```bash
make unit
```

WIP. And integration tests with:

```bash
make integration
```