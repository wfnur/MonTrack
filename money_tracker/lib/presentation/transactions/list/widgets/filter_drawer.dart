import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../data/models/category_model.dart';
import '../../../../data/models/pocket_model.dart';
import '../../../../domain/providers/transaction_providers.dart';
import '../../../../domain/providers/category_providers.dart';
import '../../../../domain/providers/pocket_providers.dart';

class FilterDrawer extends ConsumerStatefulWidget {
  const FilterDrawer({super.key});

  @override
  ConsumerState<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends ConsumerState<FilterDrawer> {
  TransactionType? _selectedType;
  String? _selectedCategoryId;
  String? _selectedPocketId;
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(transactionFilterProvider);
    _selectedType = filter.type;
    _selectedCategoryId = filter.categoryId;
    _selectedPocketId = filter.pocketId;
    _selectedRange = filter.range;
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider());
    final pocketsAsync = ref.watch(pocketListProvider);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter',
                    style: AppTextStyles.headline.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: _resetFilters,
                    child: Text(
                      'Reset',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.expense,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Transaction Type
              Text(
                'Type',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<TransactionType?>(
                  segments: const [
                    ButtonSegment(
                      value: null,
                      label: Text('All'),
                    ),
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text('Income'),
                    ),
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text('Expense'),
                    ),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (selected) {
                    setState(() => _selectedType = selected.first);
                  },
                  showSelectedIcon: false,
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: WidgetStatePropertyAll(
                      AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Category
              Text(
                'Category',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              categoriesAsync.when(
                data: (categories) => _buildDropdown<CategoryModel>(
                  value: categories.where((c) => c.id == _selectedCategoryId).firstOrNull,
                  items: categories,
                  hint: 'All Categories',
                  labelBuilder: (c) => c.name,
                  onChanged: (c) {
                    setState(() => _selectedCategoryId = c?.id);
                  },
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Error loading categories'),
              ),
              const SizedBox(height: 24),

              // Pocket
              Text(
                'Pocket',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              pocketsAsync.when(
                data: (pockets) => _buildDropdown<PocketModel>(
                  value: pockets.where((p) => p.id == _selectedPocketId).firstOrNull,
                  items: pockets,
                  hint: 'All Pockets',
                  labelBuilder: (p) => p.name,
                  onChanged: (p) {
                    setState(() => _selectedPocketId = p?.id);
                  },
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Error loading pockets'),
              ),
              const SizedBox(height: 24),

              // Date Range
              Text(
                'Date Range',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _selectDateRange(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedRange != null
                              ? '${_formatDate(_selectedRange!.start)} - ${_formatDate(_selectedRange!.end)}'
                              : 'Select date range',
                          style: AppTextStyles.body.copyWith(
                            color: _selectedRange != null
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (_selectedRange != null)
                        GestureDetector(
                          onTap: () => setState(() => _selectedRange = null),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Apply Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _applyFilters,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required String hint,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        hint: Text(
          hint,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        items: [
          DropdownMenuItem<T>(
            value: null,
            child: Text(
              hint,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          ...items.map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  labelBuilder(item),
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                ),
              )),
        ],
        onChanged: onChanged,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedRange = picked);
    }
  }

  void _applyFilters() {
    final notifier = ref.read(transactionFilterProvider.notifier);
    notifier.setType(_selectedType);
    notifier.setCategory(_selectedCategoryId);
    notifier.setPocket(_selectedPocketId);
    notifier.setDateRange(_selectedRange);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _selectedType = null;
      _selectedCategoryId = null;
      _selectedPocketId = null;
      _selectedRange = null;
    });
    ref.read(transactionFilterProvider.notifier).reset();
  }
}
