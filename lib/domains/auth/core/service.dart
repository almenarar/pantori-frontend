import 'package:pantori/domains/auth/core/auth.dart';
import 'package:pantori/domains/auth/core/ports.dart';

class AuthService implements ServicePort {
  final BackendPort backend;
  final LocalStoragePort storage;

  AuthService(this.backend, this.storage);

  @override
  Future<void> login(User user) async {
    String token = await backend.getCredentials(user);
    await storage.storeString('sessionToken',token);
    return;
  }
}