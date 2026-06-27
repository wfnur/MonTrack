import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'app_database.dart';

class CategorySeeds {
  CategorySeeds._();

  static List<CategoriesCompanion> getDefaults() {
    const uuid = Uuid();
    final categories = [
      // Income
      ('Salary', 'ti-briefcase', 0xFF4CAF50, 'income', 0),
      ('Freelance', 'ti-laptop', 0xFF2196F3, 'income', 1),
      ('Investment', 'ti-trending-up', 0xFF9C27B0, 'income', 2),
      ('Gift', 'ti-gift', 0xFFE91E63, 'income', 3),
      ('Other Income', 'ti-plus-circle', 0xFF607D8B, 'income', 4),
      // Expense
      ('Food', 'ti-tools-kitchen-2', 0xFFFF5722, 'expense', 0),
      ('Transport', 'ti-car', 0xFF03A9F4, 'expense', 1),
      ('Shopping', 'ti-shopping-bag', 0xFFE91E63, 'expense', 2),
      ('Bills', 'ti-file-invoice', 0xFFFF9800, 'expense', 3),
      ('Health', 'ti-heart-rate-monitor', 0xFFF44336, 'expense', 4),
      ('Entertainment', 'ti-device-gamepad-2', 0xFF9C27B0, 'expense', 5),
      ('Education', 'ti-school', 0xFF009688, 'expense', 6),
      ('Other', 'ti-dots-circle', 0xFF9E9E9E, 'expense', 7),
    ];

    return categories.map((c) {
      final name = c.$1;
      final icon = c.$2;
      final color = c.$3;
      final type = c.$4;
      final sortOrder = c.$5;

      final id = uuid.v5(Namespace.url.value, 'category-$name');

      return CategoriesCompanion(
        id: Value(id),
        name: Value(name),
        icon: Value(icon),
        color: Value(color),
        type: Value(type),
        isDefault: const Value(true),
        sortOrder: Value(sortOrder),
      );
    }).toList();
  }
}
