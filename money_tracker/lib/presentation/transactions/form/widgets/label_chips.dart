import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../domain/providers/label_providers.dart';

class LabelChips extends ConsumerWidget {
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;

  const LabelChips({
    super.key,
    required this.selectedIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelsAsync = ref.watch(labelListProvider);

    return labelsAsync.when(
      data: (labels) {
        if (labels.isEmpty) {
          return Text(
            'No labels yet',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          );
        }
        return Wrap(
          spacing: 8,
          runSpacing: 6,
          children: labels.map((label) {
            final isSelected = selectedIds.contains(label.id);
            return FilterChip(
              label: Text(
                label.name,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                final updated = Set<String>.from(selectedIds);
                if (selected) {
                  updated.add(label.id);
                } else {
                  updated.remove(label.id);
                }
                onChanged(updated);
              },
              backgroundColor: Color(label.color).withValues(alpha: 0.1),
              selectedColor: Color(label.color),
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? Color(label.color)
                    : Color(label.color).withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              visualDensity: VisualDensity.compact,
            );
          }).toList(),
        );
      },
      loading: () => const SizedBox(
        height: 32,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => Text(
        'Error loading labels',
        style: AppTextStyles.caption.copyWith(color: AppColors.expense),
      ),
    );
  }
}
