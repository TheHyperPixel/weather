import 'dart:convert';

import 'package:app/core/data/constants/data_constants.dart';
import 'package:app/core/data/exceptions/api_client_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<Map<String, dynamic>> get(
      {String apiBaseUrl = DataConstants.baseApiUrl,
      required String apiEndpoint,
      required Map<String, dynamic> apiQueryParams}) async {
    try {
      Uri url = Uri.https(apiBaseUrl, apiEndpoint, apiQueryParams);

      var response = await http.get(url);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      throw const ApiClientException();
    } catch (e) {
      throw ApiClientException(originalException: e);
    }
  }
}
