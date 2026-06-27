import 'package:freezed_annotation/freezed_annotation.dart';
import '../database/app_database.dart';

part 'pocket_model.freezed.dart';
part 'pocket_model.g.dart';

enum PocketType { cash, bank, ewallet, credit }

@freezed
class PocketModel with _$PocketModel {
  const factory PocketModel({
    required String id,
    required String name,
    required PocketType type,
    required double balance,
    required int color,
    required String icon,
    String? institution,
    String? lastFour,
    required bool isDefault,
  }) = _PocketModel;

  factory PocketModel.fromJson(Map<String, dynamic> json) => _$PocketModelFromJson(json);
}

extension PocketRowMapper on Pocket {
  PocketModel toModel() {
    return PocketModel(
      id: id,
      name: name,
      type: PocketType.values.byName(type),
      balance: balance,
      color: color,
      icon: icon,
      institution: institution,
      lastFour: lastFour,
      isDefault: isDefault,
    );
  }
}
