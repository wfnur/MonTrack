# Flutter Money Tracker — Step-by-Step Build Instructions

> **How to use this file:**
> Work through each step in order. Each step is a self-contained prompt you can give to an AI coding agent. Complete one step fully before moving to the next. Steps are grouped into 5 milestones matching the 35-day plan.

---

## MILESTONE 1 — Foundation (Days 1–7)

---

### Step 1 — Create the Flutter project

**Goal:** Scaffold a clean Flutter project targeting Android.

**Agent instruction:**
```
Create a new Flutter project named "money_tracker" using:
  flutter create money_tracker --org com.yourname --platforms android

After creation, open pubspec.yaml and replace the dependencies section with the following full dependency list:

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.24
  path_provider: ^2.1.3
  path: ^1.9.0
  go_router: ^14.2.7
  fl_chart: ^0.68.0
  excel: ^4.0.6
  file_picker: ^8.1.2
  share_plus: ^10.0.0
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  intl: ^0.19.0
  uuid: ^4.4.2
  flutter_slidable: ^3.1.0
  table_calendar: ^3.1.2
  shimmer: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.11
  drift_dev: ^2.18.0
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.3
  riverpod_lint: ^2.3.13
  custom_lint: ^0.6.7

Then run:
  flutter pub get
```

**Verify:** Running `flutter pub get` completes with no errors. The `money_tracker/` folder exists with standard Flutter structure.

---

### Step 2 — Set up the folder structure

**Goal:** Create the clean 4-layer architecture under `lib/`.

**Agent instruction:**
```
Inside lib/, delete the default main.dart content (keep the file) and create the following folder structure:

lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_sizes.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── currency_formatter.dart
│   │   └── date_formatter.dart
│   └── router/
│       └── app_router.dart
├── data/
│   ├── database/
│   │   ├── app_database.dart
│   │   └── daos/
│   │       ├── transaction_dao.dart
│   │       ├── category_dao.dart
│   │       ├── label_dao.dart
│   │       └── pocket_dao.dart
│   ├── models/
│   │   ├── transaction_model.dart
│   │   ├── category_model.dart
│   │   ├── label_model.dart
│   │   └── pocket_model.dart
│   └── repositories/
│       ├── transaction_repository.dart
│       ├── category_repository.dart
│       ├── label_repository.dart
│       └── pocket_repository.dart
├── domain/
│   └── providers/
│       ├── transaction_providers.dart
│       ├── category_providers.dart
│       ├── label_providers.dart
│       ├── pocket_providers.dart
│       └── analytics_providers.dart
└── presentation/
    ├── home/
    │   ├── home_screen.dart
    │   └── widgets/
    │       ├── balance_card.dart
    │       ├── pocket_switcher.dart
    │       └── recent_transactions.dart
    ├── transactions/
    │   ├── list/
    │   │   ├── transaction_list_screen.dart
    │   │   └── widgets/
    │   │       ├── transaction_tile.dart
    │   │       └── filter_drawer.dart
    │   ├── form/
    │   │   ├── transaction_form_sheet.dart
    │   │   └── widgets/
    │   │       ├── numpad_input.dart
    │   │       ├── category_grid_picker.dart
    │   │       ├── pocket_selector.dart
    │   │       └── label_chips.dart
    │   └── detail/
    │       └── transaction_detail_screen.dart
    ├── analytics/
    │   ├── analytics_screen.dart
    │   └── widgets/
    │       ├── pie_chart_card.dart
    │       ├── bar_chart_card.dart
    │       ├── line_chart_card.dart
    │       └── summary_cards.dart
    └── settings/
        ├── settings_screen.dart
        ├── wallets/
        │   ├── wallets_screen.dart
        │   └── wallet_form_sheet.dart
        ├── categories/
        │   ├── categories_screen.dart
        │   └── category_form_sheet.dart
        ├── labels/
        │   ├── labels_screen.dart
        │   └── label_form_sheet.dart
        └── export/
            └── export_screen.dart

Create each file with an empty placeholder (just a comment: // TODO) so the project compiles.
```

**Verify:** `flutter analyze` should show no file-not-found errors (only TODO warnings are fine).

---

### Step 3 — Define the color constants and theme

**Goal:** Implement the One UI 8.5 design tokens.

**Agent instruction:**
```
Implement the following files:

--- lib/core/constants/app_colors.dart ---
Define a class AppColors with the following static const Color values:
  primary          = Color(0xFF1259C3)
  primarySurface   = Color(0xFFE8F0FE)
  income           = Color(0xFF00B09B)
  expense          = Color(0xFFFF4757)
  background       = Color(0xFFF3F3F3)
  surface          = Color(0xFFFFFFFF)
  textPrimary      = Color(0xFF1A1A1A)
  textSecondary    = Color(0xFF737373)
  border           = Color(0xFFE0E0E0)
  // Dark mode equivalents
  darkBackground   = Color(0xFF121212)
  darkSurface      = Color(0xFF1E1E1E)
  darkBorder       = Color(0xFF2C2C2C)

--- lib/core/constants/app_sizes.dart ---
Define a class AppSizes with:
  static const double cardRadius      = 20;
  static const double sheetRadius     = 28;
  static const double buttonRadius    = 100;
  static const double screenPadding   = 20;
  static const double bottomNavHeight = 68;
  static const double fabSize         = 56;

--- lib/core/constants/app_text_styles.dart ---
Define a class AppTextStyles with TextStyle constants:
  display    = TextStyle(fontSize: 28, fontWeight: FontWeight.w400)
  headline   = TextStyle(fontSize: 22, fontWeight: FontWeight.w500)
  title      = TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
  body       = TextStyle(fontSize: 15, fontWeight: FontWeight.w400)
  caption    = TextStyle(fontSize: 13, fontWeight: FontWeight.w400)

--- lib/core/theme/app_theme.dart ---
Create a class AppTheme with static ThemeData get light and static ThemeData get dark.

Light theme:
  - colorScheme: from seed color AppColors.primary with brightness Brightness.light
  - scaffoldBackgroundColor: AppColors.background
  - cardTheme: shape RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation 0
  - bottomSheetTheme: shape RoundedRectangleBorder(top corners 28dp), backgroundColor AppColors.surface
  - bottomNavigationBarTheme: selectedItemColor AppColors.primary, backgroundColor AppColors.surface, elevation 0, height 68
  - elevatedButtonTheme: shape StadiumBorder, backgroundColor AppColors.primary, foregroundColor white
  - inputDecorationTheme: filled true, fillColor AppColors.surface, border OutlineInputBorder with radius 12 and borderSide none
  - appBarTheme: backgroundColor AppColors.surface, elevation 0, titleTextStyle AppTextStyles.title with AppColors.textPrimary

Dark theme mirrors light but uses dark color tokens.
```

**Verify:** No Dart analysis errors in the core/ folder.

---

### Step 4 — Implement utility formatters

**Goal:** Build reusable currency and date formatting helpers.

**Agent instruction:**
```
Implement the following utility classes:

--- lib/core/utils/currency_formatter.dart ---
Create a class CurrencyFormatter:
  - static String format(double amount, {String symbol = 'Rp', int decimalDigits = 0})
    Uses NumberFormat from package:intl/intl.dart
    Returns formatted string like "Rp 1.500.000"
  - static String formatCompact(double amount, {String symbol = 'Rp'})
    Returns compact format: "Rp 1,5 Jt" for millions, "Rp 500 Rb" for thousands

--- lib/core/utils/date_formatter.dart ---
Create a class DateFormatter:
  - static String format(DateTime date)           → "15 Jan 2025"
  - static String formatShort(DateTime date)      → "15 Jan"
  - static String formatMonthYear(DateTime date)  → "January 2025"
  - static String formatGroupHeader(DateTime date)
    Returns "Today", "Yesterday", or "15 January 2025" depending on the date
  - static bool isSameDay(DateTime a, DateTime b)

All methods use package:intl/intl.dart DateFormat.
```

**Verify:** Write a quick test in main.dart printing formatted values; they should output correctly.

---

### Step 5 — Build the Drift database schema

**Goal:** Define all 4 database tables using Drift annotations.

**Agent instruction:**
```
Implement the Drift database schema.

--- lib/data/database/app_database.dart ---

Import drift/drift.dart and drift/native.dart.

Define 4 table classes:

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();          // 'income' or 'expense'
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get categoryId => text()();
  TextColumn get labelIds => text().withDefault(const Constant('[]'))();  // JSON array
  TextColumn get note => text().nullable()();
  TextColumn get pocketId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text()();          // icon name string
  IntColumn get color => integer()();       // ARGB int
  TextColumn get type => text()();          // 'income', 'expense', or 'both'
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Labels extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get color => integer()();       // ARGB int
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Pockets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();          // 'cash', 'bank', 'ewallet', 'credit'
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  IntColumn get color => integer()();
  TextColumn get icon => text()();
  TextColumn get institution => text().nullable()();
  TextColumn get lastFour => text().nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

Then define the AppDatabase class:
  @DriftDatabase(tables: [Transactions, Categories, Labels, Pockets])
  class AppDatabase extends _$AppDatabase {
    AppDatabase(QueryExecutor e) : super(e);

    @override
    int get schemaVersion => 1;
  }

Create a singleton:
  AppDatabase? _db;
  AppDatabase get database {
    _db ??= AppDatabase(_openConnection());
    return _db!;
  }

  LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'money_tracker.db'));
      return NativeDatabase.createInBackground(file);
    });
  }

Run code generation after:
  flutter pub run build_runner build --delete-conflicting-outputs
```

**Verify:** Generated file `app_database.g.dart` appears with no errors.

---

### Step 6 — Implement all DAOs

**Goal:** Write typed database access methods for all 4 entities.

**Agent instruction:**
```
Implement the 4 DAO classes. Each DAO uses Drift's @DriftAccessor annotation.

--- lib/data/database/daos/transaction_dao.dart ---
@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  Methods to implement:
  - Stream<List<Transaction>> watchAll({String? pocketId, String? categoryId, String? type, DateTimeRange? range})
    Returns a watch query with optional filters chained using .where()
  - Future<List<Transaction>> getAll()
  - Future<Transaction?> getById(String id)
  - Future<void> insertTransaction(TransactionsCompanion entry)
  - Future<void> updateTransaction(TransactionsCompanion entry)
  - Future<void> deleteTransaction(String id)
  - Stream<double> watchTotalByType(String type, {String? pocketId})
    SELECT SUM(amount) WHERE type = ? GROUP
}

--- lib/data/database/daos/category_dao.dart ---
@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  Methods:
  - Stream<List<Category>> watchAll({String? type})
  - Future<List<Category>> getAll()
  - Future<Category?> getById(String id)
  - Future<void> insertCategory(CategoriesCompanion entry)
  - Future<void> updateCategory(CategoriesCompanion entry)
  - Future<void> deleteCategory(String id)
  - Future<void> insertDefaultCategories(List<CategoriesCompanion> entries)
}

--- lib/data/database/daos/label_dao.dart ---
@DriftAccessor(tables: [Labels])
class LabelDao extends DatabaseAccessor<AppDatabase> with _$LabelDaoMixin {
  Methods:
  - Stream<List<Label>> watchAll()
  - Future<List<Label>> getAll()
  - Future<void> insertLabel(LabelsCompanion entry)
  - Future<void> updateLabel(LabelsCompanion entry)
  - Future<void> deleteLabel(String id)
}

--- lib/data/database/daos/pocket_dao.dart ---
@DriftAccessor(tables: [Pockets])
class PocketDao extends DatabaseAccessor<AppDatabase> with _$PocketDaoMixin {
  Methods:
  - Stream<List<Pocket>> watchAll()
  - Future<List<Pocket>> getAll()
  - Future<Pocket?> getDefault()
  - Future<void> insertPocket(PocketsCompanion entry)
  - Future<void> updatePocket(PocketsCompanion entry)
  - Future<void> deletePocket(String id)
  - Future<void> setDefault(String id)
    Clears isDefault on all rows, then sets true for the given id
}

Register all DAOs in AppDatabase by adding them as getters and including in @DriftDatabase(daos: [TransactionDao, CategoryDao, LabelDao, PocketDao]).

Re-run:
  flutter pub run build_runner build --delete-conflicting-outputs
```

**Verify:** All DAO `.g.dart` files generated. No analysis errors.

---

### Step 7 — Seed default categories

**Goal:** Insert 10+ default categories on first app launch.

**Agent instruction:**
```
Create a file lib/data/database/category_seeds.dart

Define a class CategorySeeds with a static method:
  static List<CategoriesCompanion> getDefaults()

Return a list of CategoriesCompanion entries for these categories:

INCOME categories (type: 'income'):
  1. name: 'Salary',       icon: 'ti-briefcase',    color: 0xFF4CAF50, isDefault: true, sortOrder: 0
  2. name: 'Freelance',    icon: 'ti-laptop',        color: 0xFF2196F3, isDefault: true, sortOrder: 1
  3. name: 'Investment',   icon: 'ti-trending-up',   color: 0xFF9C27B0, isDefault: true, sortOrder: 2
  4. name: 'Gift',         icon: 'ti-gift',          color: 0xFFE91E63, isDefault: true, sortOrder: 3
  5. name: 'Other Income', icon: 'ti-plus-circle',   color: 0xFF607D8B, isDefault: true, sortOrder: 4

EXPENSE categories (type: 'expense'):
  6.  name: 'Food',         icon: 'ti-tools-kitchen-2', color: 0xFFFF5722, isDefault: true, sortOrder: 0
  7.  name: 'Transport',    icon: 'ti-car',              color: 0xFF03A9F4, isDefault: true, sortOrder: 1
  8.  name: 'Shopping',     icon: 'ti-shopping-bag',     color: 0xFFE91E63, isDefault: true, sortOrder: 2
  9.  name: 'Bills',        icon: 'ti-file-invoice',     color: 0xFFFF9800, isDefault: true, sortOrder: 3
  10. name: 'Health',       icon: 'ti-heart-rate-monitor', color: 0xFFF44336, isDefault: true, sortOrder: 4
  11. name: 'Entertainment',icon: 'ti-device-gamepad-2', color: 0xFF9C27B0, isDefault: true, sortOrder: 5
  12. name: 'Education',    icon: 'ti-school',           color: 0xFF009688, isDefault: true, sortOrder: 6
  13. name: 'Other',        icon: 'ti-dots-circle',      color: 0xFF9E9E9E, isDefault: true, sortOrder: 7

Each entry uses uuid package to generate a stable ID:
  id: const Uuid().v5(Uuid.NAMESPACE_URL, 'category-{name}')
  This ensures the same ID every time seeds run.

In AppDatabase, add a MigrationStrategy:
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await categoryDao.insertDefaultCategories(CategorySeeds.getDefaults());
    },
  );
```

**Verify:** On first app run, query categories table and confirm 13 rows exist.

---

### Step 8 — Set up GoRouter with bottom navigation shell

**Goal:** Wire the 4-tab navigation shell with GoRouter.

**Agent instruction:**
```
Implement lib/core/router/app_router.dart

Use go_router package. Define a GoRouter with a ShellRoute wrapping 4 tab branches.

Router configuration:
  - initialLocation: '/home'
  - routes:
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home',         builder: (c, s) => const HomeScreen()),
        GoRoute(path: '/transactions', builder: (c, s) => const TransactionListScreen(),
          routes: [
            GoRoute(path: ':id', builder: (c, s) => TransactionDetailScreen(id: s.pathParameters['id']!))
          ]
        ),
        GoRoute(path: '/analytics',   builder: (c, s) => const AnalyticsScreen()),
        GoRoute(path: '/settings',    builder: (c, s) => const SettingsScreen()),
      ]
    )

Create lib/presentation/shell/app_shell.dart:
  A StatefulWidget that holds a bottom NavigationBar with 4 items:
    - Home (icon: Icons.home_outlined, activeIcon: Icons.home)
    - Transactions (icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long)
    - Analytics (icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart)
    - Settings (icon: Icons.settings_outlined, activeIcon: Icons.settings)

  The shell tracks current index. Tapping a tab calls context.go('/route').
  Include a FloatingActionButton (extended) labeled "+ Add" that opens TransactionFormSheet
  as a modal bottom sheet from any tab.

  Scaffold structure:
    body: child
    bottomNavigationBar: NavigationBar(...)
    floatingActionButton: FAB
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked

Update lib/main.dart:
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(
      ProviderScope(
        child: MaterialApp.router(
          title: 'Money Tracker',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: appRouter,
        ),
      ),
    );
  }
```

**Verify:** App launches and shows 4 tabs. Tapping each tab navigates without errors. FAB is visible.

---

## MILESTONE 2 — Data Layer (Days 8–14)

---

### Step 9 — Create Freezed domain models

**Goal:** Generate immutable domain model classes separate from Drift table rows.

**Agent instruction:**
```
Create Freezed model classes in lib/data/models/. These are the domain objects passed to the UI (not the raw Drift row classes).

--- lib/data/models/transaction_model.dart ---
@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required TransactionType type,
    required double amount,
    required DateTime date,
    required String categoryId,
    required List<String> labelIds,
    String? note,
    required String pocketId,
    required DateTime createdAt,
  }) = _TransactionModel;
  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
}

enum TransactionType { income, expense }

--- lib/data/models/category_model.dart ---
@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    required String icon,
    required int color,
    required CategoryType type,
    required bool isDefault,
    required int sortOrder,
  }) = _CategoryModel;
  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
}

enum CategoryType { income, expense, both }

--- lib/data/models/label_model.dart ---
@freezed
class LabelModel with _$LabelModel {
  const factory LabelModel({
    required String id,
    required String name,
    required int color,
    required DateTime createdAt,
  }) = _LabelModel;
  factory LabelModel.fromJson(Map<String, dynamic> json) => _$LabelModelFromJson(json);
}

--- lib/data/models/pocket_model.dart ---
@freezed
class PocketModel with _$PocketModel {
  const factory PocketModel({
    required String id,
    required String name,
    required PocketType type,
    required double balance,
    required int color,
    required String icon,
    String? institution,
    String? lastFour,
    required bool isDefault,
  }) = _PocketModel;
  factory PocketModel.fromJson(Map<String, dynamic> json) => _$PocketModelFromJson(json);
}

enum PocketType { cash, bank, ewallet, credit }

Each model also needs an extension to convert from the Drift row:
  extension TransactionRowMapper on Transaction {
    TransactionModel toModel() => TransactionModel(
      id: id, type: TransactionType.values.byName(type),
      amount: amount, date: date, categoryId: categoryId,
      labelIds: (jsonDecode(labelIds) as List).cast<String>(),
      note: note, pocketId: pocketId, createdAt: createdAt,
    );
  }
  (Add similar extensions for Category, Label, Pocket)

Run:
  flutter pub run build_runner build --delete-conflicting-outputs
```

**Verify:** Generated `.g.dart` and `.freezed.dart` files exist. No analysis errors.

---

### Step 10 — Implement repositories

**Goal:** Build repository classes that wrap DAOs and expose clean domain-model streams.

**Agent instruction:**
```
Implement the 4 repository classes. Repositories convert Drift row objects to domain models.

--- lib/data/repositories/transaction_repository.dart ---
class TransactionRepository {
  final TransactionDao _dao;
  TransactionRepository(this._dao);

  Stream<List<TransactionModel>> watchAll({
    String? pocketId, String? categoryId,
    TransactionType? type, DateTimeRange? range
  }) {
    return _dao.watchAll(
      pocketId: pocketId,
      categoryId: categoryId,
      type: type?.name,
      range: range,
    ).map((rows) => rows.map((r) => r.toModel()).toList());
  }

  Future<TransactionModel?> getById(String id) async {
    final row = await _dao.getById(id);
    return row?.toModel();
  }

  Future<void> add(TransactionModel m) => _dao.insertTransaction(
    TransactionsCompanion.insert(
      id: m.id, type: m.type.name, amount: m.amount, date: m.date,
      categoryId: m.categoryId, pocketId: m.pocketId,
      labelIds: Value(jsonEncode(m.labelIds)),
      note: Value(m.note),
    )
  );

  Future<void> update(TransactionModel m) => _dao.updateTransaction(
    TransactionsCompanion(
      id: Value(m.id), type: Value(m.type.name), amount: Value(m.amount),
      date: Value(m.date), categoryId: Value(m.categoryId),
      pocketId: Value(m.pocketId),
      labelIds: Value(jsonEncode(m.labelIds)),
      note: Value(m.note),
    )
  );

  Future<void> delete(String id) => _dao.deleteTransaction(id);

  Stream<double> watchTotalIncome({String? pocketId}) =>
    _dao.watchTotalByType('income', pocketId: pocketId);

  Stream<double> watchTotalExpense({String? pocketId}) =>
    _dao.watchTotalByType('expense', pocketId: pocketId);
}

--- lib/data/repositories/category_repository.dart ---
class CategoryRepository {
  final CategoryDao _dao;
  CategoryRepository(this._dao);

  Stream<List<CategoryModel>> watchAll({CategoryType? type}) =>
    _dao.watchAll(type: type?.name).map((rows) => rows.map((r) => r.toModel()).toList());

  Future<CategoryModel?> getById(String id) async {
    final row = await _dao.getById(id);
    return row?.toModel();
  }

  Future<void> add(CategoryModel m) => _dao.insertCategory(/* companion */);
  Future<void> update(CategoryModel m) => _dao.updateCategory(/* companion */);
  Future<void> delete(String id) => _dao.deleteCategory(id);
}

--- lib/data/repositories/label_repository.dart ---
  (similar pattern — watchAll, add, update, delete)

--- lib/data/repositories/pocket_repository.dart ---
  (similar pattern — watchAll, getDefault, add, update, delete, setDefault)
```

**Verify:** No analysis errors in the repositories. Types match domain models.

---

### Step 11 — Set up Riverpod providers

**Goal:** Expose reactive state to the UI via Riverpod providers.

**Agent instruction:**
```
Implement all Riverpod providers using @riverpod annotation.

--- lib/domain/providers/pocket_providers.dart ---
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

--- lib/domain/providers/category_providers.dart ---
@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) => ...

@riverpod
Stream<List<CategoryModel>> categoryList(CategoryListRef ref, {String? type}) =>
  ref.watch(categoryRepositoryProvider).watchAll(type: CategoryType.values.byNameOrNull(type));

--- lib/domain/providers/label_providers.dart ---
@riverpod
Stream<List<LabelModel>> labelList(LabelListRef ref) => ...

--- lib/domain/providers/transaction_providers.dart ---
// Filter state notifier
@riverpod
class TransactionFilter extends _$TransactionFilter {
  @override
  TransactionFilterState build() => const TransactionFilterState();

  void setPocket(String? id) => state = state.copyWith(pocketId: id);
  void setType(TransactionType? t) => state = state.copyWith(type: t);
  void setCategory(String? id) => state = state.copyWith(categoryId: id);
  void setDateRange(DateTimeRange? r) => state = state.copyWith(range: r);
  void reset() => state = const TransactionFilterState();
}

@freezed
class TransactionFilterState with _$TransactionFilterState {
  const factory TransactionFilterState({
    String? pocketId, TransactionType? type,
    String? categoryId, DateTimeRange? range,
  }) = _TransactionFilterState;
}

@riverpod
Stream<List<TransactionModel>> transactionList(TransactionListRef ref) {
  final filter = ref.watch(transactionFilterProvider);
  return ref.watch(transactionRepositoryProvider).watchAll(
    pocketId: filter.pocketId, type: filter.type,
    categoryId: filter.categoryId, range: filter.range,
  );
}

--- lib/domain/providers/analytics_providers.dart ---
@riverpod
Stream<Map<String, double>> expenseByCategory(ExpenseByCategoryRef ref, DateTimeRange range) {
  // Aggregates transactions by categoryId for the given range
  // Returns map of categoryId → total amount
}

@riverpod
Stream<List<MonthlyTotal>> monthlyTotals(MonthlyTotalsRef ref, int year) {
  // Groups transactions by month, returns income + expense per month
}

Also create a global database provider:
  @riverpod
  AppDatabase appDatabase(AppDatabaseRef ref) {
    final db = AppDatabase(_openConnection());
    ref.onDispose(() => db.close());
    return db;
  }

Run:
  flutter pub run build_runner build --delete-conflicting-outputs
```

**Verify:** All `.g.dart` provider files generated. No analysis errors.

---

## MILESTONE 3 — Core UI (Days 15–22)

---

### Step 12 — Build the Home Screen

**Goal:** Implement the Home dashboard with balance card, pocket switcher, and recent transactions.

**Agent instruction:**
```
Implement the Home screen and its 3 widgets.

--- lib/presentation/home/home_screen.dart ---
A ConsumerWidget that:
  - Watches pocketListProvider
  - Tracks selected pocket (local state via StateProvider or useState)
  - Shows: AppBar with greeting text, BalanceCard, PocketSwitcher, "Recent" section header, RecentTransactionsList

--- lib/presentation/home/widgets/balance_card.dart ---
A Card widget with:
  - Background: gradient from AppColors.primary to a darker shade
  - "Total Balance" caption text (white, 13sp)
  - Balance amount in AppTextStyles.display (white, 28sp, bold)
  - Two chips below: Income chip (green icon, amount) and Expense chip (red icon, amount)
  - Watches watchTotalIncome and watchTotalExpense from transactionRepositoryProvider
  - pocketId param: String? — if null shows aggregate across all pockets

--- lib/presentation/home/widgets/pocket_switcher.dart ---
A horizontal ListView.builder of pocket mini-cards:
  - First card: "All" (shows total balance)
  - Then one card per pocket
  - Each card: Container with pocket.color as background, rounded 16dp, shows icon + name + balance
  - Selected card has a border ring in AppColors.primary
  - Calls onPocketSelected(String? pocketId) callback

--- lib/presentation/home/widgets/recent_transactions.dart ---
A ListView.builder showing the latest 5 transactions:
  - Watches transactionListProvider
  - Each row: category icon circle + name, note (if any), date label, and amount
  - Amount color: green for income, red for expense
  - Tap navigates to transaction detail: context.push('/transactions/${tx.id}')
  - Show a shimmer placeholder while loading

All widgets receive data via constructor params (not watching providers directly) except the top-level screen.
```

**Verify:** Home screen renders. Balance card shows 0 with no data. Pocket switcher shows "All" card.

---

### Step 13 — Build the Transaction List Screen

**Goal:** Implement the full transaction list with search, date grouping, and swipe actions.

**Agent instruction:**
```
Implement lib/presentation/transactions/list/transaction_list_screen.dart and its widgets.

--- transaction_list_screen.dart ---
A ConsumerStatefulWidget:
  - AppBar with search TextField (shows/hides on search icon tap)
  - Watches transactionListProvider (reactive to filter state)
  - Groups transactions by date using DateFormatter.formatGroupHeader()
  - Uses SliverList with SliverStickyHeader (or manual grouping) to show date separators
  - FAB for adding (same as shell FAB, or hide shell FAB on this screen)
  - Filter icon in AppBar opens FilterDrawer as an end Drawer

--- lib/presentation/transactions/list/widgets/transaction_tile.dart ---
Use flutter_slidable package:
  Slidable(
    startActionPane: ActionPane with SlidableAction(icon: Icons.edit, backgroundColor: primary, onPressed: openEdit),
    endActionPane: ActionPane with SlidableAction(icon: Icons.delete, backgroundColor: expense, onPressed: confirmDelete),
    child: ListTile(...)
  )

  ListTile content:
    leading: CircleAvatar with category color and icon
    title: category name
    subtitle: note or date string
    trailing: Column with amount (colored) and date caption

--- lib/presentation/transactions/list/widgets/filter_drawer.dart ---
A Drawer widget with:
  - "Filter" title and "Reset" button
  - Transaction Type: SegmentedButton (All / Income / Expense)
  - Category: DropdownButton populated from categoryListProvider
  - Pocket: DropdownButton populated from pocketListProvider
  - Date Range: two date pickers (From / To) or DateRangePicker
  - Apply button: calls ref.read(transactionFilterProvider.notifier) to set filters, then Navigator.pop()

Implement search:
  When search text changes, filter the transactionList locally (or update a searchQuery provider).
  Filter by checking if category name, note, or amount string contains the query.
```

**Verify:** Transaction list shows empty state with "No transactions yet" message. Filter drawer opens and closes. Swipe reveals actions.

---

### Step 14 — Build the Add/Edit Transaction Form

**Goal:** The main data entry bottom sheet with numpad, category picker, pocket selector, and label chips.

**Agent instruction:**
```
Implement lib/presentation/transactions/form/transaction_form_sheet.dart

This is a DraggableScrollableSheet shown via showModalBottomSheet.

The form has these sections in a scrollable Column:

1. TYPE TOGGLE at top
   A SegmentedButton or custom toggle:
     [Income] [Expense]
   Changes the accent color of the sheet header.

2. AMOUNT DISPLAY
   Tappable large text showing the current amount.
   Tap opens NumpadInput (see below) as a full-screen overlay.

3. DATE FIELD
   Tappable row showing the selected date.
   Tap opens showDatePicker().

4. CATEGORY GRID
   Label "Category" + selected category chip.
   Tap opens CategoryGridPicker as a nested bottom sheet.

5. POCKET SELECTOR
   Horizontal scroll of PocketModel mini-cards.
   Pre-selects the default pocket.

6. LABEL CHIPS
   Wrap of LabelModel chips.
   Each chip is FilterChip (selected/unselected).
   Shows all labels; allows multi-select.

7. NOTE FIELD
   TextFormField, optional, multiline, max 3 lines shown.

8. SAVE BUTTON
   Validates amount > 0 and category selected.
   Calls transactionRepository.add() or .update().
   Pops the sheet on success.

--- lib/presentation/transactions/form/widgets/numpad_input.dart ---
A full-screen overlay (showGeneralDialog) with:
  - Large display of current amount at top
  - 3x4 grid of digit buttons (1-9, ., 0, ⌫)
  - Each button is 72dp tall, rounded rect
  - Backspace removes last character
  - OK button confirms and dismisses
  - Background: dark scrim

--- lib/presentation/transactions/form/widgets/category_grid_picker.dart ---
A bottom sheet with:
  - Search TextField at top
  - GridView 5 columns of category icon circles
  - Shows only categories matching the current transaction type
  - Tapping a category selects it and closes the sheet

--- lib/presentation/transactions/form/widgets/pocket_selector.dart ---
  Horizontal ListView of mini pocket cards (80x60dp each).
  Selected pocket has a border ring.

--- lib/presentation/transactions/form/widgets/label_chips.dart ---
  Wrap of FilterChip widgets from labelListProvider.
  Tracks selected label IDs in a local Set<String>.

Form state management: Use a local class TransactionFormState with copyWith,
managed by a StateProvider or a StateNotifier. Keep all form field values in one state object.

When editing (TransactionModel? initialData passed to the sheet), pre-fill all fields from initialData.
```

**Verify:** Sheet opens from FAB. Numpad appears on amount tap. Category grid shows categories. Saving inserts a record visible in the transaction list.

---

### Step 15 — Build the Transaction Detail Screen

**Goal:** Read-only view of a transaction with edit and delete actions.

**Agent instruction:**
```
Implement lib/presentation/transactions/detail/transaction_detail_screen.dart

A ConsumerWidget that:
  - Receives transaction id: String from route params
  - Watches a provider: transactionByIdProvider(id)
  - Shows a loading indicator while loading
  - Shows error text if not found

Layout:
  AppBar:
    title: 'Transaction Detail'
    actions: [
      IconButton(icon: Icons.edit, onPressed: openEditSheet),
      IconButton(icon: Icons.delete, onPressed: confirmDelete),
    ]

  Body (Card inside SingleChildScrollView):
    - Amount row: large text, colored by type, with Income/Expense badge
    - Divider
    - Info rows (icon + label + value):
        Date          → formatted date
        Category      → category icon + name
        Pocket        → pocket icon + name
        Labels        → wrap of colored label chips (or "None")
        Note          → text or "No note"
        Created at    → datetime
    - Share button at bottom: shares a text summary via share_plus

Implement the share text:
  "${tx.type.name.toUpperCase()} — ${CurrencyFormatter.format(tx.amount)}\n"
  "Date: ${DateFormatter.format(tx.date)}\n"
  "Category: $categoryName\n"
  "${tx.note != null ? 'Note: ${tx.note}' : ''}"

Delete flow:
  Show AlertDialog asking "Delete this transaction?"
  On confirm: call transactionRepository.delete(id), then context.pop()

Edit flow:
  Call showModalBottomSheet with TransactionFormSheet(initialData: transaction)
```

**Verify:** Tapping a transaction in the list opens detail. Edit pre-fills the form. Delete removes the record and navigates back.

---

### Step 16 — Build Wallets screens

**Goal:** Implement wallet list and add/edit wallet bottom sheet.

**Agent instruction:**
```
Implement the wallets management screens under lib/presentation/settings/wallets/

--- wallets_screen.dart ---
A ConsumerWidget watching pocketListProvider.
Shows:
  - Total balance header card (sum of all pocket balances)
  - ListView of PocketCard widgets
  - FloatingActionButton to add new pocket

Each PocketCard:
  - Colored container (pocket.color with opacity 20% background, solid left border)
  - Row: pocket icon, name, type badge, balance (right-aligned)
  - Long press or trailing menu shows: Edit, Set as Default, Delete
  - Deleting a pocket: show confirmation if it has transactions (warn data impact)

--- wallet_form_sheet.dart ---
A DraggableScrollableSheet with:
  Form fields:
    Name           → TextFormField (required)
    Type           → ChoiceChip row: Cash / Bank / E-Wallet / Credit
    Color          → GridView of 12 preset color circles (selectable)
    Icon           → A simplified icon picker (show 8 preset wallet icons as a grid)
    Institution    → TextFormField (optional, shown only for bank/ewallet/credit)
    Last 4 digits  → TextFormField (optional, shown only for bank/credit, maxLength 4, numeric)

  Validate: name not empty.
  Save: calls pocketRepository.add() or .update().
  If first pocket created, also call pocketRepository.setDefault(id).
```

**Verify:** Wallets screen shows "No wallets" empty state. Adding a wallet shows it in the list. Setting default marks it.

---

### Step 17 — Build Categories and Labels screens

**Goal:** Manage custom income/expense categories and color labels.

**Agent instruction:**
```
--- lib/presentation/settings/categories/categories_screen.dart ---
A ConsumerWidget watching categoryListProvider.
Shows 2 sections: Income Categories and Expense Categories.
Each section is a ListView:
  - Category row: colored icon circle, name, type badge, trailing edit/delete menu
  - Default categories show a lock icon (cannot delete)

CategoryFormSheet:
  Fields: Name (TextFormField), Type (income/expense/both SegmentedButton),
  Icon (icon picker grid — show 20 icon names as labeled circles),
  Color (12 color swatches).
  Save: calls categoryRepository.add() or .update().

--- lib/presentation/settings/labels/labels_screen.dart ---
A ConsumerWidget watching labelListProvider.
Shows a Wrap of colored label chips.
Each chip has a long-press to delete, and a trailing edit icon.

LabelFormSheet (simple):
  Fields: Name (TextFormField), Color (12 color swatches).
  Save: calls labelRepository.add() or .update().

Add inline rename: tapping a label chip opens a small dialog with the name field pre-filled.
```

**Verify:** Default categories visible in list. Adding a new category/label works. Deleting a default category is blocked.

---

### Step 18 — Build the Settings Screen

**Goal:** The main settings hub screen linking to all sub-sections.

**Agent instruction:**
```
Implement lib/presentation/settings/settings_screen.dart

A StatelessWidget with a ListView of settings groups:

Group 1: "General"
  - Currency (shows current symbol, tap to open a dialog with a searchable list of currencies)
  - Appearance (Light / Dark / System — opens a bottom sheet with 3 RadioListTile options)

Group 2: "Manage"
  - Wallets → navigates to WalletsScreen via context.push('/settings/wallets')
  - Categories → navigates to CategoriesScreen
  - Labels → navigates to LabelsScreen

Group 3: "Data"
  - Export / Import → navigates to ExportScreen

Group 4: "About"
  - Version (shows package version from PackageInfo, read-only)
  - Rate this app (launches store URL via url_launcher)
  - Privacy Policy (static text dialog)

For currency: store selected currency code in SharedPreferences.
Create a CurrencyProvider that reads/writes from SharedPreferences.
Available currencies minimum: IDR, USD, EUR, SGD, MYR, GBP, JPY.

Add GoRouter routes:
  /settings/wallets, /settings/categories, /settings/labels, /settings/export
```

**Verify:** Settings screen shows all groups. Each item navigates to the correct screen.

---

## MILESTONE 4 — Analytics (Days 23–27)

---

### Step 19 — Implement analytics data providers

**Goal:** Build the data aggregation logic for charts before building the UI.

**Agent instruction:**
```
Expand lib/domain/providers/analytics_providers.dart

Define data classes:
  class CategoryTotal { final String categoryId; final double total; }
  class MonthlyTotal { final int month; final double income; final double expense; }
  class DailyTotal { final DateTime date; final double income; final double expense; }

Implement providers:

@riverpod
Future<List<CategoryTotal>> categoryTotals(
  CategoryTotalsRef ref,
  TransactionType type,
  DateTimeRange range,
) async {
  final transactions = await ref.watch(transactionRepositoryProvider)
    .getAll(type: type, range: range);
  // Group by categoryId and sum amounts
  final Map<String, double> totals = {};
  for (final tx in transactions) {
    totals[tx.categoryId] = (totals[tx.categoryId] ?? 0) + tx.amount;
  }
  return totals.entries.map((e) => CategoryTotal(categoryId: e.key, total: e.value)).toList()
    ..sort((a, b) => b.total.compareTo(a.total));
}

@riverpod
Future<List<MonthlyTotal>> monthlyTotals(
  MonthlyTotalsRef ref,
  int year,
  String? pocketId,
) async {
  // Get all transactions for the year
  // Group by month, sum income and expense separately
  // Return 12 MonthlyTotal entries (0 for empty months)
}

@riverpod
Future<List<DailyTotal>> dailyTotals(
  DailyTotalsRef ref,
  DateTimeRange range,
  String? pocketId,
) async {
  // Group transactions by day within range
  // Return DailyTotal per day (fill missing days with 0)
}

Also add a date range state provider:
@riverpod
class AnalyticsDateRange extends _$AnalyticsDateRange {
  @override
  AnalyticsRangePreset build() => AnalyticsRangePreset.thisMonth;

  DateTimeRange get range => preset.toDateTimeRange();
  void set(AnalyticsRangePreset p) => state = p;
}

enum AnalyticsRangePreset {
  thisMonth, last3Months, thisYear, custom;
  DateTimeRange toDateTimeRange() { /* compute based on preset */ }
}
```

**Verify:** Call providers in a test widget and print the results to confirm correct grouping.

---

### Step 20 — Build the Analytics Screen

**Goal:** Implement the full analytics screen with 3 chart types and filters.

**Agent instruction:**
```
Implement lib/presentation/analytics/analytics_screen.dart

Structure:
  AppBar: title "Analytics"
  Body: SingleChildScrollView with:
    1. Date range filter chips (row of preset chips + "Custom" chip)
    2. Income/Expense toggle (SegmentedButton)
    3. Summary cards row
    4. PieChartCard
    5. BarChartCard
    6. LineChartCard

--- lib/presentation/analytics/widgets/summary_cards.dart ---
Row of 3 cards:
  - Total Income (green, income amount)
  - Total Expense (red, expense amount)
  - Net Balance (blue, income - expense, can be negative)
Each card: colored icon, label, large amount text.

--- lib/presentation/analytics/widgets/pie_chart_card.dart ---
Uses fl_chart PieChart widget.
  - Watches categoryTotalsProvider(type, range)
  - Each CategoryTotal becomes a PieChartSectionData with the category color
  - Show a legend below the chart (category name + percentage + amount)
  - Show "No data" placeholder when list is empty
  - On section tap: highlight the tapped section (touchedIndex state)

--- lib/presentation/analytics/widgets/bar_chart_card.dart ---
Uses fl_chart BarChart widget.
  - Watches monthlyTotalsProvider(year, pocketId)
  - X axis: Jan–Dec (abbreviated)
  - Y axis: auto-scaled to max value
  - Each month has 2 bars: income (green) and expense (red)
  - BarTooltip shows exact values on touch

--- lib/presentation/analytics/widgets/line_chart_card.dart ---
Uses fl_chart LineChart widget.
  - Watches dailyTotalsProvider(range, pocketId)
  - One line for income (green), one for expense (red)
  - X axis: dates within range
  - Y axis: auto-scaled
  - Show dots at data points, smooth curves
  - LineTouchData tooltip shows date and amounts

Date range custom picker:
  When "Custom" chip tapped, show showDateRangePicker().
  On selection, call ref.read(analyticsDateRangeProvider.notifier).setCustom(range).
```

**Verify:** Charts render. Switching Income/Expense toggle updates pie chart. Changing date range updates all charts.

---

## MILESTONE 5 — Polish & Export (Days 28–35)

---

### Step 21 — Implement Export and Import

**Goal:** Export transactions to XLSX/CSV and import from a file.

**Agent instruction:**
```
Implement lib/presentation/settings/export/export_screen.dart

UI sections:

1. FORMAT selector
   Row of two choice buttons: XLSX and CSV
   Track selected format in local state.

2. DATE RANGE selector
   DropdownButton with options: This Month / Last 3 Months / This Year / All Time / Custom
   Custom opens showDateRangePicker().

3. POCKET SCOPE selector
   DropdownButton: All Pockets / then each pocket by name.

4. EXPORT button
   Generates file and shares via share_plus.

5. IMPORT section (separated by Divider)
   "Import from file" button.
   Opens file_picker with allowedExtensions: ['csv', 'xlsx'].
   Shows row count preview in a dialog.
   Confirm button triggers import.

--- XLSX Export logic ---
Create lib/data/repositories/export_repository.dart:

  Future<File> exportToXlsx(List<TransactionModel> transactions, Map<String, CategoryModel> categories, Map<String, PocketModel> pockets) async {
    final excel = Excel.createExcel();
    final sheet = excel['Transactions'];

    // Header row
    sheet.appendRow(['Date', 'Type', 'Amount', 'Category', 'Pocket', 'Labels', 'Note']);

    for (final tx in transactions) {
      sheet.appendRow([
        DateFormatter.format(tx.date),
        tx.type.name,
        tx.amount,
        categories[tx.categoryId]?.name ?? '',
        pockets[tx.pocketId]?.name ?? '',
        tx.labelIds.join(', '),
        tx.note ?? '',
      ]);
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/money_tracker_export_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.encode();
    return file..writeAsBytesSync(bytes!);
  }

--- CSV Export logic ---
  Future<File> exportToCsv(List<TransactionModel> transactions, ...) async {
    final buffer = StringBuffer();
    buffer.writeln('Date,Type,Amount,Category,Pocket,Labels,Note');
    for (final tx in transactions) {
      buffer.writeln('"${DateFormatter.format(tx.date)}","${tx.type.name}",${tx.amount},...');
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/money_tracker_export.csv');
    return file..writeAsStringSync(buffer.toString());
  }

--- Import logic ---
  Future<ImportResult> importFromCsv(String filePath) async {
    final content = File(filePath).readAsStringSync();
    final lines = content.split('\n');
    // Skip header row (lines[0])
    final records = <TransactionModel>[];
    for (final line in lines.skip(1)) {
      if (line.trim().isEmpty) continue;
      // Parse CSV fields (handle quoted commas)
      // Map to TransactionModel
      // Look up categoryId by name (create new category if not found)
      // Look up pocketId by name
      records.add(...);
    }
    return ImportResult(count: records.length, records: records);
  }

  Future<void> commitImport(List<TransactionModel> records) async {
    for (final tx in records) {
      await transactionRepository.add(tx);
    }
  }
```

**Verify:** Export button generates a file and opens the share sheet. XLSX opens in Excel/Sheets with correct columns.

---

### Step 22 — Add animations and micro-interactions

**Goal:** Apply One UI 8.5 spring animations throughout the app.

**Agent instruction:**
```
Add animations using Flutter's animation system and Curves.elasticOut.

1. BOTTOM SHEET ENTRANCE
   Wrap TransactionFormSheet and all other bottom sheets with:
     showModalBottomSheet(
       ...
       transitionAnimationController: AnimationController(
         vsync: this,
         duration: const Duration(milliseconds: 400),
       )..forward(),
     )
   Or use a custom SlideTransition from bottom with Curves.easeOutCubic.

2. TRANSACTION TILE INSERTION
   Wrap the AnimatedList or use implicit animation:
   When a new transaction is added, AnimatedList.insertItem with a
   SizeTransition(sizeFactor: CurvedAnimation(parent: anim, curve: Curves.elasticOut))
   wrapped around the tile.

3. BALANCE CARD COUNTER ANIMATION
   When balance changes, use TweenAnimationBuilder<double>:
     TweenAnimationBuilder<double>(
       tween: Tween(begin: oldBalance, end: newBalance),
       duration: const Duration(milliseconds: 600),
       curve: Curves.easeOutCubic,
       builder: (context, value, _) => Text(CurrencyFormatter.format(value))
     )

4. FAB PULSE on first launch:
   Add a ScaleTransition to the FAB with a repeating AnimationController
   (plays once on first launch, stored in SharedPreferences).

5. CATEGORY GRID STAGGER:
   In CategoryGridPicker, wrap each item with:
     AnimationDelay widget (or TweenAnimationBuilder) that staggers the
     FadeTransition + SlideTransition of each grid item by index * 30ms.

6. PAGE TRANSITION:
   Configure GoRouter with custom pageTransitionsBuilder:
     In app_theme.dart, set pageTransitionsTheme:
     PageTransitionsTheme(builders: {
       TargetPlatform.android: CupertinoPageTransitionsBuilder(),
     })
     Or use a FadeUpwardsPageTransitionsBuilder for a smoother feel.
```

**Verify:** Opening a bottom sheet has a smooth spring entrance. Transaction tiles animate in when added.

---

### Step 23 — Dark mode polish

**Goal:** Ensure all screens look correct in system dark mode.

**Agent instruction:**
```
Audit and fix dark mode across all screens.

Update lib/core/theme/app_theme.dart dark theme with these specific overrides:
  scaffoldBackgroundColor: Color(0xFF121212)
  cardColor: Color(0xFF1E1E1E)
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF5B8DEF),        // lighter blue for dark bg contrast
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE0E0E0),
  )
  bottomNavigationBarTheme: backgroundColor: Color(0xFF1E1E1E)
  bottomSheetTheme: backgroundColor: Color(0xFF1E1E1E)
  inputDecorationTheme: fillColor: Color(0xFF2C2C2C)

Go through each screen and fix hardcoded colors:
  - Replace Color(0xFFFFFFFF) → Theme.of(context).colorScheme.surface
  - Replace Color(0xFF1A1A1A) → Theme.of(context).colorScheme.onSurface
  - Replace Color(0xFFF3F3F3) → Theme.of(context).scaffoldBackgroundColor
  - Replace Color(0xFFE0E0E0) → Theme.of(context).dividerColor

Fix the BalanceCard gradient:
  In dark mode, use a darker primary gradient:
  Brightness.dark → LinearGradient(colors: [Color(0xFF1A3A7A), Color(0xFF0D2456)])

Fix PieChart and BarChart background color:
  chart container → Theme.of(context).colorScheme.surface

Test on Android with Settings → Display → Dark mode enabled.
```

**Verify:** Toggle system dark mode. All screens switch cleanly without white flashes or invisible text.

---

### Step 24 — Implement empty states and loading states

**Goal:** Every screen should handle empty data and loading gracefully.

**Agent instruction:**
```
Add empty state and loading state handling to all list screens.

Create a reusable widget: lib/presentation/common/empty_state.dart
  class EmptyState extends StatelessWidget {
    final String icon;       // emoji or icon
    final String title;
    final String? subtitle;
    final Widget? action;    // optional button

    Widget build(...) => Center(
      child: Column(children: [
        Text(icon, style: TextStyle(fontSize: 64)),
        SizedBox(height: 16),
        Text(title, style: AppTextStyles.headline),
        if (subtitle != null) Text(subtitle, style: AppTextStyles.body, textAlign: center),
        if (action != null) Padding(child: action),
      ])
    );
  }

Apply empty states:

Home (no transactions):
  EmptyState(icon: '💸', title: 'No transactions yet',
    subtitle: 'Tap + to add your first income or expense',
    action: ElevatedButton(onPressed: openAddSheet, child: Text('Add Transaction')))

Transaction List (no results after filter):
  EmptyState(icon: '🔍', title: 'No results found',
    subtitle: 'Try adjusting your search or filters',
    action: TextButton(onPressed: resetFilters, child: Text('Reset Filters')))

Analytics (no data for range):
  EmptyState(icon: '📊', title: 'No data for this period',
    subtitle: 'Add transactions to see your analytics')

Wallets (no pockets):
  EmptyState(icon: '👛', title: 'No wallets yet',
    subtitle: 'Add your first wallet to get started',
    action: ElevatedButton(onPressed: openAddWallet, child: Text('Add Wallet')))

Create a reusable shimmer loading:
  lib/presentation/common/shimmer_list.dart
  Shows 5 shimmer placeholder tiles using the shimmer package.
  Use Shimmer.fromColors(baseColor: grey[300], highlightColor: grey[100], child: ...)

Apply shimmer to:
  - Home recent transactions (while AsyncValue is loading)
  - Transaction list screen (while first load)
  - Wallets list (while loading)

Pattern:
  ref.watch(transactionListProvider).when(
    data: (list) => list.isEmpty ? EmptyState(...) : ListView.builder(...),
    loading: () => ShimmerList(),
    error: (e, st) => ErrorState(message: e.toString()),
  )
```

**Verify:** Kill database and reopen app — shimmer shows briefly. Clear all transactions — empty state appears.

---

### Step 25 — Handle edge cases and input validation

**Goal:** Make the app robust against bad input and unexpected states.

**Agent instruction:**
```
Add validation and edge case guards throughout the app.

1. TRANSACTION FORM validation:
   - Amount: must be > 0. Show error: "Please enter an amount"
   - Category: must be selected. Highlight the category field in red if empty on submit.
   - Pocket: auto-select default; if no pockets exist, show: "Please add a wallet first"
     and disable the save button.

2. POCKET DELETION guard:
   Before deleting a pocket, check if any transactions use this pocketId:
     final count = await transactionRepository.countByPocket(pocketId);
     if (count > 0) show AlertDialog:
       "This wallet has $count transaction(s). Deleting it will keep those transactions
       but they will be unlinked from any wallet. Continue?"
   Add countByPocket() method to TransactionRepository and TransactionDao.

3. CATEGORY DELETION guard:
   Same pattern: check transaction count for this categoryId.
   If > 0, warn user. Block deletion for isDefault categories entirely.

4. IMPORT validation:
   If CSV row is missing required fields (amount, date, type), skip that row and
   add it to an ImportResult.skippedRows list.
   Show skipped count in the confirmation dialog:
   "Imported 45 rows. Skipped 3 rows with invalid data."

5. AMOUNT input sanitization in numpad:
   - Max 12 digits total
   - Only one decimal point allowed
   - Leading zeros stripped
   - Zero amount shows "0" not ""

6. NULL POCKET in transactions:
   If a transaction's pocketId no longer exists (pocket was deleted), show
   "Deleted wallet" as the pocket name in transaction detail and list.
   Add a fallback in the repository: if pocket not found, return a placeholder PocketModel.

7. DATABASE migration:
   Set schemaVersion to 1 now. Document that future columns require a migration
   in the MigrationStrategy.onUpgrade callback.
```

**Verify:** Try saving a form with no amount — error appears. Try deleting a pocket with transactions — warning appears.

---

### Step 26 — Implement the Onboarding flow

**Goal:** First-run experience that sets up currency and first wallet.

**Agent instruction:**
```
Create lib/presentation/onboarding/ folder.

--- onboarding_screen.dart ---
A full-screen flow with 3 steps managed by a PageController.

Step 1 — Welcome & Currency:
  Title: "Welcome to Money Tracker"
  Subtitle: "Track your income and expenses easily"
  Currency picker: A searchable list of currencies:
    [{ code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah' },
     { code: 'USD', symbol: '$', name: 'US Dollar' },
     { code: 'EUR', symbol: '€', name: 'Euro' },
     { code: 'SGD', symbol: 'S$', name: 'Singapore Dollar' },
     { code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit' },
     { code: 'GBP', symbol: '£', name: 'British Pound' },
     { code: 'JPY', symbol: '¥', name: 'Japanese Yen' }]
  Save selection to SharedPreferences key: 'currency_code' and 'currency_symbol'.

Step 2 — Create first wallet:
  Title: "Add your first wallet"
  Show a simplified WalletForm inline (not bottom sheet):
    Name field + Type selector (Cash / Bank / E-Wallet / Credit)
  "Skip" link (uses default "Cash" wallet named "My Wallet")

Step 3 — Done:
  Title: "You're all set!"
  Subtitle: "Start recording your first transaction"
  Big button: "Get Started"

Navigation logic in main.dart:
  Check SharedPreferences for 'onboarding_complete' key.
  If false → push OnboardingScreen.
  If true → push AppShell (normal app).

In GoRouter, add:
  redirect: (context, state) {
    final prefs = ref.read(sharedPrefsProvider);
    final done = prefs.getBool('onboarding_complete') ?? false;
    if (!done && state.matchedLocation != '/onboarding') return '/onboarding';
    if (done && state.matchedLocation == '/onboarding') return '/home';
    return null;
  }

On "Get Started" tap:
  await prefs.setBool('onboarding_complete', true);
  context.go('/home');
```

**Verify:** Delete app data and relaunch — onboarding shows. Complete it — home screen appears. Relaunch — onboarding does not show again.

---

### Step 27 — Final QA and performance pass

**Goal:** End-to-end verification of all features and performance optimization.

**Agent instruction:**
```
Perform a systematic QA pass and apply these performance optimizations:

1. WIDGET REBUILD AUDIT:
   Add the flutter DevTools "Highlight repaints" and check that:
   - BalanceCard only rebuilds when balance changes (not on every navigation)
   - TransactionList does not rebuild the whole list when one item is tapped
   - Use select() to narrow provider subscriptions:
     ref.watch(transactionFilterProvider.select((s) => s.pocketId))
     instead of watching the whole filter state in widgets that only care about pocketId

2. DATABASE QUERY OPTIMIZATION:
   Ensure watchAll() queries use .watch() not polling.
   Add database indexes for frequently filtered columns:
   In app_database.dart onCreate, execute:
     await m.createIndex(Index('idx_tx_date', 'CREATE INDEX idx_tx_date ON transactions (date DESC)'));
     await m.createIndex(Index('idx_tx_pocket', 'CREATE INDEX idx_tx_pocket ON transactions (pocket_id)'));
     await m.createIndex(Index('idx_tx_category', 'CREATE INDEX idx_tx_category ON transactions (category_id)'));

3. IMAGE / ICON PERFORMANCE:
   If using any icon fonts or images, ensure they are loaded only once.
   Wrap icon circles with RepaintBoundary to prevent unnecessary repaints.

4. LIST PERFORMANCE:
   Ensure all long lists use ListView.builder (not ListView with children:[]).
   Add const constructors to all stateless widgets that don't use any context values.

5. MANUAL QA CHECKLIST — test each item on a physical device:
   [ ] Add income transaction → appears in Home and Transaction list
   [ ] Add expense transaction → balance decreases, appears in list
   [ ] Edit a transaction → changes reflected everywhere
   [ ] Delete a transaction → removed from list
   [ ] Add a wallet → appears in pocket switcher on Home
   [ ] Switch pocket on Home → balance and recent list filter to that pocket
   [ ] Filter transactions by category → list filters correctly
   [ ] Search transactions → results update in real time
   [ ] Analytics pie chart shows category breakdown
   [ ] Analytics bar chart shows monthly data
   [ ] Change date range in analytics → charts update
   [ ] Toggle dark mode → all screens look correct
   [ ] Export to XLSX → file opens correctly in Excel
   [ ] Export to CSV → file opens correctly
   [ ] Import from CSV → records appear in transaction list
   [ ] Onboarding completes → home screen shows
   [ ] App reopens → data persists correctly

6. RELEASE BUILD TEST:
   flutter build apk --release
   Install and verify the release APK works identically to debug.
```

**Verify:** All QA checklist items pass on a physical Android device.

---

## APPENDIX — Quick Reference

### Run code generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run in watch mode (during development)
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Analyze for errors
```bash
flutter analyze
```

### Run tests
```bash
flutter test
```

### Common data flow pattern
```
DB (Drift) → DAO → Repository → Riverpod Provider → UI Widget
         (Stream)        (Stream<DomainModel>)   (AsyncValue)
```

### Key file locations quick-reference

| What | Where |
|------|-------|
| Colors | `lib/core/constants/app_colors.dart` |
| Theme | `lib/core/theme/app_theme.dart` |
| Router | `lib/core/router/app_router.dart` |
| Database | `lib/data/database/app_database.dart` |
| Domain models | `lib/data/models/` |
| Providers | `lib/domain/providers/` |
| Screens | `lib/presentation/` |

---

*Total: 27 steps across 5 milestones — Foundation → Data Layer → Core UI → Analytics → Polish*
