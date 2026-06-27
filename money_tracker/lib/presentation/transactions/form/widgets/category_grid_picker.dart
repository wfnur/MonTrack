import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/animation_utils.dart';
import '../../../../data/models/category_model.dart';
import '../../../../domain/providers/category_providers.dart';

class CategoryGridPicker extends ConsumerStatefulWidget {
  final CategoryType filterType;
  final String? selectedCategoryId;

  const CategoryGridPicker({
    super.key,
    required this.filterType,
    this.selectedCategoryId,
  });

  static Future<CategoryModel?> show(
    BuildContext context, {
    required CategoryType filterType,
    String? selectedCategoryId,
  }) {
    return showModalBottomSheet<CategoryModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CategoryGridPicker(
        filterType: filterType,
        selectedCategoryId: selectedCategoryId,
      ),
    );
  }

  @override
  ConsumerState<CategoryGridPicker> createState() => _CategoryGridPickerState();
}

class _CategoryGridPickerState extends ConsumerState<CategoryGridPicker> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final typeName = widget.filterType == CategoryType.both
        ? null
        : widget.filterType.name;
    final categoriesAsync = ref.watch(categoryListProvider(type: typeName));

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Category',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              // Search
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
                onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              ),
              const SizedBox(height: 16),
              // Grid
              Expanded(
                child: categoriesAsync.when(
                  data: (categories) {
                    final filtered = _searchQuery.isEmpty
                        ? categories
                        : categories
                            .where((c) =>
                                c.name.toLowerCase().contains(_searchQuery))
                            .toList();

                    return GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final cat = filtered[index];
                        final isSelected =
                            cat.id == widget.selectedCategoryId;
                        return StaggeredEntrance(
                          index: index,
                          itemDelay: const Duration(milliseconds: 30),
                          child: _buildCategoryItem(cat, isSelected),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(
                    child: Text('Error loading categories'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(CategoryModel category, bool isSelected) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, category),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Color(category.color).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: Color(category.color), width: 2.5)
                  : null,
            ),
            child: Icon(
              _categoryIcon(category.icon),
              color: Color(category.color),
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            style: AppTextStyles.caption.copyWith(
              fontSize: 10,
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
}
