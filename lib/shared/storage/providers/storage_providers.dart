import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/shared/storage/local_storage/interfaces/i_storage_service.dart';
import 'package:boilerplate_template/shared/storage/local_storage/services/storage_service.dart';

part 'storage_providers.g.dart';

// ==================== STORAGE PROVIDERS ====================

@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  AppLogger.info('Initializing SharedPreferences');
  return SharedPreferences.getInstance();
}

@riverpod
Future<IStorageService> storageService(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return StorageService(prefs);
}
