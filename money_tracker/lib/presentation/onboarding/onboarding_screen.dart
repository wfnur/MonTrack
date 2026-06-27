import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/pocket_model.dart';
import '../../domain/providers/pocket_providers.dart';
import '../../domain/providers/settings_providers.dart';

class CurrencyOption {
  final String code;
  final String symbol;
  final String name;

  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.name,
  });
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1 State
  static const List<CurrencyOption> _currencies = [
    CurrencyOption(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah'),
    CurrencyOption(code: 'USD', symbol: '\$', name: 'US Dollar'),
    CurrencyOption(code: 'EUR', symbol: '€', name: 'Euro'),
    CurrencyOption(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar'),
    CurrencyOption(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit'),
    CurrencyOption(code: 'GBP', symbol: '£', name: 'British Pound'),
    CurrencyOption(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
  ];
  String _searchQuery = '';
  late CurrencyOption _selectedCurrency;

  // Step 2 State
  final TextEditingController _walletNameController = TextEditingController();
  PocketType _selectedWalletType = PocketType.cash;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = _currencies.first;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _walletNameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _saveStep1() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setString('currency_code', _selectedCurrency.code);
    await prefs.setString('currency_symbol', _selectedCurrency.symbol);
    await prefs.setString('selected_currency', _selectedCurrency.code);
    CurrencyFormatter.setCurrency(_selectedCurrency.code);
    _nextPage();
  }

  Future<void> _createWallet({required String name, required PocketType type}) async {
    final repo = ref.read(pocketRepositoryProvider);
    final newWallet = PocketModel(
      id: const Uuid().v4(),
      name: name.trim().isEmpty ? 'My Wallet' : name.trim(),
      type: type,
      balance: 0.0,
      color: 0xFF4CAF50, // Default Green
      icon: 'ti-wallet',
      isDefault: true,
    );
    await repo.add(newWallet);
    await repo.setDefault(newWallet.id);
  }

  Future<void> _onSkipStep2() async {
    await _createWallet(name: 'My Wallet', type: PocketType.cash);
    _nextPage();
  }

  Future<void> _onContinueStep2() async {
    await _createWallet(
      name: _walletNameController.text,
      type: _selectedWalletType,
    );
    _nextPage();
  }

  Future<void> _onGetStarted() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) => setState(() => _currentStep = idx),
                children: [
                  _buildStep1Currency(),
                  _buildStep2Wallet(),
                  _buildStep3Done(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive = index == _currentStep;
          final isDone = index < _currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            width: isActive ? 32 : 12,
            decoration: BoxDecoration(
              color: isActive
                  ? context.colorPrimary
                  : (isDone ? context.colorPrimary.withValues(alpha: 0.5) : context.colorBorder),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep1Currency() {
    final filtered = _currencies.where((c) {
      final q = _searchQuery.toLowerCase();
      return c.code.toLowerCase().contains(q) ||
          c.name.toLowerCase().contains(q) ||
          c.symbol.toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Money Tracker',
            style: AppTextStyles.display.copyWith(
              color: context.colorTextPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your income and expenses easily',
            style: AppTextStyles.body.copyWith(
              color: context.colorTextSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search currency...',
              hintStyle: AppTextStyles.body.copyWith(color: context.colorTextSecondary),
              prefixIcon: Icon(Icons.search_rounded, color: context.colorTextSecondary),
              filled: true,
              fillColor: context.colorSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.colorBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.colorBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.colorPrimary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final curr = filtered[index];
                final isSelected = curr.code == _selectedCurrency.code;
                return InkWell(
                  onTap: () => setState(() => _selectedCurrency = curr),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colorPrimary.withValues(alpha: 0.1)
                          : context.colorSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? context.colorPrimary : context.colorBorder,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.colorPrimary
                                : context.colorPrimarySurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            curr.symbol,
                            style: AppTextStyles.title.copyWith(
                              color: isSelected ? Colors.white : context.colorPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                curr.code,
                                style: AppTextStyles.title.copyWith(
                                  color: context.colorTextPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                curr.name,
                                style: AppTextStyles.caption.copyWith(
                                  color: context.colorTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle_rounded, color: context.colorPrimary),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: _saveStep1,
              style: FilledButton.styleFrom(
                backgroundColor: context.colorPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Continue',
                style: AppTextStyles.title.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Wallet() {
    final types = [
      (PocketType.cash, 'Cash', Icons.money_rounded),
      (PocketType.bank, 'Bank', Icons.account_balance_rounded),
      (PocketType.ewallet, 'E-Wallet', Icons.phone_android_rounded),
      (PocketType.credit, 'Credit', Icons.credit_card_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add your first wallet',
            style: AppTextStyles.display.copyWith(
              color: context.colorTextPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set up where you store your money',
            style: AppTextStyles.body.copyWith(
              color: context.colorTextSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Wallet Name',
            style: AppTextStyles.caption.copyWith(
              color: context.colorTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _walletNameController,
            decoration: InputDecoration(
              hintText: 'e.g. Cash, Main Bank',
              hintStyle: AppTextStyles.body.copyWith(color: context.colorTextSecondary),
              filled: true,
              fillColor: context.colorSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.colorBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.colorBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.colorPrimary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Wallet Type',
            style: AppTextStyles.caption.copyWith(
              color: context.colorTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: types.map((t) {
              final isSelected = _selectedWalletType == t.$1;
              return InkWell(
                onTap: () => setState(() => _selectedWalletType = t.$1),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colorPrimary.withValues(alpha: 0.1)
                        : context.colorSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? context.colorPrimary : context.colorBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(t.$3, color: isSelected ? context.colorPrimary : context.colorTextSecondary),
                      const SizedBox(width: 12),
                      Text(
                        t.$2,
                        style: AppTextStyles.body.copyWith(
                          color: isSelected ? context.colorPrimary : context.colorTextPrimary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: _onContinueStep2,
              style: FilledButton.styleFrom(
                backgroundColor: context.colorPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Continue',
                style: AppTextStyles.title.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: _onSkipStep2,
              child: Text(
                'Skip for now',
                style: AppTextStyles.body.copyWith(
                  color: context.colorTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Done() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, val, child) => Transform.scale(
              scale: val,
              child: child,
            ),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.income.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.income,
                size: 80,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "You're all set!",
            style: AppTextStyles.display.copyWith(
              color: context.colorTextPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start recording your first transaction and take control of your financial journey.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: context.colorTextSecondary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: _onGetStarted,
              style: FilledButton.styleFrom(
                backgroundColor: context.colorPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Get Started',
                style: AppTextStyles.title.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
