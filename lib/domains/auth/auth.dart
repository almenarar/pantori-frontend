import 'package:pantori/domains/auth/core/ports.dart';
import 'package:pantori/domains/auth/core/service.dart';
import 'package:pantori/domains/auth/infra/backend.dart';
import 'package:pantori/domains/auth/infra/local_storage.dart';

Future<AuthService> newAuthService(bool isProduction) async {
  LocalStoragePort storage = LocalStorage();
  await storage.init();

  BackendPort backend = Backend();
  backend.init(isProduction);

  return AuthService(backend, storage);
}