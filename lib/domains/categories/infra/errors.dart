class ServerError implements Exception {
  final String message;

  ServerError(this.message);

  @override
  String toString() => message;
}

class RequestError implements Exception {
  final String message;

  RequestError(this.message);

  @override
  String toString() => message;
}

class UserInputError implements Exception {
  final String message;

  UserInputError(this.message);

  @override
  String toString() => message;
}