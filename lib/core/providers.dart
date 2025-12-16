import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/services/gemini_service.dart';
import 'package:my_app/data/local/storage_service.dart';
import 'package:my_app/data/models/goal_model.dart';
import 'package:my_app/data/models/transaction_model.dart';

// Initialized in main.dart
final storageProvider = Provider<StorageService>(
  (ref) => throw UnimplementedError(),
);

final apiKeyProvider = StateProvider<String>((ref) {
  final storage = ref.watch(storageProvider);
  return storage.getApiKey() ?? "";
});

final geminiProvider = Provider<GeminiService>((ref) {
  final apiKey = ref.watch(apiKeyProvider);
  return GeminiService(apiKey);
});

final themeModeProvider = StateProvider<bool>((ref) {
  final storage = ref.watch(storageProvider);
  return storage.getIsDarkMode();
});

final transactionsProvider = StreamProvider.autoDispose<List<Transaction>>((
  ref,
) async* {
  final storage = ref.watch(storageProvider);
  // Initial
  yield storage.getTransactions();
  // We can't easily stream from Hive box directly via this wrapper unless we expose listenable
  // For simplicity, we'll force refresh manually or use ValueListenable in UI
  // But a stream provider is nice.
  // Let's use standard StateNotifier for Transaction List management which is better for updates.
});

// Using StateNotifier for Transactions to handle CRUD + UI updates consistently
class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  final StorageService _storage;

  TransactionsNotifier(this._storage) : super([]) {
    load();
  }

  void load() {
    state = _storage.getTransactions();
  }

  Future<void> addTransaction(Transaction t) async {
    await _storage.saveTransaction(t);
    load(); // Refresh state
  }

  Future<void> deleteTransaction(String id) async {
    await _storage.deleteTransaction(id);
    load();
  }
}

final transactionListProvider =
    StateNotifierProvider<TransactionsNotifier, List<Transaction>>((ref) {
      return TransactionsNotifier(ref.watch(storageProvider));
    });

class GoalsNotifier extends StateNotifier<List<Goal>> {
  final StorageService _storage;

  GoalsNotifier(this._storage) : super([]) {
    load();
  }

  void load() {
    state = _storage.getGoals();
  }

  Future<void> addGoal(Goal g) async {
    await _storage.saveGoal(g);
    load();
  }

  Future<void> updateGoal(Goal g) async {
    await _storage.saveGoal(g);
    load();
  }

  Future<void> deleteGoal(String id) async {
    await _storage.deleteGoal(id);
    load();
  }
}

final goalListProvider = StateNotifierProvider<GoalsNotifier, List<Goal>>((
  ref,
) {
  return GoalsNotifier(ref.watch(storageProvider));
});
