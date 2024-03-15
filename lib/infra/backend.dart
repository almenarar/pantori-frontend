import 'package:pantori/domain/good.dart';
import 'package:pantori/domain/ports.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:pantori/infra/errors.dart';
import 'package:pantori/main.dart';

class Backend implements BackendPort {
  final LocalStoragePort localStorage;

  Backend(this.localStorage);

  String loginUrl = '';
  String goodsUrl = '';

  @override
  void init() {
    if (html.window.location.hostname == 'localhost') {
      loginUrl = 'http://localhost:8800/api/login';
      goodsUrl = 'http://localhost:8800/api/goods';
    } else {
      loginUrl =
          'https://pantori-api.ojuqreda8rlp4.us-east-1.cs.amazonlightsail.com/api/login';
      goodsUrl =
          'https://pantori-api.ojuqreda8rlp4.us-east-1.cs.amazonlightsail.com/api/goods';
    }
    return;
  }

  Future<Map<String, String>> _getHeaders() async {
    String sessionToken = await localStorage.getString('sessionToken');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $sessionToken',
    };
    return headers;
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
    await localStorage.storeString(sessionToken);

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

      if (response.statusCode == 400) {
        Map<String, dynamic> errorMsg = json.decode(response.body);
        logger.e("invalid payload", error: errorMsg['error']);
        throw UserLoginError(errorMsg['error'] ?? "");
      } else if (response.statusCode == 500) {
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

      if (response.statusCode == 400) {
        Map<String, dynamic> errorMsg = json.decode(response.body);
        logger.e("invalid payload", error: errorMsg['error']);
        throw UserLoginError(errorMsg['error'] ?? "");
      } else if (response.statusCode == 500) {
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
