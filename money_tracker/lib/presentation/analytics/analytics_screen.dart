import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/transaction_model.dart';
import '../../../domain/providers/analytics_providers.dart';
import 'widgets/summary_cards.dart';
import 'widgets/pie_chart_card.dart';
import 'widgets/bar_chart_card.dart';
import 'widgets/line_chart_card.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  TransactionType _selectedType = TransactionType.expense;
  String? _selectedPocketId; // null means All Pockets

  @override
  Widget build(BuildContext context) {
    final currentPreset = ref.watch(analyticsDateRangeProvider);
    final dateRangeNotifier = ref.watch(analyticsDateRangeProvider.notifier);
    final activeRange = dateRangeNotifier.range;

    final dailyTotalsAsync = ref.watch(dailyTotalsProvider(activeRange, _selectedPocketId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Analytics',
          style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Date range filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetChip('This Month', AnalyticsRangePreset.thisMonth, currentPreset),
                  const SizedBox(width: 8),
                  _buildPresetChip('Last 3 Months', AnalyticsRangePreset.last3Months, currentPreset),
                  const SizedBox(width: 8),
                  _buildPresetChip('This Year', AnalyticsRangePreset.thisYear, currentPreset),
                  const SizedBox(width: 8),
                  _buildCustomChip(currentPreset),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Income/Expense toggle
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text('Expense'),
                    icon: Icon(Icons.arrow_upward_rounded),
                  ),
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text('Income'),
                    icon: Icon(Icons.arrow_downward_rounded),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (newSet) {
                  setState(() => _selectedType = newSet.first);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return _selectedType == TransactionType.income
                          ? AppColors.income.withValues(alpha: 0.15)
                          : AppColors.expense.withValues(alpha: 0.15);
                    }
                    return AppColors.surface;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return _selectedType == TransactionType.income
                          ? AppColors.income
                          : AppColors.expense;
                    }
                    return AppColors.textSecondary;
                  }),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Summary cards row
            dailyTotalsAsync.when(
              data: (dailyList) {
                final totalInc = dailyList.fold(0.0, (sum, item) => sum + item.income);
                final totalExp = dailyList.fold(0.0, (sum, item) => sum + item.expense);
                return SummaryCards(totalIncome: totalInc, totalExpense: totalExp);
              },
              loading: () => const SummaryCards(totalIncome: 0, totalExpense: 0),
              error: (_, __) => const SummaryCards(totalIncome: 0, totalExpense: 0),
            ),
            const SizedBox(height: 24),

            // 4. PieChartCard
            PieChartCard(
              type: _selectedType,
              range: activeRange,
            ),
            const SizedBox(height: 24),

            // 5. BarChartCard
            BarChartCard(
              year: activeRange.start.year,
              pocketId: _selectedPocketId,
            ),
            const SizedBox(height: 24),

            // 6. LineChartCard
            LineChartCard(
              range: activeRange,
              pocketId: _selectedPocketId,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, AnalyticsRangePreset preset, AnalyticsRangePreset current) {
    final isSelected = preset == current;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(analyticsDateRangeProvider.notifier).set(preset);
      },
      selectedColor: AppColors.primarySurface,
      checkmarkColor: AppColors.primary,
      labelStyle: AppTextStyles.caption.copyWith(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
    );
  }

  Widget _buildCustomChip(AnalyticsRangePreset current) {
    final isSelected = current == AnalyticsRangePreset.custom;
    return FilterChip(
      label: const Text('Custom'),
      selected: isSelected,
      onSelected: (_) async {
        final now = DateTime.now();
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          initialDateRange: DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          ),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primary,
                  surface: AppColors.surface,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null && mounted) {
          ref.read(analyticsDateRangeProvider.notifier).setCustom(picked);
        }
      },
      selectedColor: AppColors.primarySurface,
      checkmarkColor: AppColors.primary,
      labelStyle: AppTextStyles.caption.copyWith(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
    );
  }
}
