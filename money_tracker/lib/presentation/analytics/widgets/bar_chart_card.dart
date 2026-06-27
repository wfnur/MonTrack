import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../domain/providers/analytics_providers.dart';

class BarChartCard extends ConsumerWidget {
  final int year;
  final String? pocketId;

  const BarChartCard({
    super.key,
    required this.year,
    this.pocketId,
  });

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyAsync = ref.watch(monthlyTotalsProvider(year, pocketId));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Overview ($year)',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  _buildLegendDot('Income', AppColors.income),
                  const SizedBox(width: 12),
                  _buildLegendDot('Expense', AppColors.expense),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          monthlyAsync.when(
            data: (totals) {
              final maxY = totals.fold(0.0, (maxVal, item) {
                final currentMax = item.income > item.expense ? item.income : item.expense;
                return currentMax > maxVal ? currentMax : maxVal;
              });

              if (maxY == 0) {
                return _buildNoData();
              }

              return SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    maxY: maxY * 1.15, // Add headroom
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: AppColors.border.withValues(alpha: 0.5),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 48,
                          getTitlesWidget: (value, meta) {
                            if (value == 0 || value >= maxY * 1.15) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Text(
                                CurrencyFormatter.formatCompact(value),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= _months.length) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _months[idx],
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final item = totals[group.x];
                          final isIncome = rodIndex == 0;
                          final label = isIncome ? 'Income' : 'Expense';
                          final val = isIncome ? item.income : item.expense;
                          return BarTooltipItem(
                            '${_months[group.x]} - $label\n',
                            AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                            children: [
                              TextSpan(
                                text: CurrencyFormatter.format(val),
                                style: AppTextStyles.caption.copyWith(
                                  color: isIncome ? AppColors.income : AppColors.expense,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    barGroups: List.generate(totals.length, (i) {
                      final item = totals[i];
                      return BarChartGroupData(
                        x: i,
                        barsSpace: 4,
                        barRods: [
                          BarChartRodData(
                            toY: item.income,
                            color: AppColors.income,
                            width: 6,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                          ),
                          BarChartRodData(
                            toY: item.expense,
                            color: AppColors.expense,
                            width: 6,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => _buildNoData(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildNoData() {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'No transaction data for $year',
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
