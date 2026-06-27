import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/pocket_repository.dart';
import '../../data/models/pocket_model.dart';

part 'pocket_providers.g.dart';

@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase(openConnection());
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
PocketRepository pocketRepository(PocketRepositoryRef ref) {
  return PocketRepository(ref.watch(appDatabaseProvider).pocketDao);
}

@riverpod
Stream<List<PocketModel>> pocketList(PocketListRef ref) {
  return ref.watch(pocketRepositoryProvider).watchAll();
}

@riverpod
Stream<PocketModel?> defaultPocket(DefaultPocketRef ref) {
  return ref.watch(pocketRepositoryProvider).watchDefault();
}

@riverpod
Stream<PocketModel> pocketById(PocketByIdRef ref, String id) {
  return ref.watch(pocketRepositoryProvider).watchById(id);
}
