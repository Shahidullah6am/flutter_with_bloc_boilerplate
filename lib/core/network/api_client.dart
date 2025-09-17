import 'dart:convert';
import 'package:flutter_bloc_boilerplate/config/constants.dart';
import 'package:flutter_bloc_boilerplate/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  ApiClient({http.Client? client}) : client = client ?? http.Client();

  void updateHeader(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  Future<dynamic> get(String endpoint) async {
    final response = await client.get(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: _headers,
    );
    return _processResponse(response);
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await client.post(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: _headers,
      body: body != null ? json.encode(body) : null,
    );
    return _processResponse(response);
  }

  Future<dynamic> postMultipart(String endpoint, {Map<String, String>? fields, List<http.MultipartFile>? files}) async {
    var request = http.MultipartRequest('POST', Uri.parse("${AppConstants.baseUrl}$endpoint"));
    request.headers.addAll(_headers);
    if (fields != null) {
      request.fields.addAll(fields);
    }
    if (files != null) {
      request.files.addAll(files);
    }
    final response = await client.send(request);
    return _processResponse(await http.Response.fromStream(response));
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    final response = await client.put(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: _headers,
      body: body != null ? json.encode(body) : null,
    );
    return _processResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await client.delete(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: _headers,
    );
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes));
      case 401:
        throw UnauthorizedException(utf8.decode(response.bodyBytes));
      case 403:
        throw ForbiddenException(utf8.decode(response.bodyBytes));
      case 404:
        throw NotFoundException(utf8.decode(response.bodyBytes));
      case 500:
      default:
        throw ServerException('Error occurred with status code: ${response.statusCode}');
    }
  }
}
