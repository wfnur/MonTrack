import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/pocket_model.dart';

class PocketSwitcher extends StatelessWidget {
  final List<PocketModel> pockets;
  final String? selectedPocketId;
  final double totalBalance;
  final ValueChanged<String?> onPocketSelected;

  const PocketSwitcher({
    super.key,
    required this.pockets,
    required this.selectedPocketId,
    required this.totalBalance,
    required this.onPocketSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: pockets.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCard(
              context,
              label: 'All',
              balance: totalBalance,
              color: AppColors.primary,
              icon: Icons.account_balance_wallet_rounded,
              isSelected: selectedPocketId == null,
              onTap: () => onPocketSelected(null),
            );
          }
          final pocket = pockets[index - 1];
          return _buildCard(
            context,
            label: pocket.name,
            balance: pocket.balance,
            color: Color(pocket.color),
            icon: _iconFromString(pocket.icon),
            isSelected: selectedPocketId == pocket.id,
            onTap: () => onPocketSelected(pocket.id),
          );
        },
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String label,
    required double balance,
    required Color color,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              CurrencyFormatter.formatCompact(balance),
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFromString(String iconName) {
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
