import '../../../core/models/goal.dart';
import '../../../core/models/transaction.dart';

class AntigravityService {
  // 1. HOME SCREEN SMART TIP
  String getHomeTip(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return "💡  Start tracking your expenses today to get personalized insights!";
    }

    // Mock logic: check if there are many dining out expenses
    final diningExpenses = transactions
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.category.toLowerCase().contains('food'),
        )
        .toList();

    if (diningExpenses.length > 3) {
      return "💡 You’ve dined out frequently this week. classic home-cooking could save you ~\$50!";
    }

    return "💡 Small daily savings add up. Try the 50/30/20 rule to balance your budget.";
  }

  // 2. DETAILED MONTHLY FINANCIAL REPORT
  String getMonthlyReport(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return "No data available for a report yet.";
    }

    double totalIncome = 0;
    double totalExpense = 0;
    final Map<String, double> categoryBreakdown = {};

    for (var t in transactions) {
      if (t.type == TransactionType.income) {
        totalIncome += t.amount;
      } else {
        totalExpense += t.amount;
        categoryBreakdown[t.category] =
            (categoryBreakdown[t.category] ?? 0) + t.amount;
      }
    }

    // Sort categories
    final sortedCategories = categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategory = sortedCategories.isNotEmpty
        ? sortedCategories.first
        : null;

    return """
# 📊 Monthly Financial Report

**Overview**
*   **Total Income:** \$${totalIncome.toStringAsFixed(2)}
*   **Total Expenses:** \$${totalExpense.toStringAsFixed(2)}
*   **Net Savings:** \$${(totalIncome - totalExpense).toStringAsFixed(2)}

**Top Spending**
*   🚨 **Highest Category:** ${topCategory?.key ?? 'N/A'} (\$${topCategory?.value.toStringAsFixed(2) ?? '0'})

**Antigravity Insights**
*   **Observation:** ${totalExpense > totalIncome ? 'Spending exceeded income this period.' : 'Good job keeping expenses below income.'}
*   **Improvement:** Consider setting a limit for '${topCategory?.key ?? 'discretionary'}' spending next month.
*   **Habit:** Regular tracking is key! Keep it up.
""";
  }

  // 3. GOAL-BASED FINANCIAL PLAN
  String getGoalPlan(FinancialGoal goal) {
    final remaining = goal.targetAmount - goal.currentAmount;
    final daysRemaining = goal.targetDate.difference(DateTime.now()).inDays;
    final monthsRemaining = (daysRemaining / 30).ceil();
    final monthlySave = monthsRemaining > 0
        ? remaining / monthsRemaining
        : remaining;

    return """
# 🎯 Plan: ${goal.title}

**Goal Summary**
*   **Target:** \$${goal.targetAmount.toStringAsFixed(2)}
*   **Remaining:** \$${remaining.toStringAsFixed(2)}
*   **Timeline:** $monthsRemaining months

**Action Plan 🗓️**
*   **Monthly Save:** ~\$${monthlySave.toStringAsFixed(2)}
*   **Strategy:** Automate this transfer on payday.

**Antigravity Advice**
*   💡 *Optimization:* Audit your subscriptions to find extra cash.
*   🛡️ *Risk Check:* Ensure you still have an emergency fund.
*   ✨ *Motivation:* Visualize the result! You are on track.
""";
  }

  // 4. CHAT MODE BEHAVIOR
  String chat(String message) {
    final lowerMsg = message.toLowerCase();

    if (lowerMsg.contains('hello') || lowerMsg.contains('hi')) {
      return "Hello! I'm Antigravity, your financial assistant. How can I help you lift your finances today?";
    }

    if (lowerMsg.contains('save') || lowerMsg.contains('saving')) {
      return "Saving is a Marathon, not a sprint. Try automating a small amount to a separate account every week.";
    }

    if (lowerMsg.contains('invest')) {
      return "I can't give specific investment advice, but diversifying your portfolio is generally a good risk management strategy.";
    }

    if (lowerMsg.contains('debt')) {
      return "Tackling debt? Consider the 'Snowball' method (smallest debts first) or 'Avalanche' method (highest interest first).";
    }

    return "I'm here to help with your finances. You can ask me for a 'Monthly Report' or help with a 'Goal Plan'.";
  }
}
