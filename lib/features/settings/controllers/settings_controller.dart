import 'package:boilerplate_template/storage/local_storage/interfaces/i_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boilerplate_template/common/constants/storage_keys.dart';

class SettingsController extends GetxController {
  final IStorageService _storageService;

  SettingsController(this._storageService);

  final Rx<Locale> currentLocale = const Locale('fr').obs;
  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;

  final List<Locale> supportedLocales = const [
    Locale('fr'),
    Locale('en'),
  ];

  Future<void> loadSettings() async {
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    String? localeCode = await _storageService.getString(StorageKeys.locale);
    if (localeCode != null) {
      final locale = supportedLocales.firstWhere(
        (loc) => loc.languageCode == localeCode,
        orElse: () => const Locale('en'),
      );
      currentLocale.value = locale;
      Get.updateLocale(locale);
    }

    String? themeString =
        await _storageService.getString(StorageKeys.themeMode);
    if (themeString != null) {
      if (themeString == 'dark') {
        themeMode.value = ThemeMode.dark;
      } else if (themeString == 'light') {
        themeMode.value = ThemeMode.light;
      } else {
        themeMode.value = ThemeMode.system;
      }
      Get.changeThemeMode(themeMode.value);
    }
  }

  void switchLocale(String languageCode) async {
    final locale = supportedLocales.firstWhere(
      (loc) => loc.languageCode == languageCode,
      orElse: () => const Locale('en'),
    );
    currentLocale.value = locale;
    Get.updateLocale(locale);
    await _storageService.setString(StorageKeys.locale, languageCode);
  }

  void toggleTheme() async {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      await _storageService.setString(StorageKeys.themeMode, 'dark');
    } else {
      themeMode.value = ThemeMode.light;
      await _storageService.setString(StorageKeys.themeMode, 'light');
    }
    Get.changeThemeMode(themeMode.value);
  }
}
