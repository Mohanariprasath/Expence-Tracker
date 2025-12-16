import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:my_app/data/models/transaction_model.dart';
import 'package:my_app/data/models/goal_model.dart';
import 'package:intl/intl.dart';
import 'package:my_app/core/utils/currency_utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static String get _apiKey {
    try {
      if (!dotenv.isInitialized) return '';
      return dotenv.env['GEMINI_API_KEY'] ?? '';
    } catch (_) {
      return '';
    }
  }

  late final GenerativeModel? _model;

  GeminiService() {
    if (_hasValidKey) {
      _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
    } else {
      _model = null;
    }
  }

  bool get _hasValidKey =>
      _apiKey.isNotEmpty && !_apiKey.contains('YOUR_GEMINI_API_KEY');

  Future<String> generateFinancialTip(List<Transaction> transactions) async {
    // 1. Try AI Generation
    if (_hasValidKey && _model != null) {
      try {
        if (transactions.isEmpty) {
          return "Start consistent tracking to get personalized AI tips!";
        }

        final recent = transactions
            .take(5)
            .map(
              (t) =>
                  "${t.title}: ${CurrencyUtils.format(t.amount)} (${t.type.name})",
            )
            .join(", ");
        final userPrompt =
            "Based on these recent transactions: $recent. Give me one short, actionable financial tip (max 2 sentences). Tone: Friendly and motivating.";

        final content = [Content.text(userPrompt)];
        final response = await _model.generateContent(content);
        if (response.text != null && response.text!.isNotEmpty) {
          return response.text!;
        }
      } catch (e) {
        // Fallthrough to local fallback silently
      }
    }

    // 2. Local Fallback
    return _generateLocalTip(transactions);
  }

  String _generateLocalTip(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return "Start consistent tracking to get personalized insights!";
    }

    final expenses = transactions.where(
      (t) => t.type == TransactionType.expense,
    );
    final income = transactions.where((t) => t.type == TransactionType.income);

    if (expenses.isEmpty) {
      return "Great start! Try adding your daily expenses to track your spending habits.";
    }

    final totalExpense = expenses.fold(0.0, (sum, t) => sum + t.amount);
    final totalIncome = income.fold(0.0, (sum, t) => sum + t.amount);

    if (totalIncome > 0 && totalExpense > totalIncome) {
      return "Notice: Your expenses are higher than income. Consider reviewing your recent purchases.";
    } else if (totalIncome > 0 && totalExpense < totalIncome * 0.5) {
      return "Excellent! You're saving more than 50% of your income. Keep it up!";
    } else {
      return "Tip: Review your recurring subscriptions to find potential savings.";
    }
  }

  Future<String> generateMonthlyReport(List<Transaction> transactions) async {
    if (_hasValidKey && _model != null) {
      try {
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

        final content = [Content.text(prompt)];
        final response = await _model.generateContent(content);
        if (response.text != null && response.text!.isNotEmpty) {
          return response.text!;
        }
      } catch (e) {
        // Fallthrough
      }
    }

    return _generateLocalReport(transactions);
  }

  String _generateLocalReport(List<Transaction> transactions) {
    final expenseTotal = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final incomeTotal = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final balance = incomeTotal - expenseTotal;

    return """
# Monthly Report

## Overall Health Check
You have recorded **${transactions.length} transactions** this month.
*   **Total Income:** ${CurrencyUtils.format(incomeTotal)}
*   **Total Expenses:** ${CurrencyUtils.format(expenseTotal)}
*   **Net Balance:** ${CurrencyUtils.format(balance)}

## Quick Analysis
${balance >= 0 ? "You are currently positive cash flow. Good job!" : "Your expenses exceeded your income. Try to cut back on non-essentials."}

## Suggestion
Continue tracking every penny to identify more patterns.
""";
  }

  Future<String> generateGoalPlan(Goal goal) async {
    if (_hasValidKey && _model != null) {
      try {
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

        final content = [Content.text(prompt)];
        final response = await _model.generateContent(content);
        if (response.text != null && response.text!.isNotEmpty) {
          return response.text!;
        }
      } catch (e) {
        // Fallthrough
      }
    }

    return _generateLocalPlan(goal);
  }

  String _generateLocalPlan(Goal goal) {
    final remaining = goal.targetAmount - goal.currentAmount;
    final daysLeft = goal.deadline.difference(DateTime.now()).inDays;
    final weeksLeft = (daysLeft / 7).ceil();
    final monthlySave = weeksLeft > 0 ? remaining / (weeksLeft / 4) : remaining;

    return """
# Plan for ${goal.title}

## Goal Overview
*   **Target:** ${CurrencyUtils.format(goal.targetAmount)}
*   **Remaining:** ${CurrencyUtils.format(remaining)}
*   **Time Left:** $weeksLeft weeks

## Strategy
To reach your goal by ${DateFormat('MMM d, yyyy').format(goal.deadline)}, you should aim to save approximately:

*   **${CurrencyUtils.format(remaining / weeksLeft)} per week**
*   **${CurrencyUtils.format(monthlySave)} per month**

## Tips
1.  Automate your savings if possible.
2.  Review your budget to find extra cash.
""";
  }

  Stream<String> chatStream(
    String message, {
    List<Transaction>? contextData,
  }) async* {
    if (_hasValidKey && _model != null) {
      try {
        String contextStr = "";
        if (contextData != null && contextData.isNotEmpty) {
          contextStr =
              "My recent transaction context: ${contextData.map((t) => "${t.title} ${CurrencyUtils.format(t.amount)}").join(", ")}";
        }

        final prompt =
            "User: $message\n$contextStr\nSystem: You are Antigravity, a helpful financial assistant. Be concise and friendly.";

        final content = [Content.text(prompt)];
        final stream = _model.generateContentStream(content);
        await for (final chunk in stream) {
          if (chunk.text != null) yield chunk.text!;
        }
        return;
      } catch (e) {
        // Fallthrough
      }
    }

    yield "I'm currently in offline mode. Here's a general tip: Saving small amounts consistently adds up over time!";
  }
}
