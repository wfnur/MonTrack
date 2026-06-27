import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/empty_state.dart';
import '../../common/shimmer_list.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/category_model.dart';
import '../../../domain/providers/transaction_providers.dart';
import '../../../domain/providers/category_providers.dart';
import 'widgets/transaction_tile.dart';
import 'widgets/filter_drawer.dart';
import '../form/transaction_form_sheet.dart';

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
      backgroundColor: context.colorBackground,
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
        loading: () => const ShimmerList(itemCount: 8),
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
        backgroundColor: context.colorBackground,
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
              color: context.colorTextSecondary,
            ),
            border: InputBorder.none,
          ),
          style: AppTextStyles.body.copyWith(
            color: context.colorTextPrimary,
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
      backgroundColor: context.colorBackground,
      title: Text(
        'Transactions',
        style: AppTextStyles.title.copyWith(
          color: context.colorTextPrimary,
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
                  color: context.colorTextSecondary,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Transaction items in this group
            ...items.asMap().entries.map((entry) {
              final idx = entry.key;
              final tx = entry.value;
              return TweenAnimationBuilder<double>(
                key: ValueKey(tx.id),
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 400 + (idx * 60)),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value.clamp(0.0, 1.0),
                    alignment: Alignment.centerLeft,
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  );
                },
                child: TransactionTile(
                  transaction: tx,
                  category: categoryMap[tx.categoryId],
                  onTap: () => context.push('/transactions/${tx.id}'),
                  onEdit: () {
                    TransactionFormSheet.show(context, initialData: tx);
                  },
                  onDelete: () {
                    ref
                        .read(transactionRepositoryProvider)
                        .delete(tx.id);
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final filter = ref.watch(transactionFilterProvider);
    final isFiltering = _searchQuery.isNotEmpty || filter != const TransactionFilterState();

    if (isFiltering) {
      return EmptyState(
        icon: '🔍',
        title: 'No results found',
        subtitle: 'Try adjusting your search or filters',
        action: TextButton(
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchQuery = '';
              _searchController.clear();
            });
            ref.read(transactionFilterProvider.notifier).reset();
          },
          child: Text(
            'Reset Filters',
            style: AppTextStyles.body.copyWith(
              color: context.colorPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return EmptyState(
      icon: '💸',
      title: 'No transactions yet',
      subtitle: 'Tap + to add your first income or expense',
      action: ElevatedButton(
        onPressed: () => TransactionFormSheet.show(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text('Add Transaction'),
      ),
    );
  }
}
