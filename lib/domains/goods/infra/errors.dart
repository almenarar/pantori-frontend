class ServerLoginError implements Exception {
  final String message;

  ServerLoginError(this.message);

  @override
  String toString() => message;
}

class UserInputError implements Exception {
  final String message;

  UserInputError(this.message);

  @override
  String toString() => message;
}