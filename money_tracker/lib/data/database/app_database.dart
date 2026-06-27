import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'daos/transaction_dao.dart';
import 'daos/category_dao.dart';
import 'daos/label_dao.dart';
import 'daos/pocket_dao.dart';
import 'category_seeds.dart';

part 'app_database.g.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()(); // 'income' or 'expense'
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get categoryId => text()();
  TextColumn get labelIds =>
      text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get note => text().nullable()();
  TextColumn get pocketId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text()(); // icon name string
  IntColumn get color => integer()(); // ARGB int
  TextColumn get type => text()(); // 'income', 'expense', or 'both'
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Labels extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get color => integer()(); // ARGB int
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Pockets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'cash', 'bank', 'ewallet', 'credit'
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  IntColumn get color => integer()();
  TextColumn get icon => text()();
  TextColumn get institution => text().nullable()();
  TextColumn get lastFour => text().nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [Transactions, Categories, Labels, Pockets],
  daos: [TransactionDao, CategoryDao, LabelDao, PocketDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  TransactionDao get transactionDao => TransactionDao(this);
  CategoryDao get categoryDao => CategoryDao(this);
  LabelDao get labelDao => LabelDao(this);
  PocketDao get pocketDao => PocketDao(this);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await categoryDao.insertDefaultCategories(CategorySeeds.getDefaults());
    },
  );
}

AppDatabase? _db;
AppDatabase get database {
  _db ??= AppDatabase(openConnection());
  return _db!;
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(path.join(dir.path, 'money_tracker.db'));
    return NativeDatabase.createInBackground(file);
  });
}
