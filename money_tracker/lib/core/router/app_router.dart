import 'package:go_router/go_router.dart';
import '../../presentation/shell/app_shell.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/transactions/list/transaction_list_screen.dart';
import '../../presentation/transactions/detail/transaction_detail_screen.dart';
import '../../presentation/analytics/analytics_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/settings/wallets/wallets_screen.dart';
import '../../presentation/settings/categories/categories_screen.dart';
import '../../presentation/settings/labels/labels_screen.dart';
import '../../presentation/settings/export/export_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionListScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => TransactionDetailScreen(
                id: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'wallets',
              builder: (context, state) => const WalletsScreen(),
            ),
            GoRoute(
              path: 'categories',
              builder: (context, state) => const CategoriesScreen(),
            ),
            GoRoute(
              path: 'labels',
              builder: (context, state) => const LabelsScreen(),
            ),
            GoRoute(
              path: 'export',
              builder: (context, state) => const ExportScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
