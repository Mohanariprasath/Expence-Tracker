import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:my_app/core/utils/currency_utils.dart';
import 'package:my_app/data/models/goal_model.dart';
import 'package:my_app/data/models/transaction_model.dart';

class OpenAIService {
  bool _isApiKeySet = false;

  OpenAIService() {
    _init();
  }

  void _init() {
    try {
      if (!dotenv.isInitialized) {
        debugPrint(
          "OpenAIService: Warning - Dotenv not initialized during construction. Will retry lazy.",
        );
        return;
      }
      final key = dotenv.env['OPENAI_API_KEY'];
      if (key != null && key.isNotEmpty && !key.startsWith("your_")) {
        OpenAI.apiKey = key;
        _isApiKeySet = true;
        debugPrint("OpenAIService: API key configured successfully.");
      } else {
        debugPrint(
          "OpenAIService: Error - Invalid or missing OPENAI_API_KEY in .env",
        );
      }
    } catch (e) {
      debugPrint("OpenAIService: Unexpected error initializing: $e");
    }
  }

  // --- Network & Status Checks ---

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    // checkConnectivity returns a List<ConnectivityResult> in newer versions,
    // but depends on version. Assuming ^6.0.0 or similar based on recent 'add':
    // It actually returns List<ConnectivityResult> in v6+ but single in v5.
    // Let's support the likely v6+ behavior or standard handling.
    // Safe check: invalid is usually none.

    // Note: checkConnectivity() only checks network interface status, not actual internet.
    // But it's a good first filter.

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }

  bool get _canAttemptRequest => _isApiKeySet;

  // --- Features ---

  Future<String> generateFinancialTip(List<Transaction> transactions) async {
    if (!_canAttemptRequest) {
      debugPrint("OpenAIService: Request aborted - API Key not set.");
      return _generateLocalTip(transactions);
    }

    if (!await _hasInternetConnection()) {
      debugPrint("OpenAIService: No internet connection detected.");
      return _generateLocalTip(
        transactions,
      ); // Silent fallback for passive UI features
    }

    try {
      if (transactions.isEmpty) {
        return "Start tracking your expenses to get personalized AI tips!";
      }

      final recent = transactions
          .take(5)
          .map(
            (t) =>
                "${t.title}: ${CurrencyUtils.format(t.amount)} (${t.type.name})",
          )
          .join(", ");

      final systemPrompt =
          "You are a helpful financial assistant. Give one short, actionable financial tip (max 2 sentences) based on the user's recent transactions. Tone: Friendly and motivating.";
      final userPrompt = "Recent transactions: $recent";

      final completion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                systemPrompt,
              ),
            ],
            role: OpenAIChatMessageRole.system,
          ),
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                userPrompt,
              ),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );

      final content = completion.choices.firstOrNull?.message.content;
      if (content != null && content.isNotEmpty) {
        return content.first.text ?? _generateLocalTip(transactions);
      }
    } on RequestFailedException catch (e) {
      debugPrint(
        "OpenAIService: API Error (Tip) - ${e.message} (Status: ${e.statusCode})",
      );
      // Fallback
    } on SocketException {
      debugPrint("OpenAIService: Network Error (Tip) - Connection failed.");
    } catch (e) {
      debugPrint("OpenAIService: Unknown Error (Tip) - $e");
    }

    return _generateLocalTip(transactions);
  }

  Future<String> generateMonthlyReport(List<Transaction> transactions) async {
    if (!_canAttemptRequest) {
      return _generateLocalReport(transactions);
    }
    if (!await _hasInternetConnection()) {
      return _generateLocalReport(transactions);
    }

    try {
      final expenseTotal = transactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);
      final incomeTotal = transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);

      final prompt =
          """
        Analyze: Income ${CurrencyUtils.format(incomeTotal)}, Expenses ${CurrencyUtils.format(expenseTotal)}, Count ${transactions.length}.
        Generate a Markdown monthly report:
        1. Health Check
        2. Spending Habits
        3. Savings Suggestion
        Keep it professional but encouraging.
        """;

      final completion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "You are a financial analyst.",
              ),
            ],
            role: OpenAIChatMessageRole.system,
          ),
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );

      final content = completion.choices.firstOrNull?.message.content;
      if (content != null && content.isNotEmpty) {
        return content.first.text ?? _generateLocalReport(transactions);
      }
    } catch (e) {
      debugPrint("OpenAIService: Error (Report) - $e");
    }

    return _generateLocalReport(transactions);
  }

  Future<String> generateGoalPlan(Goal goal) async {
    if (!_canAttemptRequest) {
      return _generateLocalPlan(goal);
    }
    if (!await _hasInternetConnection()) {
      return _generateLocalPlan(goal);
    }

    try {
      final prompt =
          "Plan for goal '${goal.title}' (${CurrencyUtils.format(goal.targetAmount)}), currently ${CurrencyUtils.format(goal.currentAmount)}, due ${DateFormat('yyyy-MM-dd').format(goal.deadline)}. Give step-by-step saving plan.";

      final completion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "You are a financial planner.",
              ),
            ],
            role: OpenAIChatMessageRole.system,
          ),
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );

      final content = completion.choices.firstOrNull?.message.content;
      if (content != null && content.isNotEmpty) {
        return content.first.text ?? _generateLocalPlan(goal);
      }
    } catch (e) {
      debugPrint("OpenAIService: Error (Goal) - $e");
    }

    return _generateLocalPlan(goal);
  }

  Stream<String> chatStream(
    String message, {
    List<Transaction>? contextData,
  }) async* {
    if (!_canAttemptRequest) {
      debugPrint("OpenAIService: Chat aborted - No API Key.");
      yield "Service is currently unavailable (Missing API Key).";
      yield _generateLocalChatResponse(message);
      return;
    }

    if (!await _hasInternetConnection()) {
      yield "No internet connection detected.";
      yield _generateLocalChatResponse(message);
      return;
    }

    try {
      String contextStr = "";
      if (contextData != null && contextData.isNotEmpty) {
        contextStr =
            "Context: ${contextData.map((t) => "${t.title} ${CurrencyUtils.format(t.amount)}").join(", ")}";
      }

      final stream = OpenAI.instance.chat.createStream(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "You are Antigravity, a helpful financial assistant. $contextStr",
              ),
            ],
            role: OpenAIChatMessageRole.system,
          ),
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(message),
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );

      await for (final chunk in stream) {
        final content = chunk.choices.firstOrNull?.delta.content;
        if (content != null && content.isNotEmpty) {
          final text = content.first?.text;
          if (text != null) yield text;
        }
      }
    } on RequestFailedException catch (e) {
      debugPrint("OpenAIService: Chat API Error - ${e.message}");
      if (e.statusCode == 401) {
        yield "Error: API Key is invalid or expired.";
      } else if (e.statusCode == 429) {
        yield "Error: ID rate limit exceeded. Please try again later.";
      } else {
        yield "Error: Service reported ${e.message}";
      }
    } on SocketException {
      yield "Connection lost. Please check your internet.";
    } catch (e) {
      debugPrint("OpenAIService: Chat Unknown Error - $e");
      yield "An unexpected error occurred. Please try again.";
    }
  }

  // --- Local Fallbacks ---

  String _generateLocalChatResponse(String message) {
    if (message.toLowerCase().contains("save")) {
      return "Tip: Try the 50/30/20 rule.";
    }
    return "I'm in offline mode, but I'm still tracking for you!";
  }

  String _generateLocalTip(List<Transaction> transactions) {
    if (transactions.isEmpty) return "Track expenses to get insights!";
    return "Offline Tip: Check your subscriptions.";
  }

  String _generateLocalReport(List<Transaction> transactions) {
    final expenseTotal = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    return "You spent ${CurrencyUtils.format(expenseTotal)} (Offline Report).";
  }

  String _generateLocalPlan(Goal goal) {
    return "Save consistently to reach your target (Offline Plan).";
  }
}

// Extension removed as Dart 3 includes firstOrNull
