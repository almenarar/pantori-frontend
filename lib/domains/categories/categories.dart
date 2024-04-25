import 'package:pantori/domains/categories/core/ports.dart';
import 'package:pantori/domains/categories/core/service.dart';
import 'package:pantori/domains/categories/infra/backend.dart';
import 'package:pantori/domains/categories/infra/local_storage.dart';

Future<CategoryService> newCategoryService(bool isProduction) async {
  LocalStoragePort storage = LocalStorage();
  await storage.init();

  BackendPort backend = Backend(storage);
  backend.init(isProduction);

  return CategoryService(backend);
}