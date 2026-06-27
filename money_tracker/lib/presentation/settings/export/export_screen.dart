import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Export & Import',
          style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.import_export_rounded,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Export & Import Data',
              style: AppTextStyles.title.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Backup or restore your transactions (Coming Soon)',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
