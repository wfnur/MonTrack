import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../data/models/category_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final CategoryModel? category;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.category,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.income : AppColors.expense;
    final prefix = isIncome ? '+' : '-';

    return Slidable(
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => onEdit?.call(),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            label: 'Edit',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => _confirmDelete(context),
            backgroundColor: AppColors.expense,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Category icon circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: category != null
                      ? Color(category!.color).withValues(alpha: 0.12)
                      : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _categoryIcon(category?.icon),
                  color: category != null
                      ? Color(category!.color)
                      : AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category?.name ?? 'Unknown',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      transaction.note?.isNotEmpty == true
                          ? transaction.note!
                          : DateFormatter.format(transaction.date),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Amount + date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$prefix${CurrencyFormatter.formatCompact(transaction.amount)}',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: amountColor,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormatter.formatShort(transaction.date),
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
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete?.call();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.expense),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String? iconName) {
    switch (iconName) {
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
