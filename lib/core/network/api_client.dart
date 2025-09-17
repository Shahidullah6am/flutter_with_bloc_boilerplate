import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';
import '../../config/constants.dart';

class ApiClient {
  final http.Client client;

  ApiClient({http.Client? client}) : client = client ?? http.Client();

  Future<dynamic> get(String endpoint) async {
    final response = await client.get(Uri.parse("${AppConstants.baseUrl}$endpoint"));
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await client.post(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw ServerException("Error ${response.statusCode}: ${response.body}");
    }
  }
}
