import 'package:flutter/material.dart' show DateTimeRange;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/transaction_model.dart';
import 'transaction_providers.dart';

part 'analytics_providers.g.dart';

class MonthlyTotal {
  final int month;
  final double income;
  final double expense;

  const MonthlyTotal({
    required this.month,
    required this.income,
    required this.expense,
  });
}

@riverpod
Stream<Map<String, double>> expenseByCategory(ExpenseByCategoryRef ref, DateTimeRange range) {
  return ref.watch(transactionRepositoryProvider).watchAll(
        type: TransactionType.expense,
        range: range,
      ).map((transactions) {
    final map = <String, double>{};
    for (final tx in transactions) {
      map[tx.categoryId] = (map[tx.categoryId] ?? 0.0) + tx.amount;
    }
    return map;
  });
}

@riverpod
Stream<List<MonthlyTotal>> monthlyTotals(MonthlyTotalsRef ref, int year) {
  final start = DateTime(year, 1, 1);
  final end = DateTime(year, 12, 31, 23, 59, 59);
  final range = DateTimeRange(start: start, end: end);

  return ref.watch(transactionRepositoryProvider).watchAll(range: range).map((transactions) {
    final monthlyMaps = List.generate(
      12,
      (index) => MonthlyTotal(month: index + 1, income: 0.0, expense: 0.0),
    );

    for (final tx in transactions) {
      final monthIndex = tx.date.month - 1;
      if (monthIndex >= 0 && monthIndex < 12) {
        final current = monthlyMaps[monthIndex];
        if (tx.type == TransactionType.income) {
          monthlyMaps[monthIndex] = MonthlyTotal(
            month: current.month,
            income: current.income + tx.amount,
            expense: current.expense,
          );
        } else {
          monthlyMaps[monthIndex] = MonthlyTotal(
            month: current.month,
            income: current.income,
            expense: current.expense + tx.amount,
          );
        }
      }
    }
    return monthlyMaps;
  });
}
