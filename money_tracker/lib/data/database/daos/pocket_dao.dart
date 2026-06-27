import 'package:drift/drift.dart';
import '../app_database.dart';

part 'pocket_dao.g.dart';

@DriftAccessor(tables: [Pockets])
class PocketDao extends DatabaseAccessor<AppDatabase> with _$PocketDaoMixin {
  PocketDao(AppDatabase db) : super(db);

  Stream<List<Pocket>> watchAll() => select(pockets).watch();

  Future<List<Pocket>> getAll() => select(pockets).get();

  Future<Pocket?> getDefault() =>
      (select(pockets)..where((p) => p.isDefault.equals(true))).getSingleOrNull();

  Future<void> insertPocket(PocketsCompanion entry) => into(pockets).insert(entry);

  Future<void> updatePocket(PocketsCompanion entry) => update(pockets).replace(entry);

  Future<void> deletePocket(String id) =>
      (delete(pockets)..where((p) => p.id.equals(id))).go();

  Future<void> setDefault(String id) async {
    await transaction(() async {
      await (update(pockets)..where((p) => p.isDefault.equals(true)))
          .write(const PocketsCompanion(isDefault: Value(false)));
      await (update(pockets)..where((p) => p.id.equals(id)))
          .write(const PocketsCompanion(isDefault: Value(true)));
    });
  }
}
