import 'package:pantori/domains/goods/core/good.dart';
import 'package:pantori/domains/goods/core/ports.dart';
import 'package:pantori/domains/goods/infra/errors.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class Backend implements BackendPort {
  final LocalStoragePort localStorage;

  Backend(this.localStorage);

  String endpoint = '';

  @override
  void init(bool isProduction) {
    if (isProduction) {
      endpoint = 'https://pantori-api.ojuqreda8rlp4.us-east-1.cs.amazonlightsail.com/api/goods';
    } else {
      endpoint = 'http://localhost:8800/api/goods';
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
  Future<List<Good>> listGoods() async {
    http.Response response;
    try {
     response = await http.get(Uri.parse(endpoint), headers: await _getHeaders());
    } catch (error) {
      throw RequestError("http request failed ${error.toString()}");
    }

    switch (response.statusCode) {
      case 200:
        final List<dynamic> responseData = json.decode(response.body);
        List<Good> items = responseData.map((itemData) => Good.fromJson(itemData)).toList();
        return items;
      case 500:
        Map<String, dynamic> errorMsg = json.decode(response.body);
        throw ServerError("api error ${errorMsg['error']}");
      default:
        return [];
    }
  }

  @override
  Future<void> createGood(Good good) async {
    final Map<String, dynamic> data = {
      'Name': good.name,
      'Categories': good.categories,
      'BuyDate': good.buyDate,
      'Expire': good.expirationDate,
    };

    http.Response response;
    try {
      response = await http.post(
        Uri.parse(endpoint),
        headers: await _getHeaders(),
        body: json.encode(data),
      );
    } catch (error) {
      throw RequestError("http request failed ${error.toString()}");
    }

    switch (response.statusCode) {
      case 200:
        return;
      case 400:
        Map<String, dynamic> errorMsg = json.decode(response.body);
        throw ServerError("invalid input ${errorMsg['error']}");
      case 500:
        Map<String, dynamic> errorMsg = json.decode(response.body);
        throw ServerError("api error ${errorMsg['error']}");
      default:
        return;
    }
  }

  @override
  Future<void> editGood(Good good) async {
    final Map<String, dynamic> data = {
      'ID': good.id,
      'Name': good.name,
      'Categories': good.categories,
      'BuyDate': good.buyDate,
      'Expire': good.expirationDate,
      'ImageURL': good.imagePath,
      'CreatedAt': good.createdAt
    };

    http.Response response;
    try {
      response = await http.patch(
        Uri.parse(endpoint),
        headers: await _getHeaders(),
        body: json.encode(data),
      );
    } catch (error) {
      throw RequestError("http request failed ${error.toString()}");
    }

    switch (response.statusCode) {
      case 200:
        return;
      case 400:
        Map<String, dynamic> errorMsg = json.decode(response.body);
        throw ServerError("invalid input ${errorMsg['error']}");
      case 500:
        Map<String, dynamic> errorMsg = json.decode(response.body);
        throw ServerError("api error ${errorMsg['error']}");
      default:
        return;
    }
  }

  @override
  Future<void> deleteGood(Good good) async {
    final Map<String, dynamic> data = {
      'ID': good.id,
    };

    http.Response response;
    try {
     response = await http.delete(
        Uri.parse(endpoint),
        headers: await _getHeaders(),
        body: json.encode(data),
      );
    } catch (error) {
      throw RequestError("http request failed ${error.toString()}");
    }

    switch (response.statusCode) {
      case 200:
        return;
      case 400:
        Map<String, dynamic> errorMsg = json.decode(response.body);
        throw ServerError("invalid input ${errorMsg['error']}");
      case 500:
        Map<String, dynamic> errorMsg = json.decode(response.body);
        throw ServerError("api error ${errorMsg['error']}");
      default:
        return;
    }
  }
}
