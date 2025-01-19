import 'package:get/get.dart';
import 'package:boilerplate_template/features/api/interfaces/i_api_service.dart';
import 'dart:convert';
import 'package:boilerplate_template/common/error_handling/services/error_handling_service.dart';
import 'package:http/http.dart' as http;

class ApiController extends GetxController {
  final IApiService _apiService;
  final ErrorHandlingService _errorHandlingService;

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxMap<String, dynamic> responseData = <String, dynamic>{}.obs;

  ApiController(this._apiService, this._errorHandlingService);

  Future<void> fetchData(String url) async {
    await _makeRequest(
      method: _apiService.get,
      url: url,
      onSuccess: (data) {
        responseData.value = data;
      },
    );
  }

  Future<void> sendData(String url, {Map<String, dynamic>? body}) async {
    await _makeRequest(
      method: (url) => _apiService.post(url, body: body),
      url: url,
      onSuccess: (data) {
        responseData.value = data;
      },
    );
  }

  Future<void> updateData(String url, {Map<String, dynamic>? body}) async {
    await _makeRequest(
      method: (url) => _apiService.put(url, body: body),
      url: url,
      onSuccess: (data) {
        responseData.value = data;
      },
    );
  }

  Future<void> deleteData(String url) async {
    await _makeRequest(
      method: _apiService.delete,
      url: url,
      onSuccess: (_) {
        responseData.value = {'message': 'Deleted successfully'};
      },
    );
  }

  void clearResponse() {
    responseData.value = {};
  }

  Future<void> _makeRequest({
    required Future<http.Response> Function(String url) method,
    required String url,
    required void Function(Map<String, dynamic> data) onSuccess,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await method(url);
      if (_isSuccess(response.statusCode)) {
        final data = _parseJson(response.body);
        onSuccess(data);
      } else {
        errorMessage.value = _errorHandlingService
            .getErrorMessageFromStatusCode(response.statusCode);
      }
    } catch (e) {
      errorMessage.value =
          _errorHandlingService.getErrorMessage(e as Exception);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading.value = value;
  }

  void _clearError() {
    errorMessage.value = '';
  }

  bool _isSuccess(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  Map<String, dynamic> _parseJson(String responseBody) {
    try {
      return jsonDecode(responseBody);
    } catch (_) {
      return {};
    }
  }
}
