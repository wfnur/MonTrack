import 'package:flutter/material.dart' show DateTimeRange;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/transaction_model.dart';
import 'transaction_providers.dart';

part 'analytics_providers.g.dart';

class CategoryTotal {
  final String categoryId;
  final double total;

  const CategoryTotal({
    required this.categoryId,
    required this.total,
  });
}

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

class DailyTotal {
  final DateTime date;
  final double income;
  final double expense;

  const DailyTotal({
    required this.date,
    required this.income,
    required this.expense,
  });
}

@riverpod
Future<List<CategoryTotal>> categoryTotals(
  CategoryTotalsRef ref,
  TransactionType type,
  DateTimeRange range,
) async {
  final transactions = await ref.watch(transactionRepositoryProvider)
      .getAll(type: type, range: range);
  // Group by categoryId and sum amounts
  final Map<String, double> totals = {};
  for (final tx in transactions) {
    totals[tx.categoryId] = (totals[tx.categoryId] ?? 0.0) + tx.amount;
  }
  return totals.entries
      .map((e) => CategoryTotal(categoryId: e.key, total: e.value))
      .toList()
    ..sort((a, b) => b.total.compareTo(a.total));
}

@riverpod
Future<List<MonthlyTotal>> monthlyTotals(
  MonthlyTotalsRef ref,
  int year,
  String? pocketId,
) async {
  final start = DateTime(year, 1, 1);
  final end = DateTime(year, 12, 31, 23, 59, 59);
  final range = DateTimeRange(start: start, end: end);

  final transactions = await ref.watch(transactionRepositoryProvider)
      .getAll(pocketId: pocketId, range: range);

  final monthlyList = List.generate(
    12,
    (index) => MonthlyTotal(month: index + 1, income: 0.0, expense: 0.0),
  );

  for (final tx in transactions) {
    final monthIndex = tx.date.month - 1;
    if (monthIndex >= 0 && monthIndex < 12) {
      final current = monthlyList[monthIndex];
      if (tx.type == TransactionType.income) {
        monthlyList[monthIndex] = MonthlyTotal(
          month: current.month,
          income: current.income + tx.amount,
          expense: current.expense,
        );
      } else {
        monthlyList[monthIndex] = MonthlyTotal(
          month: current.month,
          income: current.income,
          expense: current.expense + tx.amount,
        );
      }
    }
  }

  return monthlyList;
}

@riverpod
Future<List<DailyTotal>> dailyTotals(
  DailyTotalsRef ref,
  DateTimeRange range,
  String? pocketId,
) async {
  final transactions = await ref.watch(transactionRepositoryProvider)
      .getAll(pocketId: pocketId, range: range);

  final startDay = DateTime(range.start.year, range.start.month, range.start.day);
  final endDay = DateTime(range.end.year, range.end.month, range.end.day);
  final daysCount = endDay.difference(startDay).inDays + 1;

  final Map<DateTime, (double, double)> dailyMap = {};
  for (int i = 0; i < daysCount; i++) {
    final day = startDay.add(Duration(days: i));
    dailyMap[day] = (0.0, 0.0);
  }

  for (final tx in transactions) {
    final txDay = DateTime(tx.date.year, tx.date.month, tx.date.day);
    if (dailyMap.containsKey(txDay)) {
      final current = dailyMap[txDay]!;
      if (tx.type == TransactionType.income) {
        dailyMap[txDay] = (current.$1 + tx.amount, current.$2);
      } else {
        dailyMap[txDay] = (current.$1, current.$2 + tx.amount);
      }
    }
  }

  return dailyMap.entries
      .map((e) => DailyTotal(
            date: e.key,
            income: e.value.$1,
            expense: e.value.$2,
          ))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
}

@riverpod
class AnalyticsDateRange extends _$AnalyticsDateRange {
  DateTimeRange? _customRange;

  @override
  AnalyticsRangePreset build() => AnalyticsRangePreset.thisMonth;

  DateTimeRange get range {
    if (state == AnalyticsRangePreset.custom && _customRange != null) {
      return _customRange!;
    }
    return state.toDateTimeRange();
  }

  void set(AnalyticsRangePreset p) => state = p;

  void setCustom(DateTimeRange customRange) {
    _customRange = customRange;
    ref.notifyListeners();
    state = AnalyticsRangePreset.custom;
  }
}

enum AnalyticsRangePreset {
  thisMonth,
  last3Months,
  thisYear,
  custom;

  DateTimeRange toDateTimeRange() {
    final now = DateTime.now();
    switch (this) {
      case AnalyticsRangePreset.thisMonth:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);
      case AnalyticsRangePreset.last3Months:
        final start = DateTime(now.year, now.month - 2, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);
      case AnalyticsRangePreset.thisYear:
        final start = DateTime(now.year, 1, 1);
        final end = DateTime(now.year, 12, 31, 23, 59, 59);
        return DateTimeRange(start: start, end: end);
      case AnalyticsRangePreset.custom:
        // Default custom to this month as fallback
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return DateTimeRange(start: start, end: end);
    }
  }
}
