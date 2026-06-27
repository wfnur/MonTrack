import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos/category_dao.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final CategoryDao _dao;
  CategoryRepository(this._dao);

  Stream<List<CategoryModel>> watchAll({CategoryType? type}) {
    return _dao
        .watchAll(type: type?.name)
        .map((rows) => rows.map((r) => r.toModel()).toList());
  }

  Future<CategoryModel?> getById(String id) async {
    final row = await _dao.getById(id);
    return row?.toModel();
  }

  Future<void> add(CategoryModel m) => _dao.insertCategory(
        CategoriesCompanion.insert(
          id: m.id,
          name: m.name,
          icon: m.icon,
          color: m.color,
          type: m.type.name,
          isDefault: Value(m.isDefault),
          sortOrder: Value(m.sortOrder),
        ),
      );

  Future<void> update(CategoryModel m) => _dao.updateCategory(
        CategoriesCompanion(
          id: Value(m.id),
          name: Value(m.name),
          icon: Value(m.icon),
          color: Value(m.color),
          type: Value(m.type.name),
          isDefault: Value(m.isDefault),
          sortOrder: Value(m.sortOrder),
        ),
      );

  Future<void> delete(String id) => _dao.deleteCategory(id);
}
