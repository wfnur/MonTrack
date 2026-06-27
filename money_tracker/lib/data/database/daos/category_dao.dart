import 'package:drift/drift.dart';
import '../app_database.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  Stream<List<Category>> watchAll({String? type}) {
    final query = select(categories);
    if (type != null) {
      if (type == 'both') {
        query.where((c) => c.type.equals('both'));
      } else {
        query.where((c) => c.type.equals(type) | c.type.equals('both'));
      }
    }
    query.orderBy([(c) => OrderingTerm.asc(c.sortOrder)]);
    return query.watch();
  }

  Future<List<Category>> getAll() => select(categories).get();

  Future<Category?> getById(String id) =>
      (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<void> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Future<void> updateCategory(CategoriesCompanion entry) =>
      update(categories).replace(entry);

  Future<void> deleteCategory(String id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();

  Future<void> insertDefaultCategories(List<CategoriesCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(categories, entries, mode: InsertMode.insertOrReplace);
    });
  }
}
