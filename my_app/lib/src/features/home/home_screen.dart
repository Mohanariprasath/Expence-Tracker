import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/ai_service.dart';
import '../../core/services/storage_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Simple local state for transactions to trigger rebuilds,
  // normally would use a StreamProvider or StateNotifierProvider.
  List<dynamic> _transactions = [];
  String _smartTip = "✨ Analyzing your finances...";
  bool _isLoadingTip = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = ref.read(storageServiceProvider);
    final ai = ref.read(aiServiceProvider);

    // Load Transactions
    final txs = storage.getTransactions();
    // Sort by date desc
    txs.sort((a, b) => b['date'].compareTo(a['date']));

    if (mounted) {
      setState(() {
        _transactions = txs;
      });
    }

    // Load Tip
    // Only fetch if we have data or key
    if (ai.hasKey) {
      // Passing a subset to save tokens
      final subset = txs.take(10).toList();
      final tip = await ai.generateSmartTip(subset);
      if (mounted) {
        setState(() {
          _smartTip = tip;
          _isLoadingTip = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _smartTip = "💡 Add your API Key in Settings to get smart insights.";
          _isLoadingTip = false;
        });
      }
    }
  }

  Future<void> _addDummyTransaction() async {
    final storage = ref.read(storageServiceProvider);
    final newItem = {
      'id': const Uuid().v4(),
      'title': 'Test Expense',
      'amount': 25.0,
      'date': DateTime.now().toIso8601String(),
      'type': 'expense',
      'category': 'Food',
    };
    await storage.addTransaction(newItem);
    _loadData(); // Refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antigravity'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SMART TIP CARD
            _buildSmartTipCard(),
            const SizedBox(height: 24),

            // RECENT TRANSACTIONS HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(onPressed: () {}, child: const Text('See All')),
              ],
            ),
            const SizedBox(height: 8),

            // LIST
            if (_transactions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text("No transactions yet."),
                ),
              )
            else
              ..._transactions.map((t) => _buildTransactionTile(t)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addDummyTransaction,
        icon: const Icon(Icons.add),
        label: const Text('Add Test'),
      ),
    );
  }

  Widget _buildSmartTipCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.deepPurple.withValues(alpha: 0.3),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  "Smart Insight",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _isLoadingTip
                ? const LinearProgressIndicator()
                : Text(
                    _smartTip,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(dynamic t) {
    final bool isExpense = t['type'] == 'expense';
    final amount = t['amount'];
    final date = DateTime.parse(t['date']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isExpense
              ? Colors.red.shade50
              : Colors.green.shade50,
          child: Icon(
            isExpense ? Icons.arrow_outward : Icons.arrow_downward,
            color: isExpense ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          t['title'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(DateFormat.MMMd().format(date)),
        trailing: Text(
          "${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isExpense ? Colors.red : Colors.green,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
