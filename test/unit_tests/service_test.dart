import 'package:pantori/domains/goods/core/good.dart';
import 'package:pantori/domains/goods/mocks/time.dart';

import 'input_lists.dart';
import 'service_cases.dart';

import 'package:pantori/domains/goods/core/ports.dart';
import 'package:pantori/domains/goods/core/service.dart';
import 'package:pantori/domains/goods/mocks/backend.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  TimePort time = TimeMock();
  BackendPort backend = BackendMock();
  ServicePort service = GoodService(backend, time);

  group("list filter intervals", () {
    final List<ListFilterIntervalsCase> testCases = [
      ListFilterIntervalsCase("successfull case")
    ];

    for (final testCase in testCases) {
      test(testCase.description, () {
        List<String> intervals = service.listFilterIntervals();

        expect(intervals.length, isPositive);
        expect(int.parse(intervals[0].split(" ")[0]), isPositive);
        expect(
            ["weeks", "days", "months"], contains(intervals[0].split(" ")[1]));
      });
    }
  });

  group("filter", () {
    final List<FilterCase> testCases = [
      FilterCase(
          "category custom, interval custom",
          TestInputs.defaultInputGoodList,
          "foo",
          "2 weeks",
          [
            TestInputs.defaultInputGoodList[2]
          ]
      ),
      FilterCase(
        "category All, interval custom",
        TestInputs.defaultInputGoodList, 
        "All", 
        "2 weeks",
        [
          TestInputs.defaultInputGoodList[2],
          TestInputs.defaultInputGoodList[3]
        ]
      ),
      FilterCase(
        "category custom, interval All",
        TestInputs.defaultInputGoodList,
        "bar",
        "All",
        [
          TestInputs.defaultInputGoodList[0],
          TestInputs.defaultInputGoodList[1]
        ]
      ),
      FilterCase("category All, interval All", TestInputs.defaultInputGoodList,
          "All", "All", TestInputs.defaultInputGoodList),
      FilterCase("category absent, interval All",
          TestInputs.defaultInputGoodList, "something else", "All", []),
      FilterCase("category All, interval absent",
          TestInputs.defaultInputGoodList, "All", "30 years", [])
    ];

    for (final testCase in testCases) {
      test(testCase.description, () {
        List<Good> filtered = service.filter(testCase.inputGoodList,
            testCase.inputCategory, testCase.inputInterval);

        expect(filtered, equals(testCase.outputGoodList));
      });
    }
  });

  group("create good", () {
    TimePort time = TimeMock();
    BackendMock backend = BackendMock();
    ServicePort service = GoodService(backend, time);

    final List<CreateGoodCase> testCases = [
      CreateGoodCase("successfull run", TestInputs.defaultGood, true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () {
        service.createGood(testCase.input);

        expect(backend.createGoodInvoked, equals(testCase.createFuncInvoked));
      });
    }
  });

  group("delete good", () {
    TimePort time = TimeMock();
    BackendMock backend = BackendMock();
    ServicePort service = GoodService(backend, time);

    final List<DeleteGoodCase> testCases = [
      DeleteGoodCase("successfull run", TestInputs.defaultGood, true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () {
        service.deleteGood(testCase.input);

        expect(backend.deleteGoodInvoked, equals(testCase.deleteFuncInvoked));
      });
    }
  });

  //group("login", () {
  //  TimePort time = TimeMock();
  //  BackendMock backend = BackendMock();
  //  ServicePort service = Service(backend, time);
  //
  //  final List<LoginCase> testCases = [
  //    LoginCase("successfull run", "john.doe", "foobar", true)
  //  ];
  //
  //  for (final testCase in testCases) {
  //    test(testCase.description, () {
  //      service.login(testCase.inputUser, testCase.inputPwd);
  //
  //      expect(backend.loginInvoked, equals(testCase.loginFuncInvoked));
  //    });
  //  }
  //});

  group("list goods", () {
    TimePort time = TimeMock();
    BackendMock backend = BackendMock();
    ServicePort service = GoodService(backend, time);

    final List<ListGoodsCase> testCases = [
      ListGoodsCase(
          "successfull run",
          false,
          [
            const Good(
                id: "foo",
                name: "carrot",
                categories: ["foo", "bar"],
                buyDate: "30/11/2000",
                expirationDate: "30/02/2001",
                imagePath: "empty",
                createdAt: "08/2020"
              )
          ],
          true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        List<Good> output = await service.listGoods();
        expect(backend.listGoodsInvoked, equals(testCase.listGoodsFuncInvoked));
        expect(output, testCase.output);
      });
    }
  });
}
