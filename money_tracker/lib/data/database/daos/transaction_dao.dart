import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import '../app_database.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Stream<List<Transaction>> watchAll({
    String? pocketId,
    String? categoryId,
    String? type,
    DateTimeRange? range,
  }) {
    final query = select(transactions);
    if (pocketId != null) {
      query.where((t) => t.pocketId.equals(pocketId));
    }
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }
    if (type != null) {
      query.where((t) => t.type.equals(type));
    }
    if (range != null) {
      query.where((t) => t.date.isBetweenValues(range.start, range.end));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch();
  }

  Future<List<Transaction>> getAll() => select(transactions).get();

  Future<Transaction?> getById(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertTransaction(TransactionsCompanion entry) =>
      into(transactions).insert(entry);

  Future<void> updateTransaction(TransactionsCompanion entry) =>
      update(transactions).replace(entry);

  Future<void> deleteTransaction(String id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  Stream<double> watchTotalByType(String type, {String? pocketId}) {
    final sumAmount = transactions.amount.sum();
    final query = selectOnly(transactions)..addColumns([sumAmount]);
    query.where(transactions.type.equals(type));
    if (pocketId != null) {
      query.where(transactions.pocketId.equals(pocketId));
    }
    return query.map((row) => row.read(sumAmount) ?? 0.0).watchSingle();
  }
}
