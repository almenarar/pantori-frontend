import 'package:pantori/domain/good.dart';

class LoginCase {
  final String description;
  final String username;
  final String pwd;
  final bool isUserLoginError;

  LoginCase(this.description, this.username, this.pwd, this.isUserLoginError);
}

class CreateCase {
  final String description;
  final Good good;
  final bool isInvalidPayloadError;

  CreateCase(this.description, this.good, this.isInvalidPayloadError);
}

class DeleteCase {
  final String description;
  final Good good;

  DeleteCase(this.description, this.good);
}

class ListCase {
  final String description;

  ListCase(this.description);
}