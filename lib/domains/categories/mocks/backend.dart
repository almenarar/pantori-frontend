import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/categories/core/ports.dart';

class BackendMock implements BackendPort {
  bool createCategoryInvoked = false;
  bool editCategoryInvoked = false;
  bool deleteCategoryInvoked = false;
  bool listCategoryInvoked = false;

  @override
  void init(bool isLocal) {}

  @override
  Future<void> createCategory(Category category) async {
    createCategoryInvoked = true;
    return;
  }

  @override
  Future<void> editCategory(Category category) async {
    editCategoryInvoked = true;
    return;
  }

  @override
  Future<void> deleteCategory(Category category) async {
    deleteCategoryInvoked = true;
    return;
  }

  @override
  Future<List<Category>> listCategories() async {
    listCategoryInvoked = true;
    return const [
      Category(
        id: "id1",
        color: "AAAAAAA",
        name: "john"
      ),
      Category(
        id: "id2",
        color: "HHHHHHH",
        name: "mary"
      ),
    ];
  }
}