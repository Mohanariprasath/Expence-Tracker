import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/providers.dart';
import 'package:my_app/core/constants/app_colors.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Appearance'),
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (val) async {
                final storage = ref.read(storageProvider);
                await storage.saveThemeMode(val);
                ref.read(themeModeProvider.notifier).state = val;
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Data'),
          Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Clear Data feature coming soon"),
                  ),
                );
              },
              child: const ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.error),
                title: Text(
                  'Clear All Data',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
