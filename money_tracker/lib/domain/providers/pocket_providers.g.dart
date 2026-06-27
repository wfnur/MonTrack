// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pocket_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'fee633a23e9de804d9e8f2cbb3f2c3829bc4f1de';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = AutoDisposeProviderRef<AppDatabase>;
String _$pocketRepositoryHash() => r'eb9cc40eb0b9e143dbf1e8d6d4dc128349b2dcd1';

/// See also [pocketRepository].
@ProviderFor(pocketRepository)
final pocketRepositoryProvider = AutoDisposeProvider<PocketRepository>.internal(
  pocketRepository,
  name: r'pocketRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pocketRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PocketRepositoryRef = AutoDisposeProviderRef<PocketRepository>;
String _$pocketListHash() => r'56158b911463ad94ec2753deae95737b9b27d279';

/// See also [pocketList].
@ProviderFor(pocketList)
final pocketListProvider =
    AutoDisposeStreamProvider<List<PocketModel>>.internal(
      pocketList,
      name: r'pocketListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pocketListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PocketListRef = AutoDisposeStreamProviderRef<List<PocketModel>>;
String _$defaultPocketHash() => r'c9c404fa4293476598c0baf26fbcb172bc7e4baf';

/// See also [defaultPocket].
@ProviderFor(defaultPocket)
final defaultPocketProvider = AutoDisposeStreamProvider<PocketModel?>.internal(
  defaultPocket,
  name: r'defaultPocketProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$defaultPocketHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DefaultPocketRef = AutoDisposeStreamProviderRef<PocketModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
