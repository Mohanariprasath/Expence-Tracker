import 'package:my_app/data/models/transaction_model.dart';

class ChartUtils {
  /// Groups transactions by day for the current week (Mon-Sun).
  /// Returns a map of weekday index (1=Mon, 7=Sun) to total amount.
  static Map<int, double> getWeeklyData(
    List<Transaction> transactions,
    TransactionType type,
  ) {
    final now = DateTime.now();
    // Find start of week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final Map<int, double> weeklyData = {
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0,
    };

    for (var t in transactions) {
      if (t.type == type) {
        // Check if within current week (ignoring time)
        if (t.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            t.date.isBefore(endOfWeek.add(const Duration(days: 1)))) {
          weeklyData[t.date.weekday] =
              (weeklyData[t.date.weekday] ?? 0) + t.amount;
        }
      }
    }
    return weeklyData;
  }

  /// Groups transactions by category.
  static Map<String, double> getCategoryData(
    List<Transaction> transactions,
    TransactionType type,
  ) {
    final Map<String, double> data = {};
    for (var t in transactions) {
      if (t.type == type) {
        data[t.category] = (data[t.category] ?? 0) + t.amount;
      }
    }
    return data;
  }
}
