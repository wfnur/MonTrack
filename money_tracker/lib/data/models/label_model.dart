import 'package:freezed_annotation/freezed_annotation.dart';
import '../database/app_database.dart';

part 'label_model.freezed.dart';
part 'label_model.g.dart';

@freezed
class LabelModel with _$LabelModel {
  const factory LabelModel({
    required String id,
    required String name,
    required int color,
    required DateTime createdAt,
  }) = _LabelModel;

  factory LabelModel.fromJson(Map<String, dynamic> json) => _$LabelModelFromJson(json);
}

extension LabelRowMapper on Label {
  LabelModel toModel() {
    return LabelModel(
      id: id,
      name: name,
      color: color,
      createdAt: createdAt,
    );
  }
}
