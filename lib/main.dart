import 'package:pantori/domains/auth/auth.dart';
import 'package:pantori/domains/auth/core/service.dart';
import 'package:pantori/domains/categories/categories.dart';
import 'package:pantori/domains/categories/core/service.dart';
import 'package:pantori/domains/goods/core/service.dart';
import 'package:pantori/domains/goods/good.dart';

import 'package:pantori/views/pages/login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//import 'package:logger/logger.dart';

//var logger = Logger(
//  printer: PrettyPrinter(),
//);

void main() async {
  const bool isProduction = bool.fromEnvironment('dart.vm.product');

  AuthService auth = await newAuthService(isProduction);
  GoodService goods = await newGoodService(isProduction);
  CategoryService categories = await newCategoryService(isProduction);

  runApp(
    MyApp(
      goods: goods, 
      auth: auth,
      categories: categories,
    )
  );
}

class MyApp extends StatelessWidget {
  final GoodService goods;
  final AuthService auth;
  final CategoryService categories;

  const MyApp({
    super.key, 
    required this.goods, 
    required this.auth,
    required this.categories
  });

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
      color: Colors.white,
      home: LoginPage(
        goods: goods,
        auth: auth,
        categories: categories,
      ),
    );
  }
}
