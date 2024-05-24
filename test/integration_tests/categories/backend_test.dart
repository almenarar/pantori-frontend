import 'package:flutter_test/flutter_test.dart';

import 'package:pantori/domains/auth/infra/backend.dart' as auth;
import 'package:pantori/domains/auth/core/auth.dart' as auth;

import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/categories/core/ports.dart';

import 'package:pantori/domains/categories/infra/backend.dart';
import 'package:pantori/domains/categories/infra/errors.dart';

import 'package:pantori/domains/categories/mocks/local_storage.dart';

import 'service_cases.dart';

void main() async {
  auth.Backend login = auth.Backend();
  login.init(false);

  String token = await login.getCredentials(auth.User(username: "dryrun", password: "dryrun"));

  LocalStoragePort storage = LocalStorageMock(token: token);
  BackendPort backend = Backend(storage);
  backend.init(false);

  Category defaultCategory = const Category(id: "id", color: "color", name: "name");
  Category wrongCategory = const Category(id: "", color: "err", name: "");

  group("create category", () {
      final List<CreateCase> testCases = [
        CreateCase("successfull run", defaultCategory, false),
        CreateCase("incorrect input", wrongCategory, true)
      ];

      for (final testCase in testCases) {
      test(testCase.description, () async {
        bool someError = false;
        try {
          await backend.createCategory(testCase.category);
        } catch (error) {
          if (testCase.isInvalidPayloadError) {
            someError = true;
            expect(error, const TypeMatcher<UserInputError>());
          } else {
            rethrow;
          }
        }
        expect(someError, testCase.isInvalidPayloadError);
      });
    }
  });

  group("delete category", () {
    final List<DeleteCase> testCases = [
      DeleteCase("successfull run", defaultCategory, false),
      DeleteCase("incorrect input", wrongCategory, true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        bool someError = false;
        try {
          await backend.deleteCategory(testCase.category);
        } catch (error) {
          if (testCase.isInvalidPayloadError) {
            someError = true;
            expect(error, const TypeMatcher<UserInputError>());
          } else {
            rethrow;
          }
        }
        expect(someError, testCase.isInvalidPayloadError);
      });
    }
  });

  group("list categories", () {
    final List<ListCase> testCases = [
      ListCase("successfull run"),
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        List<Category> output = await backend.listCategories();
        expect(output, hasLength(2));
        expect(output[0].name, "dryrun1");
        expect(output[1].name, "dryrun2");
      });
    }
  });
}