import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/category_model.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/providers/pocket_providers.dart';
import '../../domain/providers/transaction_providers.dart';
import '../../domain/providers/category_providers.dart';
import 'widgets/balance_card.dart';
import 'widgets/pocket_switcher.dart';
import 'widgets/recent_transactions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedPocketId;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final pocketsAsync = ref.watch(pocketListProvider);
    final categoriesAsync = ref.watch(categoryListProvider());
    final transactionsAsync = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: context.colorBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Greeting header
              Text(
                _greeting(),
                style: AppTextStyles.caption.copyWith(
                  color: context.colorTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your Finances',
                style: AppTextStyles.headline.copyWith(
                  color: context.colorTextPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // Balance Card
              _buildBalanceCard(transactionsAsync),
              const SizedBox(height: 20),

              // Pocket Switcher
              _buildPocketSwitcher(pocketsAsync, transactionsAsync),
              const SizedBox(height: 24),

              // Recent Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent',
                    style: AppTextStyles.title.copyWith(
                      color: context.colorTextPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to transactions list
                    },
                    child: Text(
                      'See All',
                      style: AppTextStyles.caption.copyWith(
                        color: context.colorPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // Recent Transactions List
              _buildRecentTransactions(transactionsAsync, categoriesAsync),
              const SizedBox(height: 80), // Bottom padding for FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(AsyncValue<List<TransactionModel>> transactionsAsync) {
    return transactionsAsync.when(
      data: (transactions) {
        double totalIncome = 0;
        double totalExpense = 0;
        for (final tx in transactions) {
          if (tx.type == TransactionType.income) {
            totalIncome += tx.amount;
          } else {
            totalExpense += tx.amount;
          }
        }
        return BalanceCard(
          totalBalance: totalIncome - totalExpense,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
        );
      },
      loading: () => const BalanceCard(
        totalBalance: 0,
        totalIncome: 0,
        totalExpense: 0,
      ),
      error: (_, __) => const BalanceCard(
        totalBalance: 0,
        totalIncome: 0,
        totalExpense: 0,
      ),
    );
  }

  Widget _buildPocketSwitcher(
    AsyncValue pocketsAsync,
    AsyncValue<List<TransactionModel>> transactionsAsync,
  ) {
    return pocketsAsync.when(
      data: (pockets) {
        double totalBalance = 0;
        for (final pocket in pockets) {
          totalBalance += pocket.balance;
        }
        return PocketSwitcher(
          pockets: pockets,
          selectedPocketId: _selectedPocketId,
          totalBalance: totalBalance,
          onPocketSelected: (pocketId) {
            setState(() => _selectedPocketId = pocketId);
            ref.read(transactionFilterProvider.notifier).setPocket(pocketId);
          },
        );
      },
      loading: () => const SizedBox(height: 88),
      error: (_, __) => const SizedBox(height: 88),
    );
  }

  Widget _buildRecentTransactions(
    AsyncValue<List<TransactionModel>> transactionsAsync,
    AsyncValue<List<CategoryModel>> categoriesAsync,
  ) {
    final categoryMap = categoriesAsync.whenData((cats) {
      return {for (final c in cats) c.id: c};
    });

    return transactionsAsync.when(
      data: (transactions) {
        final recent = transactions.take(5).toList();
        return RecentTransactions(
          transactions: recent,
          categoryMap: categoryMap.value ?? {},
        );
      },
      loading: () => const RecentTransactions(
        transactions: [],
        categoryMap: {},
        isLoading: true,
      ),
      error: (_, __) => const RecentTransactions(
        transactions: [],
        categoryMap: {},
      ),
    );
  }
}
