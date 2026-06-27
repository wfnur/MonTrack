import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos/label_dao.dart';
import '../models/label_model.dart';

class LabelRepository {
  final LabelDao _dao;
  LabelRepository(this._dao);

  Stream<List<LabelModel>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map((r) => r.toModel()).toList());
  }

  Future<List<LabelModel>> getAll() async {
    final rows = await _dao.getAll();
    return rows.map((r) => r.toModel()).toList();
  }

  Future<void> add(LabelModel m) => _dao.insertLabel(
        LabelsCompanion.insert(
          id: m.id,
          name: m.name,
          color: m.color,
          createdAt: Value(m.createdAt),
        ),
      );

  Future<void> update(LabelModel m) => _dao.updateLabel(
        LabelsCompanion(
          id: Value(m.id),
          name: Value(m.name),
          color: Value(m.color),
          createdAt: Value(m.createdAt),
        ),
      );

  Future<void> delete(String id) => _dao.deleteLabel(id);
}
