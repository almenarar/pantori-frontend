import 'package:pantori/domains/auth/core/ports.dart';

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

  @override
  Future<void> storeString(String key, value) async {
    await prefs.setString(key, value);
    return;
  }
}