import 'package:http/http.dart' as http;

abstract class IApiService {
  Future<http.Response> get(String endpoint, {Map<String, String>? headers});
  Future<http.Response> post(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? headers});
  Future<http.Response> put(String endpoint,
      {Map<String, dynamic>? body, Map<String, String>? headers});
  Future<http.Response> delete(String endpoint, {Map<String, String>? headers});
}
