import 'package:boilerplate_template/shared/storage/providers/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/features/api/interfaces/i_api_service.dart';
import 'package:boilerplate_template/features/api/services/api_service.dart';

part 'api_providers.g.dart';

// ==================== API PROVIDERS ====================

@riverpod
Future<IApiService> apiService(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return ApiService(prefs);
}
