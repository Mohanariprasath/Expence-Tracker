import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:my_app/data/models/transaction_model.dart';
import 'package:my_app/data/models/goal_model.dart';
import 'package:intl/intl.dart';
import 'package:my_app/core/utils/currency_utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static String get _apiKey {
    try {
      if (!dotenv.isInitialized) return 'YOUR_GEMINI_API_KEY_HERE';
      return dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_GEMINI_API_KEY_HERE';
    } catch (_) {
      return 'YOUR_GEMINI_API_KEY_HERE';
    }
  }

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
  }

  bool get _hasValidKey =>
      _apiKey.isNotEmpty && !_apiKey.contains('YOUR_GEMINI_API_KEY');

  Future<String> generateFinancialTip(List<Transaction> transactions) async {
    if (!_hasValidKey) {
      return "AI features are disabled. Please configure the internal API key.";
    }

    if (transactions.isEmpty) {
      return "Start consistent tracking to get personalized AI tips!";
    }

    // Prepare context
    final recent = transactions
        .take(5)
        .map(
          (t) =>
              "${t.title}: ${CurrencyUtils.format(t.amount)} (${t.type.name})",
        )
        .join(", ");
    final userPrompt =
        "Based on these recent transactions: $recent. Give me one short, actionable financial tip (max 2 sentences). Tone: Friendly and motivating.";

    try {
      final content = [Content.text(userPrompt)];
      final response = await _model.generateContent(content);
      return response.text ??
          "Keep tracking your expenses to stay on top of your finances!";
    } catch (e) {
      return "Tip: Tracking every expense is the first step to financial freedom.";
    }
  }

  Future<String> generateMonthlyReport(List<Transaction> transactions) async {
    if (!_hasValidKey) {
      return "AI features are disabled. Setup API key in source code.";
    }
    final expenseTotal = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final incomeTotal = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final prompt =
        """
    Analyze these financial stats:
    Total Income: ${CurrencyUtils.format(incomeTotal)}
    Total Expenses: ${CurrencyUtils.format(expenseTotal)}
    Transactions: ${transactions.length}
    
    Generate a detailed monthly report nicely formatted in Markdown.
    Include:
    1. Overall Health Check
    2. Spending Habits Analysis
    3. Areas for Improvement
    4. Savings Suggestion
    
    Keep it professional but encouraging.
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "Could not generate report.";
    } catch (e) {
      return "Error generating report. Please check internet connection.";
    }
  }

  Future<String> generateGoalPlan(Goal goal) async {
    if (!_hasValidKey) {
      return "AI Plan disabled. Setup API key in source code.";
    }
    final prompt =
        """
    I have a financial goal: ${goal.title}
    Target Amount: ${CurrencyUtils.format(goal.targetAmount)}
    Current Amount: ${CurrencyUtils.format(goal.currentAmount)}
    Deadline: ${DateFormat('yyyy-MM-dd').format(goal.deadline)}
    
    Create a step-by-step plan to achieve this. 
    Break it down into weekly or monthly saving targets.
    Give specific advice on how to save for this specific type of goal.
    Formatted in Markdown.
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "Plan generation failed.";
    } catch (e) {
      return "Error generating plan.";
    }
  }

  Stream<String> chatStream(
    String message, {
    List<Transaction>? contextData,
  }) async* {
    if (!_hasValidKey) {
      yield "AI Chat disabled. Please configure the internal API key.";
      return;
    }

    String contextStr = "";
    if (contextData != null && contextData.isNotEmpty) {
      contextStr =
          "My recent transaction context: ${contextData.map((t) => "${t.title} ${CurrencyUtils.format(t.amount)}").join(", ")}";
    }

    final prompt =
        "User: $message\n$contextStr\nSystem: You are Antigravity, a helpful financial assistant. Be concise and friendly.";

    try {
      final content = [Content.text(prompt)];
      final stream = _model.generateContentStream(content);
      await for (final chunk in stream) {
        if (chunk.text != null) yield chunk.text!;
      }
    } catch (e) {
      yield "I'm having trouble connecting to Gemini. Please check internet connection.";
    }
  }
}
