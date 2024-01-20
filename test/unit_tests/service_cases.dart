import 'package:pantori/domain/good.dart';

class ListFilterIntervalsCase {
  final String description;

  ListFilterIntervalsCase(this.description);
}

class FilterCase {
  final String description;
  final List<Good> inputGoodList;
  final String inputCategory;
  final String inputInterval;
  final List<Good> outputGoodList;

  FilterCase(this.description, this.inputGoodList, this.inputCategory,
      this.inputInterval, this.outputGoodList);
}

class CreateGoodCase {
  final String description;
  final Good input;
  final String invocation;

  CreateGoodCase(this.description, this.input, this.invocation);
}

class DeleteGoodCase {
  final String description;
  final Good input;
  final String invocation;

  DeleteGoodCase(this.description, this.input, this.invocation);
}

class LoginCase {
  final String description;
  final String inputUser;
  final String inputPwd;
  final String invocation;

  LoginCase(this.description, this.inputUser, this.inputPwd, this.invocation);
}

class ListGoodsCase {
  final String description;
  final bool serverError;
  final List<Good> output;
  final String invocation;

  ListGoodsCase(this.description, this.serverError, this.output, this.invocation);
}