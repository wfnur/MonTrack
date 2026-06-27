import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/export_repository.dart';
import 'category_providers.dart';
import 'pocket_providers.dart';
import 'transaction_providers.dart';

part 'export_providers.g.dart';

@riverpod
ExportRepository exportRepository(ExportRepositoryRef ref) {
  return ExportRepository(
    ref.watch(transactionRepositoryProvider),
    ref.watch(categoryRepositoryProvider),
    ref.watch(pocketRepositoryProvider),
  );
}
