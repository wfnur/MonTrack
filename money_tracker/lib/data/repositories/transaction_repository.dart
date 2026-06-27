import 'dart:convert';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos/transaction_dao.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final TransactionDao _dao;
  TransactionRepository(this._dao);

  Stream<List<TransactionModel>> watchAll({
    String? pocketId,
    String? categoryId,
    TransactionType? type,
    DateTimeRange? range,
  }) {
    return _dao
        .watchAll(
          pocketId: pocketId,
          categoryId: categoryId,
          type: type?.name,
          range: range,
        )
        .map((rows) => rows.map((r) => r.toModel()).toList());
  }

  Future<TransactionModel?> getById(String id) async {
    final row = await _dao.getById(id);
    return row?.toModel();
  }

  Stream<TransactionModel?> watchById(String id) {
    return _dao.watchById(id).map((row) => row?.toModel());
  }

  Future<void> add(TransactionModel m) => _dao.insertTransaction(
        TransactionsCompanion.insert(
          id: m.id,
          type: m.type.name,
          amount: m.amount,
          date: m.date,
          categoryId: m.categoryId,
          pocketId: m.pocketId,
          labelIds: Value(jsonEncode(m.labelIds)),
          note: Value(m.note),
          createdAt: Value(m.createdAt),
        ),
      );

  Future<void> update(TransactionModel m) => _dao.updateTransaction(
        TransactionsCompanion(
          id: Value(m.id),
          type: Value(m.type.name),
          amount: Value(m.amount),
          date: Value(m.date),
          categoryId: Value(m.categoryId),
          pocketId: Value(m.pocketId),
          labelIds: Value(jsonEncode(m.labelIds)),
          note: Value(m.note),
          createdAt: Value(m.createdAt),
        ),
      );

  Future<void> delete(String id) => _dao.deleteTransaction(id);

  Stream<double> watchTotalIncome({String? pocketId}) =>
      _dao.watchTotalByType('income', pocketId: pocketId);

  Stream<double> watchTotalExpense({String? pocketId}) =>
      _dao.watchTotalByType('expense', pocketId: pocketId);
}
