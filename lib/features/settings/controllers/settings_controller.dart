import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/shared/storage/local_storage/interfaces/i_storage_service.dart';
import 'package:boilerplate_template/shared/constants/storage_keys.dart';
import 'package:boilerplate_template/features/settings/states/settings_state.dart';
import 'package:boilerplate_template/shared/storage/providers/storage_providers.dart';

part 'settings_controller.g.dart';

// Controller moderne avec Riverpod 3.0 AsyncNotifier
@riverpod
class SettingsController extends _$SettingsController {
  late final IStorageService _storageService;

  @override
  FutureOr<SettingsState> build() async {
    AppLogger.info('Initializing SettingsController with AsyncNotifier');

    _storageService = await ref.read(storageServiceProvider.future);

    // Charger les paramètres au démarrage
    final settings = await _loadSettings();

    // Une fois les settings chargés, on peut retirer le splash screen
    _removeSplashScreen();

    return settings;
  }

  Future<SettingsState> _loadSettings() async {
    AppLogger.info('Loading settings from storage');

    try {
      String? localeCode = await _storageService.getString(StorageKeys.locale);
      String? themeString =
          await _storageService.getString(StorageKeys.themeMode);

      Locale currentLocale = const Locale('fr'); // défaut
      if (localeCode != null) {
        currentLocale = SettingsState.supportedLocales.firstWhere(
          (loc) => loc.languageCode == localeCode,
          orElse: () => const Locale('fr'),
        );
      }

      ThemeMode themeMode = ThemeMode.dark; // défaut
      if (themeString != null) {
        switch (themeString) {
          case 'dark':
            themeMode = ThemeMode.dark;
            break;
          case 'light':
            themeMode = ThemeMode.light;
            break;
          default:
            themeMode = ThemeMode.system;
        }
      }

      final settings = SettingsState(
        currentLocale: currentLocale,
        themeMode: themeMode,
        isLoading: false,
      );

      AppLogger.info(
          'Settings loaded: locale=${currentLocale.languageCode}, theme=$themeString');
      return settings;
    } catch (e) {
      AppLogger.error('Failed to load settings', e);
      return SettingsState.defaultState();
    }
  }

  /// Retire le splash screen avec un petit délai pour une transition smooth
  void _removeSplashScreen() {
    Future.delayed(const Duration(milliseconds: 500), () {
      FlutterNativeSplash.remove();
      AppLogger.info('✅ Native splash screen removed');
    });
  }

  Future<void> switchLocale(String languageCode) async {
    AppLogger.info('Switching locale to: $languageCode');

    final currentState = await future;

    final locale = SettingsState.supportedLocales.firstWhere(
      (loc) => loc.languageCode == languageCode,
      orElse: () => const Locale('en'),
    );

    final newState = currentState.copyWith(currentLocale: locale);
    state = AsyncData(newState);

    try {
      await _storageService.setString(StorageKeys.locale, languageCode);
      AppLogger.info('Locale saved to storage: $languageCode');
    } catch (e) {
      AppLogger.error('Failed to save locale', e);
    }
  }

  Future<void> toggleTheme() async {
    AppLogger.info('Toggling theme');

    final currentState = await future;
    final newThemeMode = currentState.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    await setThemeMode(newThemeMode);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    AppLogger.info('Setting theme mode: $themeMode');

    final currentState = await future;
    final newState = currentState.copyWith(themeMode: themeMode);
    state = AsyncData(newState);

    String themeString;
    switch (themeMode) {
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.system:
        themeString = 'system';
        break;
    }

    try {
      await _storageService.setString(StorageKeys.themeMode, themeString);
      AppLogger.info('Theme mode saved to storage: $themeString');
    } catch (e) {
      AppLogger.error('Failed to save theme mode', e);
    }
  }
}

// Helper providers modernes
@riverpod
Locale currentLocale(Ref ref) {
  final settings = ref.watch(settingsControllerProvider);
  return settings.maybeWhen(
    data: (state) => state.currentLocale,
    orElse: () => const Locale('fr'),
  );
}

@riverpod
ThemeMode currentThemeMode(Ref ref) {
  final settings = ref.watch(settingsControllerProvider);
  return settings.maybeWhen(
    data: (state) => state.themeMode,
    orElse: () => ThemeMode.dark,
  );
}
