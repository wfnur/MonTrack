import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/date_formatter.dart';
import '../models/category_model.dart';
import '../models/pocket_model.dart';
import '../models/transaction_model.dart';
import 'category_repository.dart';
import 'pocket_repository.dart';
import 'transaction_repository.dart';

class ImportResult {
  final int count;
  final List<TransactionModel> records;

  const ImportResult({required this.count, required this.records});
}

class ExportRepository {
  final TransactionRepository _transactionRepo;
  final CategoryRepository _categoryRepo;
  final PocketRepository _pocketRepo;

  ExportRepository(this._transactionRepo, this._categoryRepo, this._pocketRepo);

  CellValue? _toCellValue(dynamic val) {
    if (val == null) return null;
    if (val is String) return TextCellValue(val);
    if (val is double) return DoubleCellValue(val);
    if (val is int) return IntCellValue(val);
    return TextCellValue(val.toString());
  }

  Future<File> exportToXlsx(
    List<TransactionModel> transactions,
    Map<String, CategoryModel> categories,
    Map<String, PocketModel> pockets,
  ) async {
    final excel = Excel.createExcel();
    final sheet = excel['Transactions'];

    // Header row
    sheet.appendRow([
      _toCellValue('Date'),
      _toCellValue('Type'),
      _toCellValue('Amount'),
      _toCellValue('Category'),
      _toCellValue('Pocket'),
      _toCellValue('Labels'),
      _toCellValue('Note'),
    ]);

    for (final tx in transactions) {
      sheet.appendRow([
        _toCellValue(DateFormatter.format(tx.date)),
        _toCellValue(tx.type.name),
        _toCellValue(tx.amount),
        _toCellValue(categories[tx.categoryId]?.name ?? ''),
        _toCellValue(pockets[tx.pocketId]?.name ?? ''),
        _toCellValue(tx.labelIds.join(', ')),
        _toCellValue(tx.note ?? ''),
      ]);
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/money_tracker_export_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.encode();
    if (bytes != null) {
      file.writeAsBytesSync(bytes);
    }
    return file;
  }

  Future<File> exportToCsv(
    List<TransactionModel> transactions,
    Map<String, CategoryModel> categories,
    Map<String, PocketModel> pockets,
  ) async {
    final buffer = StringBuffer();
    buffer.writeln('Date,Type,Amount,Category,Pocket,Labels,Note');
    for (final tx in transactions) {
      final date = DateFormatter.format(tx.date);
      final type = tx.type.name;
      final amount = tx.amount;
      final cat = categories[tx.categoryId]?.name ?? '';
      final poc = pockets[tx.pocketId]?.name ?? '';
      final labels = tx.labelIds.join('; ');
      final note = (tx.note ?? '').replaceAll('"', '""');
      buffer.writeln('"$date","$type",$amount,"$cat","$poc","$labels","$note"');
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/money_tracker_export_${DateTime.now().millisecondsSinceEpoch}.csv');
    file.writeAsStringSync(buffer.toString());
    return file;
  }

  Future<ImportResult> importFromFile(String filePath) async {
    if (filePath.endsWith('.xlsx')) {
      return _importFromXlsx(filePath);
    } else {
      return _importFromCsv(filePath);
    }
  }

  Future<ImportResult> _importFromCsv(String filePath) async {
    final content = File(filePath).readAsStringSync();
    final lines = content.split('\n');
    if (lines.isEmpty) return const ImportResult(count: 0, records: []);

    final existingCats = await _categoryRepo.watchAll().first;
    final catMap = {for (var c in existingCats) c.name.toLowerCase(): c};

    final existingPockets = await _pocketRepo.watchAll().first;
    final pocMap = {for (var p in existingPockets) p.name.toLowerCase(): p};

    final records = <TransactionModel>[];

    for (final line in lines.skip(1)) {
      if (line.trim().isEmpty) continue;
      final fields = _parseCsvLine(line.trim());
      if (fields.length < 3) continue;

      final dateStr = fields[0];
      final typeStr = fields[1].toLowerCase();
      final amountStr = fields[2];
      final catName = fields.length > 3 ? fields[3] : 'General';
      final pocName = fields.length > 4 ? fields[4] : 'Cash';
      final note = fields.length > 6 ? fields[6] : '';

      final date = _parseDate(dateStr);
      final type = typeStr == 'income' ? TransactionType.income : TransactionType.expense;
      final amount = double.tryParse(amountStr) ?? 0.0;

      // Ensure category
      var cat = catMap[catName.toLowerCase()];
      if (cat == null) {
        cat = CategoryModel(
          id: const Uuid().v4(),
          name: catName.isEmpty ? 'General' : catName,
          icon: 'category',
          color: 0xFF2196F3,
          type: type == TransactionType.income ? CategoryType.income : CategoryType.expense,
          isDefault: false,
          sortOrder: 99,
        );
        await _categoryRepo.add(cat);
        catMap[cat.name.toLowerCase()] = cat;
      }

      // Ensure pocket
      var poc = pocMap[pocName.toLowerCase()];
      if (poc == null) {
        poc = PocketModel(
          id: const Uuid().v4(),
          name: pocName.isEmpty ? 'Cash' : pocName,
          type: PocketType.cash,
          balance: 0.0,
          color: 0xFF4CAF50,
          icon: 'wallet',
          isDefault: false,
        );
        await _pocketRepo.add(poc);
        pocMap[poc.name.toLowerCase()] = poc;
      }

      records.add(TransactionModel(
        id: const Uuid().v4(),
        type: type,
        amount: amount,
        date: date,
        categoryId: cat.id,
        pocketId: poc.id,
        labelIds: [],
        note: note.isEmpty ? null : note,
        createdAt: DateTime.now(),
      ));
    }

    return ImportResult(count: records.length, records: records);
  }

  Future<ImportResult> _importFromXlsx(String filePath) async {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    if (excel.tables.isEmpty) return const ImportResult(count: 0, records: []);

    final table = excel.tables[excel.tables.keys.first];
    if (table == null || table.rows.length <= 1) return const ImportResult(count: 0, records: []);

    final existingCats = await _categoryRepo.watchAll().first;
    final catMap = {for (var c in existingCats) c.name.toLowerCase(): c};

    final existingPockets = await _pocketRepo.watchAll().first;
    final pocMap = {for (var p in existingPockets) p.name.toLowerCase(): p};

    final records = <TransactionModel>[];

    for (final row in table.rows.skip(1)) {
      if (row.isEmpty) continue;
      final dateStr = _cellToString(row.length > 0 ? row[0] : null);
      final typeStr = _cellToString(row.length > 1 ? row[1] : null).toLowerCase();
      final amountStr = _cellToString(row.length > 2 ? row[2] : null);
      final catName = _cellToString(row.length > 3 ? row[3] : null);
      final pocName = _cellToString(row.length > 4 ? row[4] : null);
      final note = _cellToString(row.length > 6 ? row[6] : null);

      if (amountStr.isEmpty) continue;

      final date = _parseDate(dateStr);
      final type = typeStr == 'income' ? TransactionType.income : TransactionType.expense;
      final amount = double.tryParse(amountStr) ?? 0.0;

      // Ensure category
      final lookupCat = catName.isEmpty ? 'General' : catName;
      var cat = catMap[lookupCat.toLowerCase()];
      if (cat == null) {
        cat = CategoryModel(
          id: const Uuid().v4(),
          name: lookupCat,
          icon: 'category',
          color: 0xFF2196F3,
          type: type == TransactionType.income ? CategoryType.income : CategoryType.expense,
          isDefault: false,
          sortOrder: 99,
        );
        await _categoryRepo.add(cat);
        catMap[cat.name.toLowerCase()] = cat;
      }

      // Ensure pocket
      final lookupPoc = pocName.isEmpty ? 'Cash' : pocName;
      var poc = pocMap[lookupPoc.toLowerCase()];
      if (poc == null) {
        poc = PocketModel(
          id: const Uuid().v4(),
          name: lookupPoc,
          type: PocketType.cash,
          balance: 0.0,
          color: 0xFF4CAF50,
          icon: 'wallet',
          isDefault: false,
        );
        await _pocketRepo.add(poc);
        pocMap[poc.name.toLowerCase()] = poc;
      }

      records.add(TransactionModel(
        id: const Uuid().v4(),
        type: type,
        amount: amount,
        date: date,
        categoryId: cat.id,
        pocketId: poc.id,
        labelIds: [],
        note: note.isEmpty ? null : note,
        createdAt: DateTime.now(),
      ));
    }

    return ImportResult(count: records.length, records: records);
  }

  Future<void> commitImport(List<TransactionModel> records) async {
    for (final tx in records) {
      await _transactionRepo.add(tx);
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('d MMM yyyy', 'id_ID').parse(dateStr);
    } catch (_) {
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return DateTime.now();
      }
    }
  }

  String _cellToString(Data? cell) {
    if (cell == null) return '';
    final val = cell.value;
    if (val == null) return '';
    if (val is TextCellValue) return val.value.text ?? '';
    if (val is DoubleCellValue) return val.value.toString();
    if (val is IntCellValue) return val.value.toString();
    return val.toString();
  }

  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    var current = StringBuffer();
    bool inQuotes = false;
    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          current.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(current.toString());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }
    result.add(current.toString());
    return result;
  }
}
