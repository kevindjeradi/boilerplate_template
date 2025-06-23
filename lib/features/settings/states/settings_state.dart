import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required Locale currentLocale,
    required ThemeMode themeMode,
    @Default(false) bool isLoading,
  }) = _SettingsState;

  // Factory constructor avec valeurs par défaut
  factory SettingsState.defaultState() => const SettingsState(
        currentLocale: Locale('fr'),
        themeMode: ThemeMode.dark,
        isLoading: false,
      );

  static const List<Locale> supportedLocales = [
    Locale('fr'),
    Locale('en'),
  ];
}
