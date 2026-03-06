import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  double _totalIncome = 0;
  double _totalExpense = 0;
  Map<String, double> _categoryData = {};

  @override
  void initState() {
    super.initState();
    _calculateStats();
  }

  void _calculateStats() {
    final storage = ref.read(storageServiceProvider);
    final txs = storage.getTransactions();

    double income = 0;
    double expense = 0;
    final Map<String, double> cats = {};

    for (var t in txs) {
      final amount = t['amount'] as double;
      final type = t['type']; // 'income' or 'expense'
      final category = t['category'] ?? 'Other';

      if (type == 'income') {
        income += amount;
      } else {
        expense += amount;
        cats[category] = (cats[category] ?? 0) + amount;
      }
    }

    setState(() {
      _totalIncome = income;
      _totalExpense = expense;
      _categoryData = cats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final netSavings = _totalIncome - _totalExpense;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // OVERVIEW CARDS
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    "Income",
                    _totalIncome,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    "Expense",
                    _totalExpense,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              "Net Savings",
              netSavings,
              Colors.blueAccent,
              isWide: true,
            ),

            const SizedBox(height: 32),

            // CHART SECTION
            Text(
              "Expense Breakdown",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            if (_categoryData.isEmpty && _totalExpense == 0)
              const SizedBox(
                height: 200,
                child: Center(child: Text("No expense data yet.")),
              )
            else
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: _getSections(),
                    centerSpaceRadius: 50,
                    sectionsSpace: 2,
                  ),
                ),
              ),

            const SizedBox(height: 20),
            // LEGEND
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: _categoryData.keys.map((cat) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: _getColorForCategory(cat),
                    ),
                    const SizedBox(width: 4),
                    Text(cat),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    Color color, {
    bool isWide = false,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: isWide ? double.infinity : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "\$${amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    return _categoryData.entries.map((e) {
      final percentage = (e.value / _totalExpense) * 100;
      return PieChartSectionData(
        color: _getColorForCategory(e.key),
        value: e.value,
        title: '${percentage.toInt()}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getColorForCategory(String category) {
    // Deterministic color generation
    final hash = category.hashCode;
    return Colors.primaries[hash % Colors.primaries.length];
  }
}
