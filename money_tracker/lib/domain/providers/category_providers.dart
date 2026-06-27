import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/models/category_model.dart';
import 'pocket_providers.dart'; // to watch appDatabaseProvider

part 'category_providers.g.dart';

extension CategoryTypeByNameOrNull on Iterable<CategoryType> {
  CategoryType? byNameOrNull(String? name) {
    if (name == null) return null;
    for (final value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}

@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return CategoryRepository(ref.watch(appDatabaseProvider).categoryDao);
}

@riverpod
Stream<List<CategoryModel>> categoryList(CategoryListRef ref, {String? type}) {
  return ref.watch(categoryRepositoryProvider).watchAll(
        type: CategoryType.values.byNameOrNull(type),
      );
}
