import 'package:pantori/domains/categories/core/category.dart';

class CreateCase {
  final String description;
  final Category category;
  final bool isInvalidPayloadError;

  CreateCase(this.description, this.category, this.isInvalidPayloadError);
}

class DeleteCase {
  final String description;
  final Category category;
  final bool isInvalidPayloadError;

  DeleteCase(this.description, this.category, this.isInvalidPayloadError);
}

class ListCase {
  final String description;

  ListCase(this.description);
}