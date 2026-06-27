import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MaterialApp.router(
        title: 'Money Tracker',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    ),
  );
}
