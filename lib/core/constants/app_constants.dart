class AppConstants {
  // App Information
  static const String appName = 'Antigravity';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Your AI-powered personal finance companion. Track expenses, set goals, and get intelligent financial insights.';

  // Support
  static const String supportEmail = 'support@antigravity.app';
  static const String helpUrl = 'https://antigravity.app/help';

  // Privacy
  static const String privacyPolicyUrl = 'https://antigravity.app/privacy';
  static const String termsUrl = 'https://antigravity.app/terms';

  // FAQ Data
  static const List<Map<String, String>> faqItems = [
    {
      'question': 'How do I add a transaction?',
      'answer':
          'Tap the + button on the Home screen, enter the transaction details (title, amount, type), and save. Your transaction will appear immediately in your list.',
    },
    {
      'question': 'What are AI financial tips?',
      'answer':
          'Antigravity uses AI to analyze your spending patterns and provide personalized financial advice to help you save money and reach your goals.',
    },
    {
      'question': 'How do I set a financial goal?',
      'answer':
          'Go to the Goals tab, tap the + button, enter your goal details (title, target amount, current savings, deadline), and save. The AI will help you create a plan to achieve it.',
    },
    {
      'question': 'Can I export my data?',
      'answer':
          'Yes! Go to Settings > Data & Privacy > Export Data to download your financial information.',
    },
    {
      'question': 'Is my data secure?',
      'answer':
          'Absolutely. All your data is stored locally on your device and encrypted. We never share your personal financial information.',
    },
    {
      'question': 'How do I delete a transaction?',
      'answer':
          'Swipe left on any transaction in the Home screen or tap the delete icon. You can undo the deletion immediately if needed.',
    },
    {
      'question': 'What is the AI chat feature?',
      'answer':
          'The AI chat allows you to ask questions about your finances and get instant, personalized advice based on your transaction history.',
    },
    {
      'question': 'How do I change the theme?',
      'answer':
          'Go to Settings > Appearance to toggle dark mode, enable system theme, or choose your preferred accent color.',
    },
  ];

  // Accent Colors
  static const List<Map<String, dynamic>> accentColors = [
    {'name': 'Purple', 'value': 0xFF6C63FF},
    {'name': 'Blue', 'value': 0xFF2196F3},
    {'name': 'Green', 'value': 0xFF4CAF50},
    {'name': 'Orange', 'value': 0xFFFF9800},
    {'name': 'Pink', 'value': 0xFFE91E63},
    {'name': 'Teal', 'value': 0xFF009688},
  ];
}
