import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/pocket_model.dart';
import '../../../../domain/providers/pocket_providers.dart';

class WalletFormSheet extends ConsumerStatefulWidget {
  final PocketModel? initialData;

  const WalletFormSheet({super.key, this.initialData});

  static Future<void> show(BuildContext context, {PocketModel? initialData}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WalletFormSheet(initialData: initialData),
    );
  }

  @override
  ConsumerState<WalletFormSheet> createState() => _WalletFormSheetState();
}

class _WalletFormSheetState extends ConsumerState<WalletFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late TextEditingController _institutionController;
  late TextEditingController _lastFourController;

  late PocketType _selectedType;
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

  static const _presetIcons = [
    ('ti-wallet', 'Wallet', Icons.account_balance_wallet_outlined),
    ('ti-building-bank', 'Bank', Icons.account_balance_outlined),
    ('ti-device-mobile', 'E-Wallet', Icons.phone_android_outlined),
    ('ti-credit-card', 'Card', Icons.credit_card_outlined),
    ('ti-cash', 'Cash', Icons.money_outlined),
    ('ti-coin', 'Coin', Icons.monetization_on_outlined),
    ('ti-piggy-bank', 'Savings', Icons.savings_outlined),
    ('ti-receipt', 'Bills', Icons.receipt_long_outlined),
  ];

  @override
  void initState() {
    super.initState();
    final init = widget.initialData;
    _nameController = TextEditingController(text: init?.name ?? '');
    _balanceController = TextEditingController(
      text: init != null
          ? init.balance.toStringAsFixed(init.balance == init.balance.truncateToDouble() ? 0 : 2)
          : '',
    );
    _institutionController = TextEditingController(text: init?.institution ?? '');
    _lastFourController = TextEditingController(text: init?.lastFour ?? '');

    _selectedType = init?.type ?? PocketType.cash;
    _selectedColor = init?.color ?? _presetColors[0];
    _selectedIcon = init?.icon ?? _presetIcons[0].$1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _institutionController.dispose();
    _lastFourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showInstitution = _selectedType == PocketType.bank ||
        _selectedType == PocketType.ewallet ||
        _selectedType == PocketType.credit;
    final showLastFour =
        _selectedType == PocketType.bank || _selectedType == PocketType.credit;

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
                widget.initialData == null ? 'Add Wallet' : 'Edit Wallet',
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
                        _buildLabel('Wallet Name'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputDecoration('e.g. Main Cash, Chase Bank'),
                          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter a wallet name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // 2. Type ChoiceChip Row
                        _buildLabel('Wallet Type'),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildTypeChip(PocketType.cash, 'Cash', Icons.money_rounded),
                              _buildTypeChip(PocketType.bank, 'Bank', Icons.account_balance_rounded),
                              _buildTypeChip(PocketType.ewallet, 'E-Wallet', Icons.phone_android_rounded),
                              _buildTypeChip(PocketType.credit, 'Credit', Icons.credit_card_rounded),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 3. Initial Balance Field (Only when creating or optional)
                        _buildLabel('Initial Balance'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _balanceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: _inputDecoration('0.00').copyWith(
                            prefixText: '\$ ',
                            prefixStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                          ),
                          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 20),

                        // 4. Institution & Last 4 Digits (Conditional)
                        if (showInstitution) ...[
                          _buildLabel('Institution Name (Optional)'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _institutionController,
                            decoration: _inputDecoration('e.g. Chase, PayPal, Apple Pay'),
                            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 20),
                        ],

                        if (showLastFour) ...[
                          _buildLabel('Last 4 Digits (Optional)'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _lastFourController,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: _inputDecoration('1234').copyWith(counterText: ''),
                            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // 5. Color Picker Grid
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

                        // 6. Icon Picker Grid
                        _buildLabel('Wallet Icon'),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: _presetIcons.length,
                          itemBuilder: (context, index) {
                            final item = _presetIcons[index];
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
                      'Save Wallet',
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

  Widget _buildTypeChip(PocketType type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    final activeColor = Color(_selectedColor);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedType = type);
        }
      },
      selectedColor: activeColor,
      backgroundColor: AppColors.background,
      labelStyle: AppTextStyles.caption.copyWith(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? activeColor : AppColors.border,
        ),
      ),
      showCheckmark: false,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(pocketRepositoryProvider);
    final parsedBalance = double.tryParse(_balanceController.text.trim()) ?? 0.0;
    final inst = _institutionController.text.trim().isEmpty ? null : _institutionController.text.trim();
    final l4 = _lastFourController.text.trim().isEmpty ? null : _lastFourController.text.trim();

    if (widget.initialData == null) {
      final newPocket = PocketModel(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        type: _selectedType,
        balance: parsedBalance,
        color: _selectedColor,
        icon: _selectedIcon,
        institution: inst,
        lastFour: l4,
        isDefault: false,
      );
      await repo.add(newPocket);

      // Check if first pocket created, set as default
      final allPockets = await repo.getAll();
      if (allPockets.length == 1) {
        await repo.setDefault(newPocket.id);
      }
    } else {
      final updatedPocket = widget.initialData!.copyWith(
        name: _nameController.text.trim(),
        type: _selectedType,
        balance: parsedBalance,
        color: _selectedColor,
        icon: _selectedIcon,
        institution: inst,
        lastFour: l4,
      );
      await repo.update(updatedPocket);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
