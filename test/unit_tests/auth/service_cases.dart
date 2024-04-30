import 'package:pantori/domains/auth/core/auth.dart';

class LoginCase {
  final String description;
  final User input;
  final bool loginFuncInvoked;
  final bool storeStringInvoked;

  LoginCase(this.description, this.input, this.loginFuncInvoked, this.storeStringInvoked);
}
