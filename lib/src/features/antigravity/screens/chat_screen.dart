import 'package:flutter/material.dart';
import '../services/antigravity_service.dart';
import '../../../core/models/transaction.dart';
import '../../../core/models/goal.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages =
      []; // {'sender': 'user'/'bot', 'text': '...'}
  final AntigravityService _aiService = AntigravityService();

  // Mock data for reports
  final List<Transaction> _mockTransactions = [
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
      date: DateTime.now(),
      category: 'Salary',
      type: TransactionType.income,
    ),
    Transaction(
      id: '3',
      title: 'Rent',
      amount: 1200.00,
      date: DateTime.now(),
      category: 'Housing',
      type: TransactionType.expense,
    ),
    Transaction(
      id: '4',
      title: 'Restaurant',
      amount: 60.00,
      date: DateTime.now(),
      category: 'Food',
      type: TransactionType.expense,
    ),
  ];

  final FinancialGoal _mockGoal = FinancialGoal(
    id: '1',
    title: 'New Car',
    targetAmount: 20000,
    currentAmount: 5000,
    targetDate: DateTime.now().add(const Duration(days: 365 * 2)),
  );

  @override
  void initState() {
    super.initState();
    // Initial greeting
    _addMessage(
      'bot',
      "Hello! I'm Antigravity. Ask me about your finances, or for a 'Monthly Report'.",
    );
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    final userText = _controller.text;
    _addMessage('user', userText);
    _controller.clear();

    // Simulate AI thinking delay
    Future.delayed(const Duration(milliseconds: 600), () {
      String response;
      final lower = userText.toLowerCase();

      // Simple dispatcher for the mock service
      if (lower.contains('report')) {
        response = _aiService.getMonthlyReport(_mockTransactions);
      } else if (lower.contains('plan') || lower.contains('goal')) {
        response = _aiService.getGoalPlan(_mockGoal);
      } else {
        response = _aiService.chat(userText);
      }

      _addMessage('bot', response);
    });
  }

  void _addMessage(String sender, String text) {
    setState(() {
      _messages.add({'sender': sender, 'text': text});
    });
    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antigravity Assistant'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepPurple : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12).copyWith(
                        bottomRight: isUser
                            ? Radius.zero
                            : const Radius.circular(12),
                        bottomLeft: isUser
                            ? const Radius.circular(12)
                            : Radius.zero,
                      ),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask Antigravity...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _sendMessage,
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
