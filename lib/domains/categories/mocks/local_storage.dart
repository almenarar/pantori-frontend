import 'package:pantori/domains/categories/core/ports.dart';

class LocalStorageMock implements LocalStoragePort {
  final String token;

  LocalStorageMock({required this.token});

  @override
  Future<void> init() async {
    return;
  }

  @override
  Future<String> getString(String key) async {
    return token;
  }
}
