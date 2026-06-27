import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/providers/settings_providers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Settings',
          style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final currentCurrency = ref.watch(currencyNotifierProvider);
          final currentThemeMode = ref.watch(themeModeNotifierProvider);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            children: [
              // Group 1: General
              _buildGroupHeader('General'),
              _buildGroupCard([
                _buildTile(
                  icon: Icons.currency_exchange_rounded,
                  title: 'Currency',
                  subtitle: '$currentCurrency (${CurrencyFormatter.currentSymbol})',
                  onTap: () => _showCurrencyDialog(context, ref, currentCurrency),
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  subtitle: _themeModeName(currentThemeMode),
                  onTap: () => _showAppearanceSheet(context, ref, currentThemeMode),
                ),
              ]),
              const SizedBox(height: 24),

              // Group 2: Manage
              _buildGroupHeader('Manage'),
              _buildGroupCard([
                _buildTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Wallets',
                  subtitle: 'Manage accounts & balances',
                  onTap: () => context.push('/settings/wallets'),
                  showTrailingArrow: true,
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.category_outlined,
                  title: 'Categories',
                  subtitle: 'Income & expense categories',
                  onTap: () => context.push('/settings/categories'),
                  showTrailingArrow: true,
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.label_outline_rounded,
                  title: 'Labels',
                  subtitle: 'Tags for transactions',
                  onTap: () => context.push('/settings/labels'),
                  showTrailingArrow: true,
                ),
              ]),
              const SizedBox(height: 24),

              // Group 3: Data
              _buildGroupHeader('Data'),
              _buildGroupCard([
                _buildTile(
                  icon: Icons.import_export_rounded,
                  title: 'Export / Import',
                  subtitle: 'Backup or restore data',
                  onTap: () => context.push('/settings/export'),
                  showTrailingArrow: true,
                ),
              ]),
              const SizedBox(height: 24),

              // Group 4: About
              _buildGroupHeader('About'),
              _buildGroupCard([
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data?.version ?? '1.0.0';
                    final buildNumber = snapshot.data?.buildNumber ?? '1';
                    return _buildTile(
                      icon: Icons.info_outline_rounded,
                      title: 'Version',
                      subtitle: 'v$version ($buildNumber)',
                      onTap: null,
                    );
                  },
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Rate this app',
                  subtitle: 'Leave a review on the store',
                  onTap: () => _launchStoreUrl(),
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'How your data is protected',
                  onTap: () => _showPrivacyPolicy(context),
                ),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool showTrailingArrow = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: onTap,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: showTrailingArrow
          ? Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary)
          : null,
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 74),
      child: Divider(color: AppColors.border, height: 1),
    );
  }

  String _themeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  void _showCurrencyDialog(BuildContext context, WidgetRef ref, String currentCurrency) {
    showDialog(
      context: context,
      builder: (ctx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = kAvailableCurrencies.where((item) {
              final code = item.$1.toLowerCase();
              final name = item.$2.toLowerCase();
              final q = searchQuery.toLowerCase();
              return code.contains(q) || name.contains(q);
            }).toList();

            return AlertDialog(
              title: const Text('Select Currency'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search currency code or name...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onChanged: (val) => setState(() => searchQuery = val),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final isSelected = item.$1 == currentCurrency;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            leading: CircleAvatar(
                              backgroundColor: isSelected
                                  ? AppColors.primary
                                  : AppColors.primarySurface,
                              child: Text(
                                item.$3,
                                style: AppTextStyles.caption.copyWith(
                                  color: isSelected ? Colors.white : AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            title: Text(
                              '${item.$1} — ${item.$2}',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                                : null,
                            onTap: () {
                              ref.read(currencyNotifierProvider.notifier).setCurrency(item.$1);
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Close', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAppearanceSheet(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Appearance',
                  style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              _buildAppearanceTile(ctx, ref, 'Light Mode', Icons.light_mode_outlined, ThemeMode.light, currentMode),
              _buildAppearanceTile(ctx, ref, 'Dark Mode', Icons.dark_mode_outlined, ThemeMode.dark, currentMode),
              _buildAppearanceTile(ctx, ref, 'System Default', Icons.brightness_auto_outlined, ThemeMode.system, currentMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppearanceTile(
    BuildContext context,
    WidgetRef ref,
    String title,
    IconData icon,
    ThemeMode mode,
    ThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
      onTap: () {
        ref.read(themeModeNotifierProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  Future<void> _launchStoreUrl() async {
    final uri = Uri.parse('https://play.google.com/store/apps/details?id=com.example.moneytracker');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text(
          'Money Tracker values your privacy. All financial transactions, wallets, and custom preferences are stored locally on your device using encrypted database structures.\n\nWe do not track, share, or upload any personal or financial information to third-party servers.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Got it', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
