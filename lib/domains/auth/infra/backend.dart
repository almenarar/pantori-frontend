import 'package:pantori/domains/auth/core/auth.dart';
import 'package:pantori/domains/auth/core/ports.dart';
import 'package:pantori/domains/auth/infra/errors.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Backend implements BackendPort{
  Backend();

  String endpoint = '';

  @override
  void init(bool isProduction) {
    if (isProduction) {
      endpoint = 'http://pantori-api-1405768606.us-east-1.elb.amazonaws.com:8800/api/login';
    } else {
      endpoint = 'http://localhost:8800/api/login';
    }
    return;
  }

  @override
  Future<String> getCredentials(User user) async {
    final Map<String, dynamic> data = {
      'username': user.username,
      'password': user.password,
    };

    final http.Response response = await http.post(
      Uri.parse(endpoint),
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
    
    return json.decode(response.body);
  }
}