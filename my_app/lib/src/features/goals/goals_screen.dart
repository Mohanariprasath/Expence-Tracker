import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/ai_service.dart';
import 'package:uuid/uuid.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  List<dynamic> _goals = [];

  @override
  void initState() {
    super.initState();
    _refreshGoals();
  }

  void _refreshGoals() {
    final storage = ref.read(storageServiceProvider);
    setState(() {
      _goals = storage.getGoals();
    });
  }

  void _addGoal() async {
    // Quick dialog to add goal
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Goal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Goal Name"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Target Amount"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () async {
              final storage = ref.read(storageServiceProvider);
              final newGoal = {
                'id': const Uuid().v4(),
                'title': titleController.text,
                'target': double.tryParse(amountController.text) ?? 0,
                'current': 0.0,
                'deadline': DateTime.now()
                    .add(const Duration(days: 30))
                    .toIso8601String(),
              };
              await storage.addGoal(newGoal);
              if (context.mounted) Navigator.pop(context);
              _refreshGoals();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _generatePlan(dynamic goal) async {
    final ai = ref.read(aiServiceProvider);

    // Show AI loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Simulate AI call (or real if implemented)
    // We reuse the prompt logic potentially
    String plan;
    if (ai.hasKey) {
      // Here we would call a specific method `ai.generateGoalPlan(goal)` using chatStream or similar.
      // For now using a mock response or chat stream.
      // Let's assume we want to guide them to Chat.
      plan =
          "Goal Plan generated! Go to the Chat tab and ask 'Help me plan for ${goal['title']}' to get a detailed breakdown.";
    } else {
      plan = "Please add your API Key in Settings to generate a plan.";
    }

    if (mounted) {
      Navigator.pop(context); // Close loader
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Antigravity Plan"),
          content: Text(plan),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Financial Goals")),
      body: _goals.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 60,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No goals set yet.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                final goal = _goals[index];
                final double progress =
                    (goal['current'] /
                            (goal['target'] == 0 ? 1 : goal['target']))
                        .clamp(0.0, 1.0);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              goal['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.auto_awesome),
                              onPressed: () => _generatePlan(goal),
                              tooltip: 'Generate AI Plan',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("\$${goal['current']}"),
                            Text(
                              "\$${goal['target']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
