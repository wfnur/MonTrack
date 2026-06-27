import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/animation_utils.dart';
import '../../../../data/models/category_model.dart';
import '../../../../domain/providers/category_providers.dart';

class CategoryFormSheet extends ConsumerStatefulWidget {
  final CategoryModel? initialData;

  const CategoryFormSheet({super.key, this.initialData});

  static Future<void> show(BuildContext context, {CategoryModel? initialData}) {
    return showAnimatedBottomSheet(
      context: context,
      builder: (_) => CategoryFormSheet(initialData: initialData),
    );
  }

  @override
  ConsumerState<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends ConsumerState<CategoryFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  late CategoryType _selectedType;
  late int _selectedColor;
  late String _selectedIcon;

  static const _presetColors = [
    0xFF4CAF50, // Green
    0xFF2196F3, // Blue
    0xFF9C27B0, // Purple
    0xFFE91E63, // Pink
    0xFFFF5722, // Deep Orange
    0xFFFF9800, // Orange
    0xFFFFC107, // Amber
    0xFF009688, // Teal
    0xFF00BCD4, // Cyan
    0xFF3F51B5, // Indigo
    0xFF607D8B, // Blue Grey
    0xFF795548, // Brown
  ];

  static const _categoryIcons = [
    ('ti-briefcase', 'Salary', Icons.work_outline_rounded),
    ('ti-laptop', 'Freelance', Icons.laptop_mac_rounded),
    ('ti-trending-up', 'Invest', Icons.trending_up_rounded),
    ('ti-gift', 'Gift', Icons.card_giftcard_rounded),
    ('ti-plus-circle', 'Other Inc', Icons.add_circle_outline_rounded),
    ('ti-tools-kitchen-2', 'Food', Icons.restaurant_rounded),
    ('ti-car', 'Transport', Icons.directions_car_rounded),
    ('ti-shopping-bag', 'Shopping', Icons.shopping_bag_outlined),
    ('ti-file-invoice', 'Bills', Icons.receipt_outlined),
    ('ti-heart-rate-monitor', 'Health', Icons.monitor_heart_outlined),
    ('ti-device-gamepad-2', 'Fun', Icons.sports_esports_outlined),
    ('ti-school', 'Education', Icons.school_outlined),
    ('ti-home', 'Home', Icons.home_outlined),
    ('ti-plane', 'Travel', Icons.flight_outlined),
    ('ti-pet', 'Pets', Icons.pets_outlined),
    ('ti-baby', 'Baby', Icons.child_care_outlined),
    ('ti-fitness', 'Fitness', Icons.fitness_center_outlined),
    ('ti-coffee', 'Coffee', Icons.local_cafe_outlined),
    ('ti-movie', 'Movies', Icons.movie_outlined),
    ('ti-dots-circle', 'Other', Icons.more_horiz_rounded),
  ];

  @override
  void initState() {
    super.initState();
    final init = widget.initialData;
    _nameController = TextEditingController(text: init?.name ?? '');
    _selectedType = init?.type ?? CategoryType.expense;
    _selectedColor = init?.color ?? _presetColors[4]; // Default deep orange
    _selectedIcon = init?.icon ?? _categoryIcons[5].$1; // Default food
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.initialData == null ? 'Add Category' : 'Edit Category',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              // Scrollable Form Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Name Field
                        _buildLabel('Category Name'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'e.g. Groceries, Gym, Salary',
                            hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                            filled: true,
                            fillColor: AppColors.background,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Color(_selectedColor), width: 1.5),
                            ),
                          ),
                          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter a category name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // 2. Type SegmentedButton
                        _buildLabel('Category Type'),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<CategoryType>(
                            segments: const [
                              ButtonSegment(
                                value: CategoryType.expense,
                                label: Text('Expense'),
                                icon: Icon(Icons.arrow_upward_rounded, size: 16),
                              ),
                              ButtonSegment(
                                value: CategoryType.income,
                                label: Text('Income'),
                                icon: Icon(Icons.arrow_downward_rounded, size: 16),
                              ),
                              ButtonSegment(
                                value: CategoryType.both,
                                label: Text('Both'),
                                icon: Icon(Icons.swap_horiz_rounded, size: 16),
                              ),
                            ],
                            selected: {_selectedType},
                            onSelectionChanged: (selected) {
                              setState(() => _selectedType = selected.first);
                            },
                            style: SegmentedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              selectedBackgroundColor: Color(_selectedColor).withValues(alpha: 0.15),
                              selectedForegroundColor: Color(_selectedColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 3. Color Swatches Grid
                        _buildLabel('Theme Color'),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemCount: _presetColors.length,
                          itemBuilder: (context, index) {
                            final colorInt = _presetColors[index];
                            final isSelected = _selectedColor == colorInt;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColor = colorInt),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(colorInt),
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(color: AppColors.textPrimary, width: 3)
                                      : null,
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                                    : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // 4. Icon Picker Grid
                        _buildLabel('Category Icon'),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: _categoryIcons.length,
                          itemBuilder: (context, index) {
                            final item = _categoryIcons[index];
                            final isSelected = _selectedIcon == item.$1;
                            final tintColor = Color(_selectedColor);
                            return GestureDetector(
                              onTap: () => setState(() => _selectedIcon = item.$1),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? tintColor.withValues(alpha: 0.15)
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected ? tintColor : AppColors.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      item.$3,
                                      color: isSelected ? tintColor : AppColors.textSecondary,
                                      size: 24,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.$2,
                                      style: AppTextStyles.caption.copyWith(
                                        fontSize: 10,
                                        color: isSelected ? tintColor : AppColors.textSecondary,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: _onSave,
                    style: FilledButton.styleFrom(
                      backgroundColor: Color(_selectedColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Save Category',
                      style: AppTextStyles.title.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        fontSize: 13,
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(categoryRepositoryProvider);

    if (widget.initialData == null) {
      final newCategory = CategoryModel(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
        type: _selectedType,
        isDefault: false,
        sortOrder: 100,
      );
      await repo.add(newCategory);
    } else {
      final updatedCategory = widget.initialData!.copyWith(
        name: _nameController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
        type: _selectedType,
      );
      await repo.update(updatedCategory);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
