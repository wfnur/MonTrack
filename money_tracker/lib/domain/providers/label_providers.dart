import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/label_repository.dart';
import '../../data/models/label_model.dart';
import 'pocket_providers.dart'; // to watch appDatabaseProvider

part 'label_providers.g.dart';

@riverpod
LabelRepository labelRepository(LabelRepositoryRef ref) {
  return LabelRepository(ref.watch(appDatabaseProvider).labelDao);
}

@riverpod
Stream<List<LabelModel>> labelList(LabelListRef ref) {
  return ref.watch(labelRepositoryProvider).watchAll();
}
