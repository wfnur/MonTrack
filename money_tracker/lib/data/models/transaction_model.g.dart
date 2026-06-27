// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionModelImpl(
  id: json['id'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  amount: (json['amount'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  categoryId: json['categoryId'] as String,
  labelIds: (json['labelIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  note: json['note'] as String?,
  pocketId: json['pocketId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$TransactionModelImplToJson(
  _$TransactionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'amount': instance.amount,
  'date': instance.date.toIso8601String(),
  'categoryId': instance.categoryId,
  'labelIds': instance.labelIds,
  'note': instance.note,
  'pocketId': instance.pocketId,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
