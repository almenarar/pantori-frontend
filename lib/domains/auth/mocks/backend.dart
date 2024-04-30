import 'package:pantori/domains/auth/core/auth.dart';
import 'package:pantori/domains/auth/core/ports.dart';

class BackendMock implements BackendPort {
  bool loginInvoked = false;

  @override
  void init(bool isLocal) {}

  @override
  Future<String> getCredentials(User user) async {
    loginInvoked = true;
    return "token";
  }
}