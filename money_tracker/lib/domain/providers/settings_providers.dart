import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/currency_formatter.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError();
}

const kAvailableCurrencies = [
  ('IDR', 'Indonesian Rupiah', 'Rp'),
  ('USD', 'United States Dollar', '\$'),
  ('EUR', 'Euro', '€'),
  ('SGD', 'Singapore Dollar', 'S\$'),
  ('MYR', 'Malaysian Ringgit', 'RM'),
  ('GBP', 'British Pound Sterling', '£'),
  ('JPY', 'Japanese Yen', '¥'),
];

@Riverpod(keepAlive: true)
class CurrencyNotifier extends _$CurrencyNotifier {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final code = prefs.getString('selected_currency') ?? 'IDR';
    CurrencyFormatter.setCurrency(code);
    return code;
  }

  Future<void> setCurrency(String code) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString('selected_currency', code);
    CurrencyFormatter.setCurrency(code);
    state = code;
  }
}

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final saved = prefs.getString('theme_mode');
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString('theme_mode', mode.name);
    state = mode;
  }
}
