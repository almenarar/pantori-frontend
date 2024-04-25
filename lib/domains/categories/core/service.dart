import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/categories/core/ports.dart';


class CategoryService implements ServicePort {
  final BackendPort backend;

  CategoryService(this.backend);

  @override
  Future<List<Category>> list() async {
    return await backend.listCategories();
  }

  @override
  Future<void> create(Category category) async {
    await backend.createCategory(category);
    return;
  }

  @override
  Future<void> edit(Category category) async {
    await backend.editCategory(category);
    return;
  }

  @override
  Future<void> delete(Category category) async {
    await backend.deleteCategory(category);
    return;
  }
  
}