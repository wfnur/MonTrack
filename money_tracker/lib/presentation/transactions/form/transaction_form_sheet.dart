import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/animation_utils.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../domain/providers/category_providers.dart';
import '../../../../domain/providers/pocket_providers.dart';
import '../../../../domain/providers/transaction_providers.dart';
import 'widgets/category_grid_picker.dart';
import 'widgets/label_chips.dart';
import 'widgets/numpad_input.dart';
import 'widgets/pocket_selector.dart';

class TransactionFormState {
  final TransactionType type;
  final double amount;
  final DateTime date;
  final String? categoryId;
  final String? pocketId;
  final Set<String> labelIds;
  final String note;

  const TransactionFormState({
    required this.type,
    required this.amount,
    required this.date,
    this.categoryId,
    this.pocketId,
    required this.labelIds,
    required this.note,
  });

  TransactionFormState copyWith({
    TransactionType? type,
    double? amount,
    DateTime? date,
    String? categoryId,
    String? pocketId,
    Set<String>? labelIds,
    String? note,
  }) {
    return TransactionFormState(
      type: type ?? this.type,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      pocketId: pocketId ?? this.pocketId,
      labelIds: labelIds ?? this.labelIds,
      note: note ?? this.note,
    );
  }
}

class TransactionFormNotifier extends StateNotifier<TransactionFormState> {
  TransactionFormNotifier(TransactionModel? initialData)
      : super(TransactionFormState(
          type: initialData?.type ?? TransactionType.expense,
          amount: initialData?.amount ?? 0.0,
          date: initialData?.date ?? DateTime.now(),
          categoryId: initialData?.categoryId,
          pocketId: initialData?.pocketId,
          labelIds: initialData != null ? Set.from(initialData.labelIds) : {},
          note: initialData?.note ?? '',
        ));

  void setType(TransactionType type) {
    if (state.type != type) {
      state = state.copyWith(type: type, categoryId: null);
    }
  }

  void setAmount(double amount) => state = state.copyWith(amount: amount);
  void setDate(DateTime date) => state = state.copyWith(date: date);
  void setCategory(String? categoryId) =>
      state = state.copyWith(categoryId: categoryId);
  void setPocket(String? pocketId) =>
      state = state.copyWith(pocketId: pocketId);
  void setLabelIds(Set<String> labelIds) =>
      state = state.copyWith(labelIds: labelIds);
  void setNote(String note) => state = state.copyWith(note: note);
}

final transactionFormProvider = StateNotifierProvider.autoDispose.family<
    TransactionFormNotifier, TransactionFormState, TransactionModel?>(
  (ref, initialData) => TransactionFormNotifier(initialData),
);

class TransactionFormSheet extends ConsumerStatefulWidget {
  final TransactionModel? initialData;

  const TransactionFormSheet({super.key, this.initialData});

  static Future<void> show(
    BuildContext context, {
    TransactionModel? initialData,
  }) {
    return showAnimatedBottomSheet(
      context: context,
      builder: (_) => TransactionFormSheet(initialData: initialData),
    );
  }

  @override
  ConsumerState<TransactionFormSheet> createState() =>
      _TransactionFormSheetState();
}

class _TransactionFormSheetState extends ConsumerState<TransactionFormSheet> {
  late TextEditingController _noteController;
  bool _hasSubmittedWithEmptyCategory = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialData?.note ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionFormProvider(widget.initialData));
    final notifier = ref.read(transactionFormProvider(widget.initialData).notifier);

    final accentColor = state.type == TransactionType.income
        ? AppColors.income
        : AppColors.expense;

    final pocketsAsync = ref.watch(pocketListProvider);
    final defaultPocketAsync = ref.watch(defaultPocketProvider);
    final categoriesAsync = ref.watch(categoryListProvider());

    // Compute effective pocketId
    final effectivePocketId = state.pocketId ??
        defaultPocketAsync.value?.id ??
        pocketsAsync.value?.firstOrNull?.id;

    if (state.pocketId == null && effectivePocketId != null) {
      Future.microtask(() => notifier.setPocket(effectivePocketId));
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
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
              // Sheet Drag Handle
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
                widget.initialData == null
                    ? 'Add Transaction'
                    : 'Edit Transaction',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              // Scrollable Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // 1. TYPE TOGGLE
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<TransactionType>(
                        segments: const [
                          ButtonSegment(
                            value: TransactionType.income,
                            label: Text('Income'),
                            icon: Icon(Icons.arrow_downward_rounded, size: 16),
                          ),
                          ButtonSegment(
                            value: TransactionType.expense,
                            label: Text('Expense'),
                            icon: Icon(Icons.arrow_upward_rounded, size: 16),
                          ),
                        ],
                        selected: {state.type},
                        onSelectionChanged: (selected) {
                          notifier.setType(selected.first);
                        },
                        style: SegmentedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          selectedBackgroundColor: accentColor.withValues(alpha: 0.15),
                          selectedForegroundColor: accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. AMOUNT DISPLAY
                    GestureDetector(
                      onTap: () async {
                        final newAmount = await NumpadInput.show(
                          context,
                          initialAmount: state.amount,
                          accentColor: accentColor,
                        );
                        if (newAmount != null) {
                          notifier.setAmount(newAmount);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Amount',
                              style: AppTextStyles.caption.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.format(state.amount),
                              style: AppTextStyles.display.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. DATE FIELD
                    _buildSectionTitle('Date'),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: Theme.of(context)
                                  .colorScheme
                                  .copyWith(primary: accentColor),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          notifier.setDate(picked);
                        }
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                DateFormatter.format(state.date),
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. CATEGORY GRID
                    _buildSectionTitle('Category'),
                    const SizedBox(height: 8),
                    categoriesAsync.when(
                      data: (categories) {
                        final selectedCategory = categories
                            .where((c) => c.id == state.categoryId)
                            .firstOrNull;

                        return InkWell(
                          onTap: () async {
                            final filterType = state.type == TransactionType.income
                                ? CategoryType.income
                                : CategoryType.expense;
                            final picked = await CategoryGridPicker.show(
                              context,
                              filterType: filterType,
                              selectedCategoryId: state.categoryId,
                            );
                            if (picked != null) {
                              notifier.setCategory(picked.id);
                              setState(() => _hasSubmittedWithEmptyCategory = false);
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedCategory != null
                                    ? Color(selectedCategory.color)
                                    : (_hasSubmittedWithEmptyCategory
                                        ? AppColors.expense
                                        : AppColors.border),
                                width: selectedCategory != null || _hasSubmittedWithEmptyCategory ? 1.5 : 1.0,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              color: selectedCategory != null
                                  ? Color(selectedCategory.color)
                                      .withValues(alpha: 0.08)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                if (selectedCategory != null) ...[
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Color(selectedCategory.color)
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      _categoryIcon(selectedCategory.icon),
                                      color: Color(selectedCategory.color),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      selectedCategory.name,
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.category_outlined,
                                      color: AppColors.textSecondary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Select Category',
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => const Text('Error loading categories'),
                    ),
                    const SizedBox(height: 24),

                    // 5. POCKET SELECTOR
                    _buildSectionTitle('Pocket'),
                    const SizedBox(height: 8),
                    pocketsAsync.when(
                      data: (pockets) {
                        if (pockets.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.expense.withValues(alpha: 0.1),
                              border: Border.all(color: AppColors.expense),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: AppColors.expense),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Please add a wallet first',
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
                        return PocketSelector(
                          pockets: pockets,
                          selectedPocketId: effectivePocketId,
                          onPocketSelected: (id) => notifier.setPocket(id),
                        );
                      },
                      loading: () => const SizedBox(height: 68),
                      error: (_, __) => const Text('Error loading pockets'),
                    ),
                    const SizedBox(height: 24),

                    // 6. LABEL CHIPS
                    _buildSectionTitle('Labels (Optional)'),
                    const SizedBox(height: 8),
                    LabelChips(
                      selectedIds: state.labelIds,
                      onChanged: (ids) => notifier.setLabelIds(ids),
                    ),
                    const SizedBox(height: 24),

                    // 7. NOTE FIELD
                    _buildSectionTitle('Note (Optional)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Add a note...',
                        hintStyle: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
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
                          borderSide: BorderSide(color: accentColor, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      onChanged: (val) => notifier.setNote(val),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // 8. SAVE BUTTON
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: pocketsAsync.value?.isEmpty == true
                        ? null
                        : () => _onSave(state, effectivePocketId),
                    style: FilledButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Save Transaction',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.caption.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        fontSize: 13,
      ),
    );
  }

  Future<void> _onSave(TransactionFormState state, String? pocketId) async {
    if (state.amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }
    if (state.categoryId == null) {
      setState(() => _hasSubmittedWithEmptyCategory = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }
    if (pocketId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a wallet first')),
      );
      return;
    }

    final repo = ref.read(transactionRepositoryProvider);
    final noteText = state.note.trim().isEmpty ? null : state.note.trim();

    if (widget.initialData == null) {
      final newTx = TransactionModel(
        id: const Uuid().v4(),
        type: state.type,
        amount: state.amount,
        date: state.date,
        categoryId: state.categoryId!,
        labelIds: state.labelIds.toList(),
        note: noteText,
        pocketId: pocketId,
        createdAt: DateTime.now(),
      );
      await repo.add(newTx);
    } else {
      final updatedTx = widget.initialData!.copyWith(
        type: state.type,
        amount: state.amount,
        date: state.date,
        categoryId: state.categoryId!,
        labelIds: state.labelIds.toList(),
        note: noteText,
        pocketId: pocketId,
      );
      await repo.update(updatedTx);
    }

    if (mounted) {
      Navigator.pop(context);
    }
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
