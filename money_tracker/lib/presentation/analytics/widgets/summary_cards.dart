import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';

class SummaryCards extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  const SummaryCards({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final netBalance = totalIncome - totalExpense;

    return Row(
      children: [
        Expanded(
          child: _buildCard(
            context: context,
            label: 'Income',
            amount: totalIncome,
            color: AppColors.income,
            icon: Icons.arrow_downward_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildCard(
            context: context,
            label: 'Expense',
            amount: totalExpense,
            color: AppColors.expense,
            icon: Icons.arrow_upward_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildCard(
            context: context,
            label: 'Net Balance',
            amount: netBalance,
            color: context.colorPrimary,
            icon: Icons.account_balance_wallet_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: context.colorTextSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              CurrencyFormatter.formatCompact(amount),
              style: AppTextStyles.title.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
