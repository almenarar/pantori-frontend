import 'package:pantori/domains/categories/core/category.dart';

abstract class ServicePort {
  Future<List<Category>> list();
  Future<void> create(Category category);
  Future<void> edit(Category category);
  Future<void> delete(Category category);
}

abstract class BackendPort {
  void init(bool isProduction);
  Future<List<Category>> listCategories();
  Future<void> createCategory(Category category);
  Future<void> editCategory(Category category);
  Future<void> deleteCategory(Category category);
}

abstract class LocalStoragePort {
  Future<void> init();
  Future<String> getString(String key);
}