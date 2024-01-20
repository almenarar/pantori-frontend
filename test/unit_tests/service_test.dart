import 'package:pantori/domain/good.dart';
import 'package:pantori/mocks/time.dart';

import 'input_lists.dart';
import 'service_cases.dart';

import 'package:pantori/domain/ports.dart';
import 'package:pantori/domain/service.dart';
import 'package:pantori/mocks/backend.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  TimePort time = TimeMock();
  BackendPort backend = BackendMock();
  ServicePort service = Service(backend, time);

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
      FilterCase("category custom, interval custom",
          TestInputs.defaultInputGoodList, "foo", "2 weeks", [
        const Good(
            id: "",
            name: "good3",
            category: "foo",
            buyDate: "00/00/0000",
            expirationDate: "2045-12-10T00:00:00Z",
            imagePath: ""),
      ]),
      FilterCase("category All, interval custom",
          TestInputs.defaultInputGoodList, "All", "2 weeks", [
        const Good(
            id: "",
            name: "good3",
            category: "foo",
            buyDate: "00/00/0000",
            expirationDate: "2045-12-10T00:00:00Z",
            imagePath: ""),
        const Good(
            id: "",
            name: "good4",
            category: "zap",
            buyDate: "00/00/0000",
            expirationDate: "2045-12-10T00:00:00Z",
            imagePath: ""),
      ]),
      FilterCase("category custom, interval All",
          TestInputs.defaultInputGoodList, "bar", "All", [
        const Good(
            id: "",
            name: "good2",
            category: "bar",
            buyDate: "00/00/0000",
            expirationDate: "2045-12-30T00:00:00Z",
            imagePath: "")
      ]),
      FilterCase("category All, interval All", TestInputs.defaultInputGoodList,
          "All", "All", TestInputs.defaultInputGoodList),
      FilterCase("category absent, interval All",
          TestInputs.defaultInputGoodList, "something else", "All", []),
      FilterCase("category All, interval absent",
          TestInputs.defaultInputGoodList, "All", "30 years", [])
    ];

    for (final testCase in testCases) {
      test(testCase.description, () {
        List<Good> filtered = service.filter(testCase.inputGoodList, testCase.inputCategory, testCase.inputInterval);

        expect(filtered, equals(testCase.outputGoodList));
      });
    }
  });
}
