// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'3a9f8412df34c1653d08100c9826aa2125b80f7f';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = Provider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = ProviderRef<SharedPreferences>;
String _$currencyNotifierHash() => r'6a636e06d8cf3f0c6236eaa8e14537497e5babd9';

/// See also [CurrencyNotifier].
@ProviderFor(CurrencyNotifier)
final currencyNotifierProvider =
    NotifierProvider<CurrencyNotifier, String>.internal(
      CurrencyNotifier.new,
      name: r'currencyNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currencyNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrencyNotifier = Notifier<String>;
String _$themeModeNotifierHash() => r'dc2fc3207b36ac0b1920cd847a19077e19be1b20';

/// See also [ThemeModeNotifier].
@ProviderFor(ThemeModeNotifier)
final themeModeNotifierProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>.internal(
      ThemeModeNotifier.new,
      name: r'themeModeNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$themeModeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeModeNotifier = Notifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
