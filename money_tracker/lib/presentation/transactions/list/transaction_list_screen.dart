import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/category_model.dart';
import '../../../domain/providers/transaction_providers.dart';
import '../../../domain/providers/category_providers.dart';
import 'widgets/transaction_tile.dart';
import 'widgets/filter_drawer.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionListProvider);
    final categoriesAsync = ref.watch(categoryListProvider());

    // Build category lookup map
    final categoryMap = categoriesAsync.whenData((cats) {
      return {for (final c in cats) c.id: c};
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      endDrawer: const FilterDrawer(),
      body: transactionsAsync.when(
        data: (transactions) {
          // Apply local search filter
          final filtered = _applySearch(transactions, categoryMap.value ?? {});
          if (filtered.isEmpty) {
            return _buildEmptyState();
          }
          return _buildGroupedList(filtered, categoryMap.value ?? {});
        },
        loading: () => _buildShimmer(),
        error: (error, _) => Center(
          child: Text(
            'Error: $error',
            style: AppTextStyles.body.copyWith(color: AppColors.expense),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchQuery = '';
              _searchController.clear();
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search transactions...',
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            border: InputBorder.none,
          ),
          style: AppTextStyles.body.copyWith(
            color: AppColors.textPrimary,
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value.toLowerCase());
          },
        ),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
        ],
      );
    }

    return AppBar(
      backgroundColor: AppColors.background,
      title: Text(
        'Transactions',
        style: AppTextStyles.title.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () => setState(() => _isSearching = true),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
      ],
    );
  }

  List<TransactionModel> _applySearch(
    List<TransactionModel> transactions,
    Map<String, CategoryModel> categoryMap,
  ) {
    if (_searchQuery.isEmpty) return transactions;
    return transactions.where((tx) {
      final categoryName =
          categoryMap[tx.categoryId]?.name.toLowerCase() ?? '';
      final note = tx.note?.toLowerCase() ?? '';
      final amount = tx.amount.toString();
      return categoryName.contains(_searchQuery) ||
          note.contains(_searchQuery) ||
          amount.contains(_searchQuery);
    }).toList();
  }

  Widget _buildGroupedList(
    List<TransactionModel> transactions,
    Map<String, CategoryModel> categoryMap,
  ) {
    // Group transactions by date header
    final groups = <String, List<TransactionModel>>{};
    for (final tx in transactions) {
      final header = DateFormatter.formatGroupHeader(tx.date);
      groups.putIfAbsent(header, () => []).add(tx);
    }

    final groupKeys = groups.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: groupKeys.length,
      itemBuilder: (context, groupIndex) {
        final header = groupKeys[groupIndex];
        final items = groups[header]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date separator header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                header,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Transaction items in this group
            ...items.map((tx) => TransactionTile(
                  transaction: tx,
                  category: categoryMap[tx.categoryId],
                  onTap: () => context.push('/transactions/${tx.id}'),
                  onEdit: () {
                    // TODO: Open edit form
                  },
                  onDelete: () {
                    ref
                        .read(transactionRepositoryProvider)
                        .delete(tx.id);
                  },
                )),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No transactions found'
                : 'No transactions yet',
            style: AppTextStyles.title.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try a different search term'
                : 'Tap + to add your first transaction',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 8,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 90,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 80,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
