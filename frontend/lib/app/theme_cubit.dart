import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _themeKey = 'app_theme_mode';
  final _storage = const FlutterSecureStorage();

  ThemeCubit() : super(ThemeMode.dark) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final savedTheme = await _storage.read(key: _themeKey);
      if (savedTheme != null) {
        if (savedTheme == 'light') {
          emit(ThemeMode.light);
        } else if (savedTheme == 'dark') {
          emit(ThemeMode.dark);
        }
      }
    } catch (_) {
      // Fallback silently
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newMode);
    try {
      await _storage.write(
        key: _themeKey,
        value: newMode == ThemeMode.light ? 'light' : 'dark',
      );
    } catch (_) {
      // Fail silently
    }
  }
}
