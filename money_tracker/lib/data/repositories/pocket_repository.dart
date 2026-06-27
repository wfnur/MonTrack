import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/daos/pocket_dao.dart';
import '../models/pocket_model.dart';

class PocketRepository {
  final PocketDao _dao;
  PocketRepository(this._dao);

  Stream<List<PocketModel>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map((r) => r.toModel()).toList());
  }

  Stream<PocketModel?> watchDefault() {
    return watchAll().map((list) => list.isEmpty
        ? null
        : list.firstWhere((p) => p.isDefault, orElse: () => list.first));
  }


  Future<List<PocketModel>> getAll() async {
    final rows = await _dao.getAll();
    return rows.map((r) => r.toModel()).toList();
  }

  Future<PocketModel?> getDefault() async {
    final row = await _dao.getDefault();
    return row?.toModel();
  }

  Future<void> add(PocketModel m) => _dao.insertPocket(
        PocketsCompanion.insert(
          id: m.id,
          name: m.name,
          type: m.type.name,
          balance: Value(m.balance),
          color: m.color,
          icon: m.icon,
          institution: Value(m.institution),
          lastFour: Value(m.lastFour),
          isDefault: Value(m.isDefault),
        ),
      );

  Future<void> update(PocketModel m) => _dao.updatePocket(
        PocketsCompanion(
          id: Value(m.id),
          name: Value(m.name),
          type: Value(m.type.name),
          balance: Value(m.balance),
          color: Value(m.color),
          icon: Value(m.icon),
          institution: Value(m.institution),
          lastFour: Value(m.lastFour),
          isDefault: Value(m.isDefault),
        ),
      );

  Future<void> delete(String id) => _dao.deletePocket(id);

  Future<void> setDefault(String id) => _dao.setDefault(id);
}
