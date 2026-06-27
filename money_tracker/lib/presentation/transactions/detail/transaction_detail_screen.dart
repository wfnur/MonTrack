import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/transaction_model.dart';
import '../../../domain/providers/category_providers.dart';
import '../../../domain/providers/label_providers.dart';
import '../../../domain/providers/pocket_providers.dart';
import '../../../domain/providers/transaction_providers.dart';
import '../form/transaction_form_sheet.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String id;

  const TransactionDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionByIdProvider(id));

    return Scaffold(
      backgroundColor: context.colorBackground,
      appBar: AppBar(
        backgroundColor: context.colorBackground,
        title: Text(
          'Transaction Detail',
          style: AppTextStyles.title.copyWith(color: context.colorTextPrimary),
        ),
        actions: transactionAsync.valueOrNull != null
            ? [
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () => _openEditSheet(context, transactionAsync.value!),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_rounded, color: AppColors.expense),
                  onPressed: () => _confirmDelete(context, ref, id),
                ),
              ]
            : null,
      ),
      body: transactionAsync.when(
        data: (tx) {
          if (tx == null) {
            return _buildNotFound(context);
          }
          return _buildContent(context, ref, tx);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error loading transaction: $error',
            style: AppTextStyles.body.copyWith(color: AppColors.expense),
          ),
        ),
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: context.colorTextSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Transaction not found',
            style: AppTextStyles.title.copyWith(color: context.colorTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, TransactionModel tx) {
    final isIncome = tx.type == TransactionType.income;
    final accentColor = isIncome ? AppColors.income : AppColors.expense;
    final prefix = isIncome ? '+' : '-';

    // Watch references
    final categoriesAsync = ref.watch(categoryListProvider());
    final pocketsAsync = ref.watch(pocketListProvider);
    final labelsAsync = ref.watch(labelListProvider);

    final category = categoriesAsync.valueOrNull
        ?.where((c) => c.id == tx.categoryId)
        .firstOrNull;
    final pocket = pocketsAsync.valueOrNull
        ?.where((p) => p.id == tx.pocketId)
        .firstOrNull;
    final matchingLabels = labelsAsync.valueOrNull
            ?.where((l) => tx.labelIds.contains(l.id))
            .toList() ??
        [];

    final categoryName = category?.name ?? 'Unknown Category';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Main Info Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colorSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: context.colorBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge + Amount Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tx.type.name.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '$prefix${CurrencyFormatter.format(tx.amount)}',
                        style: AppTextStyles.display.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Divider(color: context.colorBorder, height: 1),
                ),

                // Info Rows
                _buildInfoRow(
                  context: context,
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  content: Text(
                    DateFormatter.format(tx.date),
                    style: AppTextStyles.body.copyWith(
                      color: context.colorTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                _buildInfoRow(
                  context: context,
                  icon: Icons.category_outlined,
                  label: 'Category',
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (category != null) ...[
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(category.color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            _categoryIcon(category.icon),
                            size: 14,
                            color: Color(category.color),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        categoryName,
                        style: AppTextStyles.body.copyWith(
                          color: context.colorTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                _buildInfoRow(
                  context: context,
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Pocket',
                  content: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (pocket != null) ...[
                        Icon(
                          _pocketIcon(pocket.icon),
                          size: 18,
                          color: Color(pocket.color),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        pocket?.name ?? 'Unknown Pocket',
                        style: AppTextStyles.body.copyWith(
                          color: context.colorTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                _buildInfoRow(
                  context: context,
                  icon: Icons.label_outline_rounded,
                  label: 'Labels',
                  content: matchingLabels.isNotEmpty
                      ? Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: matchingLabels.map((l) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(l.color).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                l.name,
                                style: AppTextStyles.caption.copyWith(
                                  color: Color(l.color),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : Text(
                          'None',
                          style: AppTextStyles.body.copyWith(
                            color: context.colorTextSecondary,
                          ),
                        ),
                ),
                const SizedBox(height: 18),

                _buildInfoRow(
                  context: context,
                  icon: Icons.notes_rounded,
                  label: 'Note',
                  content: Text(
                    tx.note != null && tx.note!.isNotEmpty
                        ? tx.note!
                        : 'No note',
                    style: AppTextStyles.body.copyWith(
                      color: tx.note != null && tx.note!.isNotEmpty
                          ? context.colorTextPrimary
                          : context.colorTextSecondary,
                      fontStyle: tx.note != null && tx.note!.isNotEmpty
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                _buildInfoRow(
                  context: context,
                  icon: Icons.access_time_rounded,
                  label: 'Created at',
                  content: Text(
                    '${DateFormatter.formatShort(tx.createdAt)} ${_formatTime(tx.createdAt)}',
                    style: AppTextStyles.caption.copyWith(
                      color: context.colorTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Share Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _shareTransaction(tx, categoryName),
              icon: const Icon(Icons.share_rounded, size: 20),
              label: Text(
                'Share Summary',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorTextPrimary,
                side: BorderSide(color: context.colorBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Widget content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: context.colorTextSecondary),
        const SizedBox(width: 12),
        SizedBox(
          width: 85,
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(color: context.colorTextSecondary),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: content,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _shareTransaction(TransactionModel tx, String categoryName) {
    final shareText = "${tx.type.name.toUpperCase()} — ${CurrencyFormatter.format(tx.amount)}\n"
        "Date: ${DateFormatter.format(tx.date)}\n"
        "Category: $categoryName\n"
        "${tx.note != null && tx.note!.isNotEmpty ? 'Note: ${tx.note}' : ''}";
    Share.share(shareText.trim());
  }

  void _openEditSheet(BuildContext context, TransactionModel tx) {
    TransactionFormSheet.show(context, initialData: tx);
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String txId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.body.copyWith(color: context.colorTextSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(transactionRepositoryProvider).delete(txId);
              if (context.mounted) {
                context.pop();
              }
            },
            child: Text(
              'Delete',
              style: AppTextStyles.body.copyWith(
                color: AppColors.expense,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String iconName) {
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

  IconData _pocketIcon(String iconName) {
    switch (iconName) {
      case 'ti-wallet':
        return Icons.account_balance_wallet_outlined;
      case 'ti-building-bank':
        return Icons.account_balance_outlined;
      case 'ti-device-mobile':
        return Icons.phone_android_outlined;
      case 'ti-credit-card':
        return Icons.credit_card_outlined;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }
}
