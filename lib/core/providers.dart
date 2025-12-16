import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/services/gemini_service.dart';
import 'package:my_app/data/local/storage_service.dart';
import 'package:my_app/data/models/goal_model.dart';
import 'package:my_app/data/models/transaction_model.dart';

// Initialized in main.dart
final storageProvider = Provider<StorageService>(
  (ref) => throw UnimplementedError(),
);

final geminiProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

final themeModeProvider = StateProvider<bool>((ref) {
  final storage = ref.watch(storageProvider);
  return storage.getIsDarkMode();
});

// System theme toggle - if true, use system theme instead of manual dark mode
final useSystemThemeProvider = StateProvider<bool>((ref) {
  final storage = ref.watch(storageProvider);
  return storage.getUseSystemTheme();
});

// Accent color provider - stores color value as int
final accentColorProvider = StateProvider<int>((ref) {
  final storage = ref.watch(storageProvider);
  return storage.getAccentColor();
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

  Future<void> deleteTransactions(List<String> ids) async {
    await _storage.transactionBox.deleteAll(ids);
    load();
  }

  Future<void> addTransactions(List<Transaction> transactions) async {
    final Map<dynamic, Transaction> entries = {
      for (var t in transactions) t.id: t,
    };
    await _storage.transactionBox.putAll(entries);
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
