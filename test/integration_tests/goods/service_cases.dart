import 'package:pantori/domains/goods/core/good.dart';

class CreateCase {
  final String description;
  final Good good;
  final bool isInvalidPayloadError;

  CreateCase(this.description, this.good, this.isInvalidPayloadError);
}

class DeleteCase {
  final String description;
  final Good good;
  final bool isInvalidPayloadError;

  DeleteCase(this.description, this.good, this.isInvalidPayloadError);
}

class ListCase {
  final String description;

  ListCase(this.description);
}
