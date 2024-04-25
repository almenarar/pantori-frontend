import 'package:pantori/domains/categories/core/ports.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage implements LocalStoragePort {
  late SharedPreferences prefs;

  @override
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    return;
  }

  @override
  Future<String> getString(String key) async {
    String? value = prefs.getString(key);
    return value ??= '';
  }
}