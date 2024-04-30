import 'package:pantori/domains/goods/core/good.dart';

class DecodeCase {
  final String description;
  final String input;
  final Good output;

  DecodeCase(this.description, this.input, this.output);
}

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

  FilterCase(
    this.description, 
    this.inputGoodList, 
    this.inputCategory,
    this.inputInterval, 
    this.outputGoodList
  );
}

class CreateGoodCase {
  final String description;
  final Good input;
  final bool createFuncInvoked;

  CreateGoodCase(this.description, this.input, this.createFuncInvoked);
}

class EditGoodCase {
  final String description;
  final Good input;
  final bool editFuncInvoked;

  EditGoodCase(this.description, this.input, this.editFuncInvoked);
}

class ReplaceGoodCase {
  final String description;
  final Good goodInput;
  final String dateInput;
  final bool editFuncInvoked;

  ReplaceGoodCase(this.description, this.goodInput, this.dateInput, this.editFuncInvoked);
}

class DeleteGoodCase {
  final String description;
  final Good input;
  final bool deleteFuncInvoked;

  DeleteGoodCase(this.description, this.input, this.deleteFuncInvoked);
}

class LoginCase {
  final String description;
  final String inputUser;
  final String inputPwd;
  final bool loginFuncInvoked;

  LoginCase(
    this.description, 
    this.inputUser, 
    this.inputPwd, 
    this.loginFuncInvoked
  );
}

class ListGoodsCase {
  final String description;
  final bool serverError;
  final List<Good> output;
  final bool listGoodsFuncInvoked;

  ListGoodsCase(
    this.description, 
    this.serverError, 
    this.output,
    this.listGoodsFuncInvoked
  );
}
