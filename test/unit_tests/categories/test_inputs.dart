import 'package:pantori/domains/categories/core/category.dart';

class TestInputs {
  static const Category defaultCategory = Category(
    id: "1",
    color: "AAAAAAA",
    name: "dinner"
  );

  static const String inlineCategoryJson = '{"Name":"dinner","Color":"AAAAAAA","ID":"1"}';

  static const List<Category> defaultCategoryList = [
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