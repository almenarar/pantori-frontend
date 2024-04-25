import 'package:pantori/domains/goods/core/ports.dart';

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
}
