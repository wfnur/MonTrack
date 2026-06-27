import 'package:flutter/material.dart' show DateTimeRange;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../data/models/transaction_model.dart';
import 'pocket_providers.dart'; // to watch appDatabaseProvider

part 'transaction_providers.freezed.dart';
part 'transaction_providers.g.dart';

@freezed
class TransactionFilterState with _$TransactionFilterState {
  const factory TransactionFilterState({
    String? pocketId,
    TransactionType? type,
    String? categoryId,
    DateTimeRange? range,
  }) = _TransactionFilterState;
}

@riverpod
class TransactionFilter extends _$TransactionFilter {
  @override
  TransactionFilterState build() => const TransactionFilterState();

  void setPocket(String? id) => state = state.copyWith(pocketId: id);
  void setType(TransactionType? t) => state = state.copyWith(type: t);
  void setCategory(String? id) => state = state.copyWith(categoryId: id);
  void setDateRange(DateTimeRange? r) => state = state.copyWith(range: r);
  void reset() => state = const TransactionFilterState();
}

@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  return TransactionRepository(ref.watch(appDatabaseProvider).transactionDao);
}

@riverpod
Stream<List<TransactionModel>> transactionList(TransactionListRef ref) {
  final filter = ref.watch(transactionFilterProvider);
  return ref.watch(transactionRepositoryProvider).watchAll(
        pocketId: filter.pocketId,
        type: filter.type,
        categoryId: filter.categoryId,
        range: filter.range,
      );
}
