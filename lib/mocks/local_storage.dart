import 'package:pantori/domain/ports.dart';

class LocalStorageMock implements LocalStoragePort {
  String token = '';

  @override
  Future<void> init() async {
    return;
  }

  @override
  Future<String> getString(String key) async {
    return token;
  }

  @override
  Future<void> storeString(String value) async {
    token = value;
    return;
  }
}
