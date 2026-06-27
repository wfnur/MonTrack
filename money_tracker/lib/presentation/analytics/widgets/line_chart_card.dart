import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../domain/providers/analytics_providers.dart';

class LineChartCard extends ConsumerWidget {
  final DateTimeRange range;
  final String? pocketId;

  const LineChartCard({
    super.key,
    required this.range,
    this.pocketId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailyTotalsProvider(range, pocketId));

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
                'Cash Flow Trend',
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
          dailyAsync.when(
            data: (totals) {
              final maxY = totals.fold(0.0, (maxVal, item) {
                final currentMax = item.income > item.expense ? item.income : item.expense;
                return currentMax > maxVal ? currentMax : maxVal;
              });

              if (maxY == 0) {
                return _buildNoData();
              }

              final incomeSpots = <FlSpot>[];
              final expenseSpots = <FlSpot>[];

              for (int i = 0; i < totals.length; i++) {
                incomeSpots.add(FlSpot(i.toDouble(), totals[i].income));
                expenseSpots.add(FlSpot(i.toDouble(), totals[i].expense));
              }

              // Determine interval for bottom titles to avoid overlap
              final step = (totals.length / 5).ceil().clamp(1, 100);

              return SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    maxY: maxY * 1.15,
                    minY: 0,
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
                          interval: step.toDouble(),
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= totals.length) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                DateFormat('d MMM').format(totals[idx].date),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final idx = spot.x.toInt();
                            final item = totals[idx];
                            final isIncome = spot.barIndex == 0;
                            final val = isIncome ? item.income : item.expense;
                            final label = isIncome ? 'Income' : 'Expense';

                            return LineTooltipItem(
                              '${DateFormat('MMM d').format(item.date)}\n$label: ${CurrencyFormatter.format(val)}',
                              AppTextStyles.caption.copyWith(
                                color: isIncome ? AppColors.income : AppColors.expense,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: incomeSpots,
                        isCurved: true,
                        color: AppColors.income,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: totals.length <= 15, // Show dots only if not too dense
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.income.withValues(alpha: 0.1),
                        ),
                      ),
                      LineChartBarData(
                        spots: expenseSpots,
                        isCurved: true,
                        color: AppColors.expense,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: totals.length <= 15,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.expense.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
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
          Icon(Icons.show_chart_rounded, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'No daily flow data available',
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
