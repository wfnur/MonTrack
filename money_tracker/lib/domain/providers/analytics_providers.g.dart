// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryTotalsHash() => r'1a20d09720a08e5ba8767d423ebe0eb24a9b5a0c';

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

/// See also [categoryTotals].
@ProviderFor(categoryTotals)
const categoryTotalsProvider = CategoryTotalsFamily();

/// See also [categoryTotals].
class CategoryTotalsFamily extends Family<AsyncValue<List<CategoryTotal>>> {
  /// See also [categoryTotals].
  const CategoryTotalsFamily();

  /// See also [categoryTotals].
  CategoryTotalsProvider call(
    TransactionType type,
    DateTimeRange<DateTime> range,
  ) {
    return CategoryTotalsProvider(type, range);
  }

  @override
  CategoryTotalsProvider getProviderOverride(
    covariant CategoryTotalsProvider provider,
  ) {
    return call(provider.type, provider.range);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryTotalsProvider';
}

/// See also [categoryTotals].
class CategoryTotalsProvider
    extends AutoDisposeFutureProvider<List<CategoryTotal>> {
  /// See also [categoryTotals].
  CategoryTotalsProvider(TransactionType type, DateTimeRange<DateTime> range)
    : this._internal(
        (ref) => categoryTotals(ref as CategoryTotalsRef, type, range),
        from: categoryTotalsProvider,
        name: r'categoryTotalsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoryTotalsHash,
        dependencies: CategoryTotalsFamily._dependencies,
        allTransitiveDependencies:
            CategoryTotalsFamily._allTransitiveDependencies,
        type: type,
        range: range,
      );

  CategoryTotalsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.range,
  }) : super.internal();

  final TransactionType type;
  final DateTimeRange<DateTime> range;

  @override
  Override overrideWith(
    FutureOr<List<CategoryTotal>> Function(CategoryTotalsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryTotalsProvider._internal(
        (ref) => create(ref as CategoryTotalsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        range: range,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CategoryTotal>> createElement() {
    return _CategoryTotalsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryTotalsProvider &&
        other.type == type &&
        other.range == range;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryTotalsRef on AutoDisposeFutureProviderRef<List<CategoryTotal>> {
  /// The parameter `type` of this provider.
  TransactionType get type;

  /// The parameter `range` of this provider.
  DateTimeRange<DateTime> get range;
}

class _CategoryTotalsProviderElement
    extends AutoDisposeFutureProviderElement<List<CategoryTotal>>
    with CategoryTotalsRef {
  _CategoryTotalsProviderElement(super.provider);

  @override
  TransactionType get type => (origin as CategoryTotalsProvider).type;
  @override
  DateTimeRange<DateTime> get range => (origin as CategoryTotalsProvider).range;
}

String _$monthlyTotalsHash() => r'4031b467d7107d3d253bf4f938701424b741379d';

/// See also [monthlyTotals].
@ProviderFor(monthlyTotals)
const monthlyTotalsProvider = MonthlyTotalsFamily();

/// See also [monthlyTotals].
class MonthlyTotalsFamily extends Family<AsyncValue<List<MonthlyTotal>>> {
  /// See also [monthlyTotals].
  const MonthlyTotalsFamily();

  /// See also [monthlyTotals].
  MonthlyTotalsProvider call(int year, String? pocketId) {
    return MonthlyTotalsProvider(year, pocketId);
  }

  @override
  MonthlyTotalsProvider getProviderOverride(
    covariant MonthlyTotalsProvider provider,
  ) {
    return call(provider.year, provider.pocketId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyTotalsProvider';
}

/// See also [monthlyTotals].
class MonthlyTotalsProvider
    extends AutoDisposeFutureProvider<List<MonthlyTotal>> {
  /// See also [monthlyTotals].
  MonthlyTotalsProvider(int year, String? pocketId)
    : this._internal(
        (ref) => monthlyTotals(ref as MonthlyTotalsRef, year, pocketId),
        from: monthlyTotalsProvider,
        name: r'monthlyTotalsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$monthlyTotalsHash,
        dependencies: MonthlyTotalsFamily._dependencies,
        allTransitiveDependencies:
            MonthlyTotalsFamily._allTransitiveDependencies,
        year: year,
        pocketId: pocketId,
      );

  MonthlyTotalsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.pocketId,
  }) : super.internal();

  final int year;
  final String? pocketId;

  @override
  Override overrideWith(
    FutureOr<List<MonthlyTotal>> Function(MonthlyTotalsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyTotalsProvider._internal(
        (ref) => create(ref as MonthlyTotalsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        pocketId: pocketId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MonthlyTotal>> createElement() {
    return _MonthlyTotalsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyTotalsProvider &&
        other.year == year &&
        other.pocketId == pocketId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, pocketId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyTotalsRef on AutoDisposeFutureProviderRef<List<MonthlyTotal>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `pocketId` of this provider.
  String? get pocketId;
}

class _MonthlyTotalsProviderElement
    extends AutoDisposeFutureProviderElement<List<MonthlyTotal>>
    with MonthlyTotalsRef {
  _MonthlyTotalsProviderElement(super.provider);

  @override
  int get year => (origin as MonthlyTotalsProvider).year;
  @override
  String? get pocketId => (origin as MonthlyTotalsProvider).pocketId;
}

String _$dailyTotalsHash() => r'6d34b91655fbff408777dd0a5cfe20d697314fcb';

/// See also [dailyTotals].
@ProviderFor(dailyTotals)
const dailyTotalsProvider = DailyTotalsFamily();

/// See also [dailyTotals].
class DailyTotalsFamily extends Family<AsyncValue<List<DailyTotal>>> {
  /// See also [dailyTotals].
  const DailyTotalsFamily();

  /// See also [dailyTotals].
  DailyTotalsProvider call(DateTimeRange<DateTime> range, String? pocketId) {
    return DailyTotalsProvider(range, pocketId);
  }

  @override
  DailyTotalsProvider getProviderOverride(
    covariant DailyTotalsProvider provider,
  ) {
    return call(provider.range, provider.pocketId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dailyTotalsProvider';
}

/// See also [dailyTotals].
class DailyTotalsProvider extends AutoDisposeFutureProvider<List<DailyTotal>> {
  /// See also [dailyTotals].
  DailyTotalsProvider(DateTimeRange<DateTime> range, String? pocketId)
    : this._internal(
        (ref) => dailyTotals(ref as DailyTotalsRef, range, pocketId),
        from: dailyTotalsProvider,
        name: r'dailyTotalsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dailyTotalsHash,
        dependencies: DailyTotalsFamily._dependencies,
        allTransitiveDependencies: DailyTotalsFamily._allTransitiveDependencies,
        range: range,
        pocketId: pocketId,
      );

  DailyTotalsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.range,
    required this.pocketId,
  }) : super.internal();

  final DateTimeRange<DateTime> range;
  final String? pocketId;

  @override
  Override overrideWith(
    FutureOr<List<DailyTotal>> Function(DailyTotalsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyTotalsProvider._internal(
        (ref) => create(ref as DailyTotalsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        range: range,
        pocketId: pocketId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DailyTotal>> createElement() {
    return _DailyTotalsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyTotalsProvider &&
        other.range == range &&
        other.pocketId == pocketId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);
    hash = _SystemHash.combine(hash, pocketId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyTotalsRef on AutoDisposeFutureProviderRef<List<DailyTotal>> {
  /// The parameter `range` of this provider.
  DateTimeRange<DateTime> get range;

  /// The parameter `pocketId` of this provider.
  String? get pocketId;
}

class _DailyTotalsProviderElement
    extends AutoDisposeFutureProviderElement<List<DailyTotal>>
    with DailyTotalsRef {
  _DailyTotalsProviderElement(super.provider);

  @override
  DateTimeRange<DateTime> get range => (origin as DailyTotalsProvider).range;
  @override
  String? get pocketId => (origin as DailyTotalsProvider).pocketId;
}

String _$analyticsDateRangeHash() =>
    r'79242934fe4687d373640690f289e63afd2d18cb';

/// See also [AnalyticsDateRange].
@ProviderFor(AnalyticsDateRange)
final analyticsDateRangeProvider =
    AutoDisposeNotifierProvider<
      AnalyticsDateRange,
      AnalyticsRangePreset
    >.internal(
      AnalyticsDateRange.new,
      name: r'analyticsDateRangeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$analyticsDateRangeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AnalyticsDateRange = AutoDisposeNotifier<AnalyticsRangePreset>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
