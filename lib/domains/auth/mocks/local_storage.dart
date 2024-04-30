import 'package:pantori/domains/auth/core/ports.dart';

class LocalStorageMock implements LocalStoragePort {
  bool storeStringInvoked = false;

  @override
  Future<void> init() async {
    return;
  }

  @override
  Future<String> getString(String key) async {
    return "token";
  }

  @override
  Future<void> storeString(String key, value) async {
    storeStringInvoked = true;
    return;
  }
}
