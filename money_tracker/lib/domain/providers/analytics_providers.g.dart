// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseByCategoryHash() => r'd2b2a46304927278e0701a46f39b0203fb40f29b';

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

/// See also [expenseByCategory].
@ProviderFor(expenseByCategory)
const expenseByCategoryProvider = ExpenseByCategoryFamily();

/// See also [expenseByCategory].
class ExpenseByCategoryFamily extends Family<AsyncValue<Map<String, double>>> {
  /// See also [expenseByCategory].
  const ExpenseByCategoryFamily();

  /// See also [expenseByCategory].
  ExpenseByCategoryProvider call(DateTimeRange<DateTime> range) {
    return ExpenseByCategoryProvider(range);
  }

  @override
  ExpenseByCategoryProvider getProviderOverride(
    covariant ExpenseByCategoryProvider provider,
  ) {
    return call(provider.range);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expenseByCategoryProvider';
}

/// See also [expenseByCategory].
class ExpenseByCategoryProvider
    extends AutoDisposeStreamProvider<Map<String, double>> {
  /// See also [expenseByCategory].
  ExpenseByCategoryProvider(DateTimeRange<DateTime> range)
    : this._internal(
        (ref) => expenseByCategory(ref as ExpenseByCategoryRef, range),
        from: expenseByCategoryProvider,
        name: r'expenseByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$expenseByCategoryHash,
        dependencies: ExpenseByCategoryFamily._dependencies,
        allTransitiveDependencies:
            ExpenseByCategoryFamily._allTransitiveDependencies,
        range: range,
      );

  ExpenseByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.range,
  }) : super.internal();

  final DateTimeRange<DateTime> range;

  @override
  Override overrideWith(
    Stream<Map<String, double>> Function(ExpenseByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExpenseByCategoryProvider._internal(
        (ref) => create(ref as ExpenseByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        range: range,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Map<String, double>> createElement() {
    return _ExpenseByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseByCategoryProvider && other.range == range;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpenseByCategoryRef
    on AutoDisposeStreamProviderRef<Map<String, double>> {
  /// The parameter `range` of this provider.
  DateTimeRange<DateTime> get range;
}

class _ExpenseByCategoryProviderElement
    extends AutoDisposeStreamProviderElement<Map<String, double>>
    with ExpenseByCategoryRef {
  _ExpenseByCategoryProviderElement(super.provider);

  @override
  DateTimeRange<DateTime> get range =>
      (origin as ExpenseByCategoryProvider).range;
}

String _$monthlyTotalsHash() => r'6db807ae01cbc28c9f451613f3b79b6316b2be5c';

/// See also [monthlyTotals].
@ProviderFor(monthlyTotals)
const monthlyTotalsProvider = MonthlyTotalsFamily();

/// See also [monthlyTotals].
class MonthlyTotalsFamily extends Family<AsyncValue<List<MonthlyTotal>>> {
  /// See also [monthlyTotals].
  const MonthlyTotalsFamily();

  /// See also [monthlyTotals].
  MonthlyTotalsProvider call(int year) {
    return MonthlyTotalsProvider(year);
  }

  @override
  MonthlyTotalsProvider getProviderOverride(
    covariant MonthlyTotalsProvider provider,
  ) {
    return call(provider.year);
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
    extends AutoDisposeStreamProvider<List<MonthlyTotal>> {
  /// See also [monthlyTotals].
  MonthlyTotalsProvider(int year)
    : this._internal(
        (ref) => monthlyTotals(ref as MonthlyTotalsRef, year),
        from: monthlyTotalsProvider,
        name: r'monthlyTotalsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$monthlyTotalsHash,
        dependencies: MonthlyTotalsFamily._dependencies,
        allTransitiveDependencies:
            MonthlyTotalsFamily._allTransitiveDependencies,
        year: year,
      );

  MonthlyTotalsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
  }) : super.internal();

  final int year;

  @override
  Override overrideWith(
    Stream<List<MonthlyTotal>> Function(MonthlyTotalsRef provider) create,
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
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<MonthlyTotal>> createElement() {
    return _MonthlyTotalsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyTotalsProvider && other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyTotalsRef on AutoDisposeStreamProviderRef<List<MonthlyTotal>> {
  /// The parameter `year` of this provider.
  int get year;
}

class _MonthlyTotalsProviderElement
    extends AutoDisposeStreamProviderElement<List<MonthlyTotal>>
    with MonthlyTotalsRef {
  _MonthlyTotalsProviderElement(super.provider);

  @override
  int get year => (origin as MonthlyTotalsProvider).year;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
