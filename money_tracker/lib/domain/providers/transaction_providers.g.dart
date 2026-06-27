// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionRepositoryHash() =>
    r'5871991604bebf2b7cb2b05c7a360d213feaf797';

/// See also [transactionRepository].
@ProviderFor(transactionRepository)
final transactionRepositoryProvider =
    AutoDisposeProvider<TransactionRepository>.internal(
      transactionRepository,
      name: r'transactionRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionRepositoryRef =
    AutoDisposeProviderRef<TransactionRepository>;
String _$transactionListHash() => r'd4df824c525b6423490630f87041793d3a077d03';

/// See also [transactionList].
@ProviderFor(transactionList)
final transactionListProvider =
    AutoDisposeStreamProvider<List<TransactionModel>>.internal(
      transactionList,
      name: r'transactionListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionListRef =
    AutoDisposeStreamProviderRef<List<TransactionModel>>;
String _$transactionFilterHash() => r'e124b6193bdaded3ad4ebe3f6f956089211926e0';

/// See also [TransactionFilter].
@ProviderFor(TransactionFilter)
final transactionFilterProvider =
    AutoDisposeNotifierProvider<
      TransactionFilter,
      TransactionFilterState
    >.internal(
      TransactionFilter.new,
      name: r'transactionFilterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionFilterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TransactionFilter = AutoDisposeNotifier<TransactionFilterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
