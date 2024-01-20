import 'package:pantori/domain/good.dart';
import 'package:pantori/domain/ports.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pantori/infra/errors.dart';
import 'package:pantori/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Backend implements BackendPort {
  static const String loginUrl = 'http://localhost:8080/api/login';
  static const String goodsUrl = 'http://localhost:8080/api/goods';

  Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionToken = prefs.getString('sessionToken');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $sessionToken',
    };
  }

  @override
  Future<void> login(String user, String pwd) async {
    final Map<String, dynamic> data = {
      'username': user,
      'password': pwd,
    };

    final http.Response response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 400) {
      Map<String, dynamic> errorMsg = json.decode(response.body);
      throw UserLoginError(errorMsg['error'] ?? "");
    } else if (response.statusCode == 500) {
      Map<String, dynamic> errorMsg = json.decode(response.body);
      throw ServerLoginError(errorMsg['error'] ?? "");
    }

    final String sessionToken = json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionToken', sessionToken);

    return;
  }

  @override
  Future<List<Good>> listGoods() async {
    try {
      final http.Response response =
          await http.get(Uri.parse(goodsUrl), headers: await _getHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<Good> items =
            responseData.map((itemData) => Good.fromJson(itemData)).toList();
        return items;
      } else {
        Map<String, dynamic> errorMsg = json.decode(response.body);
        logger.e("api error", error: errorMsg['error']);
        throw ServerLoginError(errorMsg['error'] ?? "");
      }
    } catch (error) {
      logger.e("http request failed", error: error.toString());
    }

    return [];
  }

  @override
  Future<void> createGood(Good good) async {
    final Map<String, dynamic> data = {
      'name': good.name,
      'workspace': 'main',
      'category': good.category,
      'buy_date': good.buyDate,
      'expire': good.expirationDate,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(goodsUrl),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        Map<String, dynamic> errorMsg = json.decode(response.body);
        logger.e("api error", error: errorMsg['error']);
        throw ServerLoginError(errorMsg['error'] ?? "");
      }
    } catch (error) {
      logger.e("http request failed", error: error.toString());
    }
    return;
  }

  @override
  Future<void> deleteGood(Good good) async {
    final Map<String, dynamic> data = {
      'id': good.id,
    };

    try {
      final http.Response response = await http.delete(
        Uri.parse(goodsUrl),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        Map<String, dynamic> errorMsg = json.decode(response.body);
        logger.e("api error", error: errorMsg['error']);
        throw ServerLoginError(errorMsg['error'] ?? "");
      }
    } catch (error) {
      logger.e("http request failed", error: error.toString());
    }
    return;
  }
}
