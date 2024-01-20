class UserLoginError implements Exception {
  final String message;

  UserLoginError(this.message);

  @override
  String toString() => message;
}

class ServerLoginError implements Exception {
  final String message;

  ServerLoginError(this.message);

  @override
  String toString() => message;
}
