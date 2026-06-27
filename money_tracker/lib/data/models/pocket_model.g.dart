// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pocket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PocketModelImpl _$$PocketModelImplFromJson(Map<String, dynamic> json) =>
    _$PocketModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$PocketTypeEnumMap, json['type']),
      balance: (json['balance'] as num).toDouble(),
      color: (json['color'] as num).toInt(),
      icon: json['icon'] as String,
      institution: json['institution'] as String?,
      lastFour: json['lastFour'] as String?,
      isDefault: json['isDefault'] as bool,
    );

Map<String, dynamic> _$$PocketModelImplToJson(_$PocketModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$PocketTypeEnumMap[instance.type]!,
      'balance': instance.balance,
      'color': instance.color,
      'icon': instance.icon,
      'institution': instance.institution,
      'lastFour': instance.lastFour,
      'isDefault': instance.isDefault,
    };

const _$PocketTypeEnumMap = {
  PocketType.cash: 'cash',
  PocketType.bank: 'bank',
  PocketType.ewallet: 'ewallet',
  PocketType.credit: 'credit',
};
