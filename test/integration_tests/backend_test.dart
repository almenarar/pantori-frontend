import 'package:pantori/domains/goods/core/good.dart';
import 'package:pantori/domains/goods/core/ports.dart';

import 'package:pantori/domains/goods/infra/backend.dart';
import 'package:pantori/domains/goods/infra/errors.dart';

import 'package:pantori/domains/goods/mocks/local_storage.dart';

import 'package:flutter_test/flutter_test.dart';

import 'service_cases.dart';

void main() {
  LocalStoragePort storage = LocalStorageMock();
  BackendPort backend = Backend(storage);
  backend.init(true);

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
      name: "good1",
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
      DeleteCase("successfull run", defaultGood),
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        await backend.deleteGood(testCase.good);
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
