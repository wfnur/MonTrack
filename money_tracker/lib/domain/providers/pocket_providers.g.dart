// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pocket_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'c106396ca9ffc6af1d50cbfae4044b36ea4445e6';

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
String _$pocketByIdHash() => r'dc9c3bf48937e21a93a0ac20c51bf6397f6d13d4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [pocketById].
@ProviderFor(pocketById)
const pocketByIdProvider = PocketByIdFamily();

/// See also [pocketById].
class PocketByIdFamily extends Family<AsyncValue<PocketModel>> {
  /// See also [pocketById].
  const PocketByIdFamily();

  /// See also [pocketById].
  PocketByIdProvider call(String id) {
    return PocketByIdProvider(id);
  }

  @override
  PocketByIdProvider getProviderOverride(
    covariant PocketByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pocketByIdProvider';
}

/// See also [pocketById].
class PocketByIdProvider extends AutoDisposeStreamProvider<PocketModel> {
  /// See also [pocketById].
  PocketByIdProvider(String id)
    : this._internal(
        (ref) => pocketById(ref as PocketByIdRef, id),
        from: pocketByIdProvider,
        name: r'pocketByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$pocketByIdHash,
        dependencies: PocketByIdFamily._dependencies,
        allTransitiveDependencies: PocketByIdFamily._allTransitiveDependencies,
        id: id,
      );

  PocketByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<PocketModel> Function(PocketByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PocketByIdProvider._internal(
        (ref) => create(ref as PocketByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<PocketModel> createElement() {
    return _PocketByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PocketByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PocketByIdRef on AutoDisposeStreamProviderRef<PocketModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PocketByIdProviderElement
    extends AutoDisposeStreamProviderElement<PocketModel>
    with PocketByIdRef {
  _PocketByIdProviderElement(super.provider);

  @override
  String get id => (origin as PocketByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
