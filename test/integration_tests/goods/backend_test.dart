import 'package:pantori/domains/goods/core/good.dart';
import 'package:pantori/domains/goods/core/ports.dart';

import 'package:pantori/domains/goods/infra/backend.dart' as goods;
import 'package:pantori/domains/goods/infra/errors.dart';
import 'package:pantori/domains/goods/mocks/local_storage.dart';

import 'package:pantori/domains/auth/infra/backend.dart' as auth;
import 'package:pantori/domains/auth/core/auth.dart' as auth;

import 'package:flutter_test/flutter_test.dart';

import 'service_cases.dart';

void main() async {
  auth.Backend login = auth.Backend();
  login.init(false);

  String token = await login.getCredentials(auth.User(username: "dryrun", password: "dryrun"));

  LocalStoragePort storage = LocalStorageMock(token: token);
  BackendPort backend = goods.Backend(storage);
  backend.init(false);

  Good defaultGood = const Good(
      id: "130",
      name: "good1",
      categories: ["foo", "bar"],
      buyDate: "10/01/2024",
      expirationDate: "10/01/2024",
      imagePath: "",
      createdAt: ""
    );

  Good wrongGood = const Good(
      id: "",
      name: "",
      categories: ["foo", "bar"],
      buyDate: "10/01/2024",
      expirationDate: "2045-12-30T00:00:00Z",
      imagePath: "",
      createdAt: ""
    );

  group("create good", () {
    final List<CreateCase> testCases = [
      CreateCase("successfull run", defaultGood, false),
      CreateCase("incorrect input", wrongGood, true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        bool someError = false;
        try {
          await backend.createGood(testCase.good);
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

  group("delete good", () {
    final List<DeleteCase> testCases = [
      DeleteCase("successfull run", defaultGood, false),
      DeleteCase("incorrect input", wrongGood, true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        bool someError = false;
        try {
          await backend.deleteGood(testCase.good);
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

  group("list goods", () {
    final List<ListCase> testCases = [
      ListCase("successfull run"),
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        List<Good> output = await backend.listGoods();
        expect(output, hasLength(2));
        expect(output[0].name, "dryrun1");
        expect(output[1].name, "dryrun2");
      });
    }
  });
}
