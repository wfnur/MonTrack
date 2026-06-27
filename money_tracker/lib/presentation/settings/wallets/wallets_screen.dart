import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/animation_utils.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/pocket_model.dart';
import '../../../../domain/providers/pocket_providers.dart';
import '../../../../domain/providers/transaction_providers.dart';
import 'wallet_form_sheet.dart';

class WalletsScreen extends ConsumerWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pocketsAsync = ref.watch(pocketListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Wallets',
          style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => WalletFormSheet.show(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Add Wallet',
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: pocketsAsync.when(
        data: (pockets) {
          if (pockets.isEmpty) {
            return _buildEmptyState(context);
          }

          final totalBalance = pockets.fold<double>(
            0.0,
            (sum, pocket) => sum + pocket.balance,
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            children: [
              // Total Balance Header Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Net Worth',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      CurrencyFormatter.format(totalBalance),
                      style: AppTextStyles.display.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${pockets.length} Active Wallet${pockets.length == 1 ? '' : 's'}',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your Wallets',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),

              // Pockets List
              ...pockets.map((pocket) => _PocketCard(pocket: pocket)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            'Error loading wallets: $err',
            style: AppTextStyles.body.copyWith(color: AppColors.expense),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No wallets found',
            style: AppTextStyles.title.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first wallet to track accounts',
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => WalletFormSheet.show(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Wallet'),
          ),
        ],
      ),
    );
  }
}

class _PocketCard extends ConsumerWidget {
  final PocketModel pocket;

  const _PocketCard({required this.pocket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(pocket.color);
    final subtitle = _buildSubtitle();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => WalletFormSheet.show(context, initialData: pocket),
          onLongPress: () => _showMenu(context, ref),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Solid Left Border Accent Bar
                Container(
                  width: 6,
                  color: color,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        // Icon Circle
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _pocketIcon(pocket.icon),
                            color: color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Name & Type Badge
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      pocket.name,
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (pocket.isDefault) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'DEFAULT',
                                        style: AppTextStyles.caption.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 9,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      pocket.type.name.toUpperCase(),
                                      style: AppTextStyles.caption.copyWith(
                                        color: color,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  if (subtitle.isNotEmpty) ...[
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        subtitle,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Balance & Menu
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              CurrencyFormatter.format(pocket.balance),
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Balance',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),

                        // Trailing Menu Button
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onSelected: (action) => _handleAction(context, ref, action),
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 18),
                                  SizedBox(width: 10),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            if (!pocket.isDefault)
                              const PopupMenuItem(
                                value: 'default',
                                child: Row(
                                  children: [
                                    Icon(Icons.star_outline_rounded, size: 18),
                                    SizedBox(width: 10),
                                    Text('Set as Default'),
                                  ],
                                ),
                              ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline_rounded, color: AppColors.expense, size: 18),
                                  SizedBox(width: 10),
                                  Text('Delete', style: TextStyle(color: AppColors.expense)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final inst = pocket.institution;
    final l4 = pocket.lastFour;
    if (inst != null && l4 != null) {
      return '$inst •••• $l4';
    } else if (inst != null) {
      return inst;
    } else if (l4 != null) {
      return '•••• $l4';
    }
    return '';
  }

  void _showMenu(BuildContext context, WidgetRef ref) {
    showAnimatedBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: AppColors.surface,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Wallet'),
              onTap: () {
                Navigator.pop(ctx);
                WalletFormSheet.show(context, initialData: pocket);
              },
            ),
            if (!pocket.isDefault)
              ListTile(
                leading: const Icon(Icons.star_outline_rounded),
                title: const Text('Set as Default'),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(pocketRepositoryProvider).setDefault(pocket.id);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: AppColors.expense),
              title: const Text('Delete Wallet', style: TextStyle(color: AppColors.expense)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        WalletFormSheet.show(context, initialData: pocket);
        break;
      case 'default':
        ref.read(pocketRepositoryProvider).setDefault(pocket.id);
        break;
      case 'delete':
        _confirmDelete(context, ref);
        break;
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final txList = await ref
        .read(transactionRepositoryProvider)
        .watchAll(pocketId: pocket.id)
        .first;
    final hasTx = txList.isNotEmpty;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Wallet?'),
        content: Text(
          hasTx
              ? 'This wallet contains ${txList.length} transaction(s). Deleting this wallet will permanently delete all associated transactions. Are you sure you want to proceed?'
              : 'Are you sure you want to delete "${pocket.name}"?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final repo = ref.read(pocketRepositoryProvider);
              await repo.delete(pocket.id);

              if (pocket.isDefault) {
                final remaining = await repo.getAll();
                if (remaining.isNotEmpty) {
                  await repo.setDefault(remaining.first.id);
                }
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
      case 'ti-cash':
        return Icons.money_outlined;
      case 'ti-coin':
        return Icons.monetization_on_outlined;
      case 'ti-piggy-bank':
        return Icons.savings_outlined;
      case 'ti-receipt':
        return Icons.receipt_long_outlined;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }
}
