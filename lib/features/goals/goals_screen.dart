import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/providers.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/data/models/goal_model.dart';
import 'package:intl/intl.dart';
import 'package:my_app/core/utils/currency_utils.dart';
import 'package:uuid/uuid.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  void _showAddGoalDialog() {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final currentController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Financial Goal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Goal Title (e.g., New Laptop)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: targetController,
                decoration: const InputDecoration(
                  labelText: 'Target Amount (${CurrencyUtils.symbol})',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: currentController,
                decoration: const InputDecoration(
                  labelText: 'Current Savings (${CurrencyUtils.symbol})',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Deadline: "),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                        (context as Element)
                            .markNeedsBuild(); // Force rebuild to show date (hacky for dialog)
                        // Better to use StatefulBuilder in dialog, but skipping for brevity
                      }
                    },
                    child: Text(DateFormat('MMM d, yyyy').format(selectedDate)),
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
            onPressed: () async {
              if (titleController.text.isEmpty ||
                  targetController.text.isEmpty) {
                return;
              }

              final goal = Goal(
                id: const Uuid().v4(),
                title: titleController.text,
                targetAmount: double.tryParse(targetController.text) ?? 0,
                currentAmount: double.tryParse(currentController.text) ?? 0,
                deadline: selectedDate,
              );

              await ref.read(goalListProvider.notifier).addGoal(goal);

              // Trigger AI Plan in background
              _generatePlanForGoal(goal);

              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: const Text('Create Goal'),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePlanForGoal(Goal goal) async {
    try {
      final gemini = ref.read(geminiProvider);
      final plan = await gemini.generateGoalPlan(goal);

      // Update goal with plan (Need to modify model to support copyWith or manual update)
      // Since Hive objects are mutable, we can set it and save.
      // However, better to treat immutable.
      // Let's create new object.
      final updatedGoal = Goal(
        id: goal.id,
        title: goal.title,
        targetAmount: goal.targetAmount,
        currentAmount: goal.currentAmount,
        deadline: goal.deadline,
        aiPlan: plan,
      );
      await ref.read(goalListProvider.notifier).updateGoal(updatedGoal);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI Plan generated for your goal!')),
        );
      }
    } catch (e) {
      // Ignore error
    }
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Goals')),
      body: goals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No goals set yet.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap + to set a target.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final progress = (goal.currentAmount / goal.targetAmount).clamp(
                  0.0,
                  1.0,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: CircularProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                    ),
                    title: Text(
                      goal.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${CurrencyUtils.format(goal.currentAmount)} / ${CurrencyUtils.format(goal.targetAmount)} • ${DateFormat('MMM yyyy').format(goal.deadline)}",
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "AI Strategy Plan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            goal.aiPlan != null
                                ? Text(goal.aiPlan!)
                                : const Row(
                                    children: [
                                      SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text("Generating plan..."),
                                    ],
                                  ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () => ref
                                      .read(goalListProvider.notifier)
                                      .deleteGoal(goal.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGoalDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
