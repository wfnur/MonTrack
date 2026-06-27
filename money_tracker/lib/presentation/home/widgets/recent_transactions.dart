import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/category_model.dart';
import '../../common/empty_state.dart';
import '../../common/shimmer_list.dart';
import '../../transactions/form/transaction_form_sheet.dart';

class RecentTransactions extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Map<String, CategoryModel> categoryMap;
  final bool isLoading;

  const RecentTransactions({
    super.key,
    required this.transactions,
    required this.categoryMap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ShimmerList(itemCount: 5);
    }

    if (transactions.isEmpty) {
      return EmptyState(
        icon: '💸',
        title: 'No transactions yet',
        subtitle: 'Tap + to add your first income or expense',
        action: ElevatedButton(
          onPressed: () => TransactionFormSheet.show(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorPrimary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Add Transaction'),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final category = categoryMap[tx.categoryId];
        return _buildTransactionTile(context, tx, category);
      },
    );
  }

  Widget _buildTransactionTile(
    BuildContext context,
    TransactionModel tx,
    CategoryModel? category,
  ) {
    final isIncome = tx.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.income : AppColors.expense;
    final prefix = isIncome ? '+' : '-';

    return InkWell(
      onTap: () => context.push('/transactions/${tx.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            // Category icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: category != null
                    ? Color(category.color).withValues(alpha: 0.12)
                    : AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _categoryIcon(category?.icon),
                color: category != null
                    ? Color(category.color)
                    : AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // Name + note
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category?.name ?? 'Unknown',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (tx.note != null && tx.note!.isNotEmpty)
                    Text(
                      tx.note!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Date + amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$prefix${CurrencyFormatter.formatCompact(tx.amount)}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: amountColor,
                  ),
                ),
                Text(
                  DateFormatter.formatShort(tx.date),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  IconData _categoryIcon(String? iconName) {
    switch (iconName) {
      // Income
      case 'ti-briefcase':
        return Icons.work_outline_rounded;
      case 'ti-laptop':
        return Icons.laptop_mac_rounded;
      case 'ti-trending-up':
        return Icons.trending_up_rounded;
      case 'ti-gift':
        return Icons.card_giftcard_rounded;
      case 'ti-plus-circle':
        return Icons.add_circle_outline_rounded;
      // Expense
      case 'ti-tools-kitchen-2':
        return Icons.restaurant_rounded;
      case 'ti-car':
        return Icons.directions_car_rounded;
      case 'ti-shopping-bag':
        return Icons.shopping_bag_outlined;
      case 'ti-file-invoice':
        return Icons.receipt_outlined;
      case 'ti-heart-rate-monitor':
        return Icons.monitor_heart_outlined;
      case 'ti-device-gamepad-2':
        return Icons.sports_esports_outlined;
      case 'ti-school':
        return Icons.school_outlined;
      case 'ti-dots-circle':
        return Icons.more_horiz_rounded;
      default:
        return Icons.category_outlined;
    }
  }
}
