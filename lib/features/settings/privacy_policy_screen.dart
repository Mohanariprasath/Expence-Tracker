import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: December 2024',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Data Collection',
              'Antigravity stores all your financial data locally on your device. We do not collect, transmit, or store any of your personal information on external servers.',
            ),
            _buildSection(
              context,
              'Data Storage',
              'All transaction data, goals, and settings are encrypted and stored securely on your device using industry-standard encryption methods.',
            ),
            _buildSection(
              context,
              'AI Features',
              'When you use AI features (tips, reports, chat), your transaction data is sent to Google\'s Gemini AI service for analysis. This data is processed in real-time and is not stored by Google beyond the duration of the request.',
            ),
            _buildSection(
              context,
              'Third-Party Services',
              'Antigravity uses Google Gemini AI for intelligent financial insights. Please refer to Google\'s Privacy Policy for information on how they handle data.',
            ),
            _buildSection(
              context,
              'Data Security',
              'We implement appropriate security measures to protect your data from unauthorized access, alteration, or destruction. However, no method of electronic storage is 100% secure.',
            ),
            _buildSection(
              context,
              'Your Rights',
              'You have full control over your data. You can export or delete all your data at any time from the Settings screen.',
            ),
            _buildSection(
              context,
              'Changes to Privacy Policy',
              'We may update this privacy policy from time to time. We will notify you of any changes by updating the "Last updated" date.',
            ),
            _buildSection(
              context,
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at support@antigravity.app',
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your privacy and security are our top priorities.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.6, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
