import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/providers.dart';
import 'package:my_app/core/theme/app_theme.dart';
import 'package:my_app/navigation/bottom_navigation.dart';

class AntigravityApp extends ConsumerWidget {
  const AntigravityApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Antigravity',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainNavigationScreen(),
      // Add routes if needed, but home handles bottom nav
    );
  }
}
