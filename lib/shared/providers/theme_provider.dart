import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/storage_service.dart';

enum AppThemeMode { light, dark, system }

extension AppThemeModeExtension on AppThemeMode {
  String get value {
    switch (this) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }

  static AppThemeMode fromString(String value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
        return AppThemeMode.system;
      default:
        return AppThemeMode.system;
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = StorageService.getThemeMode();
    state = AppThemeModeExtension.fromString(savedTheme);
  }

  Future<void> setTheme(AppThemeMode theme) async {
    state = theme;
    await StorageService.setThemeMode(theme.value);
  }

  Future<void> toggleTheme() async {
    final newTheme = state == AppThemeMode.light 
        ? AppThemeMode.dark 
        : AppThemeMode.light;
    await setTheme(newTheme);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});