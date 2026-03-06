import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/providers.dart';
import 'package:my_app/data/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:my_app/core/utils/currency_utils.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showAddTransactionDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    TransactionType selectedType = TransactionType.expense;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Transaction'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title (e.g. Groceries)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount (${CurrencyUtils.symbol})',
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Type Selector
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Type',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).dividerColor.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(
                                        () => selectedType =
                                            TransactionType.expense,
                                      ),
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                            left: Radius.circular(11),
                                          ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              selectedType ==
                                                  TransactionType.expense
                                              ? Theme.of(context)
                                                    .colorScheme
                                                    .error
                                                    .withValues(alpha: 0.15)
                                              : Colors.transparent,
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                                left: Radius.circular(11),
                                              ),
                                          border:
                                              selectedType ==
                                                  TransactionType.expense
                                              ? Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error
                                                      .withValues(alpha: 0.5),
                                                  width: 1,
                                                )
                                              : null,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Expense',
                                          style: TextStyle(
                                            color:
                                                selectedType ==
                                                    TransactionType.expense
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.error
                                                : Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                            fontWeight:
                                                selectedType ==
                                                    TransactionType.expense
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    color: Theme.of(
                                      context,
                                    ).dividerColor.withValues(alpha: 0.2),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => setState(
                                        () => selectedType =
                                            TransactionType.income,
                                      ),
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                            right: Radius.circular(11),
                                          ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              selectedType ==
                                                  TransactionType.income
                                              ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.15)
                                              : Colors.transparent,
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                                right: Radius.circular(11),
                                              ),
                                          border:
                                              selectedType ==
                                                  TransactionType.income
                                              ? Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.5),
                                                  width: 1,
                                                )
                                              : null,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Income',
                                          style: TextStyle(
                                            color:
                                                selectedType ==
                                                    TransactionType.income
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.primary
                                                : Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                            fontWeight:
                                                selectedType ==
                                                    TransactionType.income
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Date Selector
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() => selectedDate = picked);
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 52,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).dividerColor.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 18,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat(
                                        'MMM d,yy',
                                      ).format(selectedDate),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      amountController.text.isEmpty) {
                    return;
                  }

                  final transaction = Transaction(
                    id: const Uuid().v4(),
                    title: titleController.text,
                    amount: double.tryParse(amountController.text) ?? 0,
                    date: selectedDate,
                    category: 'General', // Default for now
                    type: selectedType,
                  );

                  ref
                      .read(transactionListProvider.notifier)
                      .addTransaction(transaction);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    if (value == 'clear_month') {
      final transactions = ref.read(transactionListProvider);
      final now = DateTime.now();
      final monthlyTransactions = transactions
          .where((t) => t.date.year == now.year && t.date.month == now.month)
          .toList();

      if (monthlyTransactions.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No data found for this month.')),
          );
        }
        return;
      }

      // Confirmation Dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clear Monthly Data?'),
          content: Text(
            'This will delete ${monthlyTransactions.length} transactions for ${DateFormat('MMMM').format(now)}. This action cannot be undone immediately (use Undo below).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete All'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // Perform Delete
        final ids = monthlyTransactions.map((t) => t.id).toList();
        await ref
            .read(transactionListProvider.notifier)
            .deleteTransactions(ids);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cleared ${monthlyTransactions.length} entries'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () async {
                  // Restore
                  await ref
                      .read(transactionListProvider.notifier)
                      .addTransactions(monthlyTransactions);
                },
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionListProvider);
    final gemini = ref.read(openAIProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            Text('Antigravity', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'clear_month',
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Clear Monthly Data'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI Tip Card
              FutureBuilder<String>(
                future: gemini.generateFinancialTip(transactions),
                builder: (context, snapshot) {
                  return Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "AI Smart Tip",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: snapshot.hasData
                                ? Text(
                                    snapshot.data!,
                                    key: ValueKey(snapshot.data),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      height: 1.4,
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 200,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("View All")),
                ],
              ),
              const SizedBox(height: 8),
              if (transactions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No transactions yet",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Tap + to add your first expense!",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.take(5).length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final t = transactions[index];
                    return Dismissible(
                      key: Key(t.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        // Show confirmation dialog
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Transaction?'),
                            content: Text(
                              'Are you sure you want to delete "${t.title}"?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) async {
                        // Store transaction for undo
                        final deletedTransaction = t;

                        // Delete from storage
                        await ref
                            .read(transactionListProvider.notifier)
                            .deleteTransaction(t.id);

                        // Show snackbar with undo
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deleted "${t.title}"'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () async {
                                  // Restore transaction
                                  await ref
                                      .read(transactionListProvider.notifier)
                                      .addTransaction(deletedTransaction);
                                },
                              ),
                              duration: const Duration(seconds: 4),
                            ),
                          );
                        }
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: t.type.name == 'income'
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            child: Icon(
                              t.type.name == 'income'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: t.type.name == 'income'
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            t.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(DateFormat('MMM d').format(t.date)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${t.type.name == 'income' ? '+' : '-'}${CurrencyUtils.format(t.amount)}",
                                style: TextStyle(
                                  color: t.type.name == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                iconSize: 20,
                                color: Colors.red,
                                onPressed: () async {
                                  // Show confirmation dialog
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Transaction?'),
                                      content: Text(
                                        'Are you sure you want to delete "${t.title}"?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmed == true && context.mounted) {
                                    // Store for undo
                                    final deletedTransaction = t;

                                    // Delete
                                    await ref
                                        .read(transactionListProvider.notifier)
                                        .deleteTransaction(t.id);

                                    // Show undo snackbar
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Deleted "${t.title}"'),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () async {
                                              await ref
                                                  .read(
                                                    transactionListProvider
                                                        .notifier,
                                                  )
                                                  .addTransaction(
                                                    deletedTransaction,
                                                  );
                                            },
                                          ),
                                          duration: const Duration(seconds: 4),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
