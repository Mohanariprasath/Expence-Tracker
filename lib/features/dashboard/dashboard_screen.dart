import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/providers.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/utils/chart_utils.dart';
import 'package:my_app/data/models/transaction_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionListProvider);
    final incomeTotal = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expenseTotal = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final balance = incomeTotal - expenseTotal;

    final weeklyIncome = ChartUtils.getWeeklyData(
      transactions,
      TransactionType.income,
    );
    final weeklyExpense = ChartUtils.getWeeklyData(
      transactions,
      TransactionType.expense,
    );
    final categoryExpense = ChartUtils.getCategoryData(
      transactions,
      TransactionType.expense,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSummaryCard(
                    "Total Balance",
                    balance,
                    AppColors.primary,
                  ),
                  _buildSummaryCard("Income", incomeTotal, AppColors.success),
                  _buildSummaryCard("Expenses", expenseTotal, AppColors.error),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bar Chart Section
            const Text(
              "Weekly Activity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: BarChart(
                BarChartData(
                  barGroups: _generateBarGroups(weeklyIncome, weeklyExpense),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, meta) =>
                            Text(_getWeekdayClick(val.toInt())),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Pie Chart Section
            const Text(
              "Expense Breakdown",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (categoryExpense.isEmpty)
              const Center(child: Text("No expenses to show."))
            else
              Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sections: _generatePieSections(categoryExpense),
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: categoryExpense.entries
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _getColorForCategory(e.key),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        e.key,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
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

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.8), color]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(
    Map<int, double> income,
    Map<int, double> expense,
  ) {
    return List.generate(7, (index) {
      final day = index + 1;
      return BarChartGroupData(
        x: day,
        barRods: [
          BarChartRodData(
            toY: income[day] ?? 0,
            color: AppColors.success,
            width: 8,
          ),
          BarChartRodData(
            toY: expense[day] ?? 0,
            color: AppColors.error,
            width: 8,
          ),
        ],
      );
    });
  }

  List<PieChartSectionData> _generatePieSections(Map<String, double> data) {
    final total = data.values.fold(0.0, (sum, v) => sum + v);
    return data.entries.map((e) {
      final percentage = (e.value / total) * 100;
      return PieChartSectionData(
        color: _getColorForCategory(e.key),
        value: e.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getColorForCategory(String category) {
    // Simple hash to color
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[category.hashCode % colors.length];
  }

  String _getWeekdayClick(int index) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    if (index >= 1 && index <= 7) return days[index - 1];
    return '';
  }
}
