import 'auth.dart';

abstract class ServicePort {
  Future<void> login(User user);
}

abstract class BackendPort {
  void init(bool isProduction);
  Future<String> getCredentials(User user);
}

abstract class LocalStoragePort {
  Future<void> init();
  Future<void> storeString(String key, value);
  Future<String> getString(String key);
}