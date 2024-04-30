import 'package:pantori/domains/auth/core/ports.dart';
import 'package:pantori/domains/auth/core/service.dart';
import 'package:pantori/domains/auth/mocks/backend.dart';
import 'package:pantori/domains/auth/mocks/local_storage.dart';

import 'test_inputs.dart';
import 'service_cases.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  BackendMock backend = BackendMock();
  LocalStorageMock storage = LocalStorageMock();
  ServicePort service = AuthService(backend, storage);

  group("login", () {
    final List<LoginCase> testCases = [
      LoginCase("successfull run", TestInputs.defaultUser, true, true)
    ];

    for (final testCase in testCases) {
      test(testCase.description, () async {
        await service.login(testCase.input);

        expect(backend.loginInvoked, testCase.loginFuncInvoked,reason: "backend");
        expect(storage.storeStringInvoked, testCase.storeStringInvoked, reason: "storage");
      });
    }
  });
}