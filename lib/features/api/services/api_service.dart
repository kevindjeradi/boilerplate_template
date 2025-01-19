import 'dart:convert';
import 'package:boilerplate_template/features/api/interfaces/i_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService implements IApiService {
  final SharedPreferences _prefs;

  ApiService(this._prefs);

  static const int cacheExpiration = 60 * 60;
  static const Duration requestTimeout = Duration(seconds: 10);

  String _generateCacheKey(String method, String url,
      {Map<String, dynamic>? body}) {
    if (body != null) {
      return '$method-$url-${jsonEncode(body)}';
    }
    return '$method-$url';
  }

  @override
  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    final cacheKey = _generateCacheKey('GET', url);

    final cachedResponse = await _getCachedResponse(cacheKey);
    if (cachedResponse != null) {
      return cachedResponse;
    }

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(requestTimeout);

      await _cacheResponse(cacheKey, response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<http.Response> post(String url,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final cacheKey = _generateCacheKey('POST', url, body: body);

    try {
      final combinedHeaders = {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      };
      final response = await http
          .post(
            Uri.parse(url),
            headers: combinedHeaders,
            body: jsonEncode(body),
          )
          .timeout(requestTimeout);

      await _cacheResponse(cacheKey, response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<http.Response> put(String url,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final cacheKey = _generateCacheKey('PUT', url, body: body);

    try {
      final combinedHeaders = {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      };
      final response = await http
          .put(
            Uri.parse(url),
            headers: combinedHeaders,
            body: jsonEncode(body),
          )
          .timeout(requestTimeout);
      await _cacheResponse(cacheKey, response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    try {
      final combinedHeaders = {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      };
      final response = await http
          .delete(Uri.parse(url), headers: combinedHeaders)
          .timeout(requestTimeout);
      await _removeCachedResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheResponse(String url, http.Response response) async {
    if (_isCacheable(response.statusCode)) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final cacheData = jsonEncode({
        'timestamp': timestamp,
        'body': response.body,
      });
      await _prefs.setString(url, cacheData);
    }
  }

  Future<http.Response?> _getCachedResponse(String url) async {
    final cachedData = _prefs.getString(url);
    if (cachedData != null) {
      final Map<String, dynamic> cacheMap = jsonDecode(cachedData);
      final int timestamp = cacheMap['timestamp'];
      final String body = cacheMap['body'];

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final currentTime = DateTime.now();

      if (currentTime.difference(cacheTime).inSeconds < cacheExpiration) {
        return http.Response(body, 200);
      } else {
        await _removeCachedResponse(url);
      }
    }
    return null;
  }

  bool _isCacheable(int statusCode) {
    return statusCode == 200 || statusCode == 201;
  }

  Future<void> _removeCachedResponse(String url) async {
    await _prefs.remove(url);
  }
}
