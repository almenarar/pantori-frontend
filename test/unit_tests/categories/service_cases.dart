import 'package:pantori/domains/categories/core/category.dart';

class DecodeCase {
  final String description;
  final String input;
  final Category output;

  DecodeCase(this.description, this.input, this.output);
}

class CreateCategoryCase {
  final String description;
  final Category input;
  final bool createFuncInvoked;

  CreateCategoryCase(this.description, this.input, this.createFuncInvoked);
}

class EditCategoryCase {
  final String description;
  final Category input;
  final bool editFuncInvoked;

  EditCategoryCase(this.description, this.input, this.editFuncInvoked);
}

class DeleteCategoryCase {
  final String description;
  final Category input;
  final bool deleteFuncInvoked;

  DeleteCategoryCase(this.description, this.input, this.deleteFuncInvoked);
}

class ListCategoriesCase {
  final String description;
  final List<Category> output;
  final bool listCategoriesFuncInvoked;

  ListCategoriesCase(
    this.description, 
    this.output,
    this.listCategoriesFuncInvoked
  );
}