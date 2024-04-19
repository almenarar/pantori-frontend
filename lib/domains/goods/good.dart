import 'package:pantori/domains/goods/core/ports.dart';
import 'package:pantori/domains/goods/core/service.dart';
import 'package:pantori/domains/goods/infra/backend.dart';
import 'package:pantori/domains/goods/infra/local_storage.dart';
import 'package:pantori/domains/goods/infra/time.dart';

Future<GoodService> newGoodService(bool isProduction) async {
  LocalStoragePort storage = LocalStorage();
  await storage.init();

  BackendPort backend = Backend(storage);
  backend.init(isProduction);

  TimePort time = Time();
  return GoodService(backend, time);
}