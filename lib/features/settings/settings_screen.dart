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
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    // Load existing key
    final key = ref.read(storageProvider).getApiKey();
    if (key != null) {
      _apiKeyController.text = key;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveApiKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isNotEmpty) {
      final storage = ref.read(storageProvider);
      await storage.saveApiKey(key);
      ref.invalidate(apiKeyProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'API Key Saved Successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('AI Configuration'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gemini API Key',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Required for AI tips, reports, and chat.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      hintText: 'Enter your API Key',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveApiKey,
                      child: const Text('Save API Key'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
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
