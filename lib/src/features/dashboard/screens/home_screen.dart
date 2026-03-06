import 'package:flutter/material.dart';
import '../../antigravity/services/antigravity_service.dart';
import '../../../core/models/transaction.dart';
import '../../antigravity/screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AntigravityService _aiService = AntigravityService();

  // Dummy data
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Grocery Store',
      amount: 45.50,
      date: DateTime.now(),
      category: 'Food',
      type: TransactionType.expense,
    ),
    Transaction(
      id: '2',
      title: 'Salary',
      amount: 3000.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Salary',
      type: TransactionType.income,
    ),
    Transaction(
      id: '3',
      title: 'Coffee Shop',
      amount: 5.40,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Food',
      type: TransactionType.expense,
    ),
    Transaction(
      id: '4',
      title: 'Restaurant',
      amount: 60.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Food',
      type: TransactionType.expense,
    ),
    Transaction(
      id: '5',
      title: 'Restaurant',
      amount: 80.00,
      date: DateTime.now().subtract(const Duration(days: 4)),
      category: 'Food',
      type: TransactionType.expense,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final smartTip = _aiService.getHomeTip(_transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Smart Tip Card
            Card(
              color: Colors.deepPurple.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.deepPurple),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        smartTip,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Balance Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Total Balance",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$2,809.10",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ..._transactions.map(
              (t) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: t.type == TransactionType.income
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  child: Icon(
                    t.type == TransactionType.income
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: t.type == TransactionType.income
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                title: Text(t.title),
                subtitle: Text(t.category),
                trailing: Text(
                  "${t.type == TransactionType.income ? '+' : '-'}\$${t.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: t.type == TransactionType.income
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
