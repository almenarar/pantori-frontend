import 'package:pantori/domain/ports.dart';
import 'package:pantori/domain/service.dart';

import 'package:pantori/infra/backend.dart';
import 'package:pantori/infra/local_storage.dart';
import 'package:pantori/infra/time.dart';

import 'package:pantori/views/pages/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

void main() async {
  const bool isProduction = bool.fromEnvironment('dart.vm.product');

  LocalStoragePort storage = LocalStorage();
  await storage.init();

  BackendPort backend = Backend(storage);
  backend.init(isProduction);

  TimePort time = Time();
  ServicePort service = Service(backend, time);

  runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
  final ServicePort service;

  const MyApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantori',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('pt', 'BR'),
      ],
      locale: View.of(context).platformDispatcher.locale,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Nunito"),
      home: LoginPage(service: service),
    );
  }
}
