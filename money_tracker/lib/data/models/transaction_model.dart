import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../database/app_database.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionType { income, expense }

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required TransactionType type,
    required double amount,
    required DateTime date,
    required String categoryId,
    required List<String> labelIds,
    String? note,
    required String pocketId,
    required DateTime createdAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
}

extension TransactionRowMapper on Transaction {
  TransactionModel toModel() {
    return TransactionModel(
      id: id,
      type: TransactionType.values.byName(type),
      amount: amount,
      date: date,
      categoryId: categoryId,
      labelIds: (jsonDecode(labelIds) as List).cast<String>(),
      note: note,
      pocketId: pocketId,
      createdAt: createdAt,
    );
  }
}
