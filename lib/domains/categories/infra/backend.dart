import 'package:pantori/domains/categories/core/category.dart';
import 'package:pantori/domains/categories/core/ports.dart';
import 'package:pantori/domains/categories/infra/errors.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class Backend implements BackendPort {
  final LocalStoragePort localStorage;

  Backend(this.localStorage);

  String endpoint = "";

  @override
  void init(bool isProduction) {
    if (isProduction) {
      endpoint = 'https://pantori-api.ojuqreda8rlp4.us-east-1.cs.amazonlightsail.com/api/categories';
    } else {
      endpoint = 'http://localhost:8800/api/categories';
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
  Future<List<Category>> listCategories() async {
    http.Response response;
    try {
     response = await http.get(Uri.parse(endpoint), headers: await _getHeaders());
    } catch (error) {
      throw RequestError("http request failed ${error.toString()}");
    }

    switch (response.statusCode) {
      case 200:
        final List<dynamic> responseData = json.decode(response.body);
        List<Category> items = responseData.map((itemData) => Category.fromJson(itemData)).toList();
        return items;
      case 500:
        Map<String, dynamic> errorMsg = json.decode(response.body);
        throw ServerError("api error ${errorMsg['error']}");
      default:
        return [];
    }
  }

  @override
  Future<void> createCategory(Category category) async {
    final Map<String, dynamic> data = {
      'Name': category.name,
      'Color': category.color,
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
  Future<void> editCategory(Category category) async {
    final Map<String, dynamic> data = {
      'ID': category.id,
      'Name': category.name,
      'Color': category.color,
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
  Future<void> deleteCategory(Category category) async {
    final Map<String, dynamic> data = {
      'ID': category.id,
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