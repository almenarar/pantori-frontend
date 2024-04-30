import 'dart:convert';

import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/categories/core/ports.dart';
import 'package:pantori/domains/categories/core/service.dart';
import 'package:pantori/domains/categories/mocks/backend.dart';

import 'package:flutter_test/flutter_test.dart';

import 'test_inputs.dart';
import 'service_cases.dart';


void main() {
  BackendMock backend = BackendMock();
  ServicePort service = CategoryService(backend);

  group("good object decode from json", () {
    final List<DecodeCase> testCases = [
      DecodeCase("successfull decode", TestInputs.inlineCategoryJson, TestInputs.defaultCategory)
    ];

    for (final testCase in testCases) {
      test(testCase.description, (){
        final map = jsonDecode(testCase.input) as Map<String, dynamic>;
        final good = Category.fromJson(map);
        expect(good, testCase.output);
      });
    }
  });


  group("create category", () {
    final List<CreateCategoryCase> testCases = [
      CreateCategoryCase("successfull run", TestInputs.defaultCategory, true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        await service.create(testCase.input);

        expect(backend.createCategoryInvoked, testCase.createFuncInvoked,reason: "backend");
      });
    }
  });

  group("edit category", () {
    final List<EditCategoryCase> testCases = [
      EditCategoryCase("successfull run", TestInputs.defaultCategory, true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        await service.edit(testCase.input);

        expect(backend.editCategoryInvoked, testCase.editFuncInvoked,reason: "backend");
      });
    }
  });

  group("delete category", () {
    final List<DeleteCategoryCase> testCases = [
      DeleteCategoryCase("successfull run", TestInputs.defaultCategory, true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        await service.delete(testCase.input);

        expect(backend.deleteCategoryInvoked, testCase.deleteFuncInvoked,reason: "backend");
      });
    }
  });

  group("list categories", () {
    final List<ListCategoriesCase> testCases = [
      ListCategoriesCase("successfull run", TestInputs.defaultCategoryList, true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        List<Category> output = await service.list();

        expect(backend.listCategoryInvoked, testCase.listCategoriesFuncInvoked,reason: "backend");
        expect(output, testCase.output);
      });
    }
  });
}