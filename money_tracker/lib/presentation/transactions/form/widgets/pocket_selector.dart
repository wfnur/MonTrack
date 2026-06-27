import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/pocket_model.dart';

class PocketSelector extends StatelessWidget {
  final List<PocketModel> pockets;
  final String? selectedPocketId;
  final ValueChanged<String> onPocketSelected;

  const PocketSelector({
    super.key,
    required this.pockets,
    required this.selectedPocketId,
    required this.onPocketSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: pockets.length,
        itemBuilder: (context, index) {
          final pocket = pockets[index];
          final isSelected = pocket.id == selectedPocketId;
          return _buildCard(pocket, isSelected);
        },
      ),
    );
  }

  Widget _buildCard(PocketModel pocket, bool isSelected) {
    final color = Color(pocket.color);

    return GestureDetector(
      onTap: () => onPocketSelected(pocket.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _pocketIcon(pocket.icon),
              size: 16,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              pocket.name,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              CurrencyFormatter.formatCompact(pocket.balance),
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }
}
