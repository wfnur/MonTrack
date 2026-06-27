import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../domain/providers/analytics_providers.dart';
import '../../../../domain/providers/category_providers.dart';

class PieChartCard extends ConsumerStatefulWidget {
  final TransactionType type;
  final DateTimeRange range;

  const PieChartCard({
    super.key,
    required this.type,
    required this.range,
  });

  @override
  ConsumerState<PieChartCard> createState() => _PieChartCardState();
}

class _PieChartCardState extends ConsumerState<PieChartCard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final totalsAsync = ref.watch(categoryTotalsProvider(widget.type, widget.range));
    final categoriesAsync = ref.watch(categoryListProvider());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.type == TransactionType.income ? "Income" : "Expense"} by Category',
            style: AppTextStyles.title.copyWith(
              color: context.colorTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          totalsAsync.when(
            data: (totals) {
              if (totals.isEmpty) {
                return _buildNoData();
              }

              final categories = categoriesAsync.value ?? [];
              final totalSum = totals.fold(0.0, (sum, item) => sum + item.total);

              if (totalSum == 0) {
                return _buildNoData();
              }

              return Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 3,
                        centerSpaceRadius: 45,
                        sections: List.generate(totals.length, (i) {
                          final isTouched = i == touchedIndex;
                          final fontSize = isTouched ? 16.0 : 12.0;
                          final radius = isTouched ? 58.0 : 48.0;
                          final item = totals[i];
                          final cat = _findCategory(categories, item.categoryId);
                          final percentage = (item.total / totalSum) * 100;

                          return PieChartSectionData(
                            color: Color(cat.color),
                            value: item.total,
                            title: percentage >= 5 ? '${percentage.toStringAsFixed(0)}%' : '',
                            radius: radius,
                            titleStyle: AppTextStyles.caption.copyWith(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Legend
                  Column(
                    children: List.generate(totals.length, (i) {
                      final item = totals[i];
                      final cat = _findCategory(categories, item.categoryId);
                      final percentage = (item.total / totalSum) * 100;
                      final isTouched = i == touchedIndex;

                      return GestureDetector(
                        onTap: () => setState(() => touchedIndex = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isTouched ? context.colorPrimarySurface : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Color(cat.color),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  cat.name,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: isTouched ? FontWeight.w700 : FontWeight.w500,
                                    color: context.colorTextPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: AppTextStyles.caption.copyWith(
                                  color: context.colorTextSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                CurrencyFormatter.formatCompact(item.total),
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: context.colorTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
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

  CategoryModel _findCategory(List<CategoryModel> categories, String id) {
    return categories.firstWhere(
      (c) => c.id == id,
      orElse: () => CategoryModel(
        id: id,
        name: 'Other',
        icon: 'help',
        color: context.colorTextSecondary.toARGB32(),
        type: widget.type == TransactionType.income ? CategoryType.income : CategoryType.expense,
        isDefault: false,
        sortOrder: 999,
      ),
    );
  }

  Widget _buildNoData() {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pie_chart_outline_rounded, size: 48, color: context.colorTextSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'No data available for this range',
            style: AppTextStyles.caption.copyWith(color: context.colorTextSecondary),
          ),
        ],
      ),
    );
  }
}
