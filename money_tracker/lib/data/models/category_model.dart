import 'package:freezed_annotation/freezed_annotation.dart';
import '../database/app_database.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

enum CategoryType { income, expense, both }

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    required String icon,
    required int color,
    required CategoryType type,
    required bool isDefault,
    required int sortOrder,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
}

extension CategoryRowMapper on Category {
  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      icon: icon,
      color: color,
      type: CategoryType.values.byName(type),
      isDefault: isDefault,
      sortOrder: sortOrder,
    );
  }
}
