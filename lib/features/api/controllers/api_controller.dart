import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/shared/error_handling/services/error_handling_service.dart';
import 'package:boilerplate_template/features/api/interfaces/i_api_service.dart';
import 'package:boilerplate_template/features/api/providers/api_providers.dart';
import 'package:boilerplate_template/shared/error_handling/providers/error_providers.dart';
import 'package:boilerplate_template/shared/exceptions/api_exceptions.dart';
import 'package:boilerplate_template/shared/services/app_logger.dart';

part 'api_controller.g.dart';

// API state simplifié avec enum
enum ApiStatus {
  initial,
  loading,
  success,
}

// Controller moderne avec Riverpod 3.0 - État simple
@riverpod
class ApiController extends _$ApiController {
  late final IApiService _apiService;
  late final ErrorHandlingService _errorHandlingService;
  http.Response? _lastResponse;

  @override
  ApiStatus build() {
    AppLogger.info('Initializing ApiController');

    // Les appels async sont déplacés vers les méthodes
    return ApiStatus.initial;
  }

  Future<void> _initializeServices() async {
    _apiService = await ref.read(apiServiceProvider.future);
    _errorHandlingService = ref.read(errorHandlingServiceProvider);
  }

  // Méthodes simplifiées avec try/catch
  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    await _initializeServices();
    if (!_canPerformOperation()) {
      throw const ApiException('Controller disposed');
    }

    state = ApiStatus.loading;

    try {
      final response = await _apiService.get(url, headers: headers);

      if (_canPerformOperation()) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _lastResponse = response;
          state = ApiStatus.success;
          return response;
        } else {
          throw _errorHandlingService.mapHttpStatusCode(
              response.statusCode, 'HTTP ${response.statusCode}');
        }
      }
      throw const ApiException('Operation cancelled');
    } catch (e) {
      if (_canPerformOperation()) {
        state = ApiStatus.initial;
        AppLogger.error('GET request failed', e);
        if (e is ApiException) {
          rethrow;
        } else {
          throw ApiException('GET request failed: $e');
        }
      }
      throw const ApiException('Operation cancelled');
    }
  }

  Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    await _initializeServices();
    if (!_canPerformOperation()) {
      throw const ApiException('Controller disposed');
    }

    state = ApiStatus.loading;

    try {
      final response =
          await _apiService.post(url, body: body, headers: headers);

      if (_canPerformOperation()) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _lastResponse = response;
          state = ApiStatus.success;
          return response;
        } else {
          throw _errorHandlingService.mapHttpStatusCode(
              response.statusCode, 'HTTP ${response.statusCode}');
        }
      }
      throw const ApiException('Operation cancelled');
    } catch (e) {
      if (_canPerformOperation()) {
        state = ApiStatus.initial;
        AppLogger.error('POST request failed', e);
        if (e is ApiException) {
          rethrow;
        } else {
          throw ApiException('POST request failed: $e');
        }
      }
      throw const ApiException('Operation cancelled');
    }
  }

  Future<http.Response> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    await _initializeServices();
    if (!_canPerformOperation()) {
      throw const ApiException('Controller disposed');
    }

    state = ApiStatus.loading;

    try {
      final response = await _apiService.put(url, body: body, headers: headers);

      if (_canPerformOperation()) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _lastResponse = response;
          state = ApiStatus.success;
          return response;
        } else {
          throw _errorHandlingService.mapHttpStatusCode(
              response.statusCode, 'HTTP ${response.statusCode}');
        }
      }
      throw const ApiException('Operation cancelled');
    } catch (e) {
      if (_canPerformOperation()) {
        state = ApiStatus.initial;
        AppLogger.error('PUT request failed', e);
        if (e is ApiException) {
          rethrow;
        } else {
          throw ApiException('PUT request failed: $e');
        }
      }
      throw const ApiException('Operation cancelled');
    }
  }

  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    await _initializeServices();
    if (!_canPerformOperation()) {
      throw const ApiException('Controller disposed');
    }

    state = ApiStatus.loading;

    try {
      final response = await _apiService.delete(url, headers: headers);

      if (_canPerformOperation()) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _lastResponse = response;
          state = ApiStatus.success;
          return response;
        } else {
          throw _errorHandlingService.mapHttpStatusCode(
              response.statusCode, 'HTTP ${response.statusCode}');
        }
      }
      throw const ApiException('Operation cancelled');
    } catch (e) {
      if (_canPerformOperation()) {
        state = ApiStatus.initial;
        AppLogger.error('DELETE request failed', e);
        if (e is ApiException) {
          rethrow;
        } else {
          throw ApiException('DELETE request failed: $e');
        }
      }
      throw const ApiException('Operation cancelled');
    }
  }

  void resetState() {
    state = ApiStatus.initial;
    _lastResponse = null;
  }

  // Guard pour vérifier si on peut encore effectuer des opérations
  bool _canPerformOperation() {
    return ref.exists(apiControllerProvider);
  }
}

// Helper providers simplifiés
@riverpod
bool isApiLoading(Ref ref) {
  return ref.watch(apiControllerProvider) == ApiStatus.loading;
}

@riverpod
http.Response? lastApiResponse(Ref ref) {
  final controller = ref.watch(apiControllerProvider.notifier);
  return controller._lastResponse;
}
