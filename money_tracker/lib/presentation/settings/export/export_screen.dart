import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../domain/providers/category_providers.dart';
import '../../../../domain/providers/export_providers.dart';
import '../../../../domain/providers/pocket_providers.dart';
import '../../../../domain/providers/transaction_providers.dart';

enum ExportFormat { xlsx, csv }
enum ExportRangeOption { thisMonth, last3Months, thisYear, allTime, custom }

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  ExportFormat _format = ExportFormat.xlsx;
  ExportRangeOption _rangeOption = ExportRangeOption.allTime;
  DateTimeRange? _customRange;
  String? _selectedPocketId; // null = All Pockets
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    final pocketsAsync = ref.watch(pocketListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Export & Import',
          style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. FORMAT selector
            Text(
              'EXPORT FORMAT',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildFormatChoice('Excel (.xlsx)', ExportFormat.xlsx, Icons.table_chart_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFormatChoice('CSV (.csv)', ExportFormat.csv, Icons.text_snippet_rounded),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. DATE RANGE selector
            Text(
              'DATE RANGE',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ExportRangeOption>(
                  value: _rangeOption,
                  isExpanded: true,
                  dropdownColor: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  items: const [
                    DropdownMenuItem(value: ExportRangeOption.allTime, child: Text('All Time')),
                    DropdownMenuItem(value: ExportRangeOption.thisMonth, child: Text('This Month')),
                    DropdownMenuItem(value: ExportRangeOption.last3Months, child: Text('Last 3 Months')),
                    DropdownMenuItem(value: ExportRangeOption.thisYear, child: Text('This Year')),
                    DropdownMenuItem(value: ExportRangeOption.custom, child: Text('Custom Range...')),
                  ],
                  onChanged: (val) async {
                    if (val == null) return;
                    if (val == ExportRangeOption.custom) {
                      final now = DateTime.now();
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: _customRange ?? DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
                      );
                      if (picked != null) {
                        setState(() {
                          _customRange = picked;
                          _rangeOption = ExportRangeOption.custom;
                        });
                      }
                    } else {
                      setState(() => _rangeOption = val);
                    }
                  },
                ),
              ),
            ),
            if (_rangeOption == ExportRangeOption.custom && _customRange != null) ...[
              const SizedBox(height: 8),
              Text(
                'Selected: ${DateFormat('d MMM yyyy').format(_customRange!.start)} - ${DateFormat('d MMM yyyy').format(_customRange!.end)}',
                style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 24),

            // 3. POCKET SCOPE selector
            Text(
              'POCKET SCOPE',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _selectedPocketId,
                  isExpanded: true,
                  dropdownColor: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Pockets')),
                    ...?pocketsAsync.value?.map((p) => DropdownMenuItem(value: p.id, child: Text('${p.name} (${p.type.name.toUpperCase()})'))),
                  ],
                  onChanged: (val) => setState(() => _selectedPocketId = val),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 4. EXPORT button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: _isExporting ? null : _onExport,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: _isExporting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.share_rounded, color: Colors.white),
                label: Text(
                  _isExporting ? 'Generating...' : 'Export & Share File',
                  style: AppTextStyles.title.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 5. IMPORT section
            const Divider(color: AppColors.border),
            const SizedBox(height: 24),
            Text(
              'RESTORE DATA',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.expense,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Import records from CSV or XLSX files. New categories or wallets found in the document will be created automatically.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: _isImporting ? null : _onImport,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: _isImporting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.file_upload_outlined),
                label: Text(
                  _isImporting ? 'Reading file...' : 'Import from File',
                  style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatChoice(String label, ExportFormat format, IconData icon) {
    final isSelected = _format == format;
    return GestureDetector(
      onTap: () => setState(() => _format = format),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTimeRange? _getDateTimeRange() {
    final now = DateTime.now();
    switch (_rangeOption) {
      case ExportRangeOption.thisMonth:
        return DateTimeRange(start: DateTime(now.year, now.month, 1), end: DateTime(now.year, now.month + 1, 0, 23, 59, 59));
      case ExportRangeOption.last3Months:
        return DateTimeRange(start: DateTime(now.year, now.month - 2, 1), end: DateTime(now.year, now.month + 1, 0, 23, 59, 59));
      case ExportRangeOption.thisYear:
        return DateTimeRange(start: DateTime(now.year, 1, 1), end: DateTime(now.year, 12, 31, 23, 59, 59));
      case ExportRangeOption.allTime:
        return null;
      case ExportRangeOption.custom:
        return _customRange ?? DateTimeRange(start: DateTime(now.year, now.month, 1), end: DateTime(now.year, now.month + 1, 0, 23, 59, 59));
    }
  }

  Future<void> _onExport() async {
    setState(() => _isExporting = true);
    try {
      final transactions = await ref.read(transactionRepositoryProvider).getAll(
            pocketId: _selectedPocketId,
            range: _getDateTimeRange(),
          );

      if (transactions.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No transactions found matching criteria.')),
        );
        setState(() => _isExporting = false);
        return;
      }

      final cats = await ref.read(categoryListProvider().future);
      final catMap = {for (var c in cats) c.id: c};

      final pocs = await ref.read(pocketListProvider.future);
      final pocMap = {for (var p in pocs) p.id: p};

      final repo = ref.read(exportRepositoryProvider);
      final file = _format == ExportFormat.xlsx
          ? await repo.exportToXlsx(transactions, catMap, pocMap)
          : await repo.exportToCsv(transactions, catMap, pocMap);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Money Tracker Export (${transactions.length} records)',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _onImport() async {
    setState(() => _isImporting = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final repo = ref.read(exportRepositoryProvider);
        final importResult = await repo.importFromFile(filePath);

        if (!mounted) return;

        if (importResult.count == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid transaction rows found in document.')),
          );
          return;
        }

        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Ready to Import'),
            content: Text(
              'Found ${importResult.count} transactions in document.\n\nProceeding will add all these records to your active database.',
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Import Now', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );

        if (confirm == true && mounted) {
          await repo.commitImport(importResult.records);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Successfully imported ${importResult.count} transactions!')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }
}
