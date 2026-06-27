import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/label_model.dart';
import '../../../../domain/providers/label_providers.dart';

class LabelFormSheet extends ConsumerStatefulWidget {
  final LabelModel? initialData;

  const LabelFormSheet({super.key, this.initialData});

  static Future<void> show(BuildContext context, {LabelModel? initialData}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LabelFormSheet(initialData: initialData),
    );
  }

  @override
  ConsumerState<LabelFormSheet> createState() => _LabelFormSheetState();
}

class _LabelFormSheetState extends ConsumerState<LabelFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late int _selectedColor;

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

  @override
  void initState() {
    super.initState();
    final init = widget.initialData;
    _nameController = TextEditingController(text: init?.name ?? '');
    _selectedColor = init?.color ?? _presetColors[1]; // Default Blue
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                widget.initialData == null ? 'Add Label' : 'Edit Label',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              // Name Field
              Text(
                'Label Name',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                autofocus: widget.initialData == null,
                decoration: InputDecoration(
                  hintText: 'e.g. Vacation, Urgent, Shared',
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
                    return 'Please enter a label name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Color Swatches
              Text(
                'Theme Color',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
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
              const SizedBox(height: 28),

              // Save Button
              SizedBox(
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
                    'Save Label',
                    style: AppTextStyles.title.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(labelRepositoryProvider);

    if (widget.initialData == null) {
      final newLabel = LabelModel(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        color: _selectedColor,
        createdAt: DateTime.now(),
      );
      await repo.add(newLabel);
    } else {
      final updatedLabel = widget.initialData!.copyWith(
        name: _nameController.text.trim(),
        color: _selectedColor,
      );
      await repo.update(updatedLabel);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
