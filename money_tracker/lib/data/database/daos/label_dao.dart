import 'package:drift/drift.dart';
import '../app_database.dart';

part 'label_dao.g.dart';

@DriftAccessor(tables: [Labels])
class LabelDao extends DatabaseAccessor<AppDatabase> with _$LabelDaoMixin {
  LabelDao(AppDatabase db) : super(db);

  Stream<List<Label>> watchAll() => select(labels).watch();

  Future<List<Label>> getAll() => select(labels).get();

  Future<void> insertLabel(LabelsCompanion entry) => into(labels).insert(entry);

  Future<void> updateLabel(LabelsCompanion entry) => update(labels).replace(entry);

  Future<void> deleteLabel(String id) =>
      (delete(labels)..where((l) => l.id.equals(id))).go();
}
