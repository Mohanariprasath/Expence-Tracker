import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/core/constants/hive_constants.dart';
import 'package:my_app/data/models/transaction_model.dart';
import 'package:my_app/data/models/goal_model.dart';

class StorageService {
  late Box<Transaction> _transactionBox;
  late Box<Goal> _goalBox;
  late Box _settingsBox;

  Future<void> init() async {
    _transactionBox = await Hive.openBox<Transaction>(
      HiveConstants.transactionBox,
    );
    _goalBox = await Hive.openBox<Goal>(HiveConstants.goalBox);
    _settingsBox = await Hive.openBox(HiveConstants.settingsBox);
  }

  // Transactions
  List<Transaction> getTransactions() {
    return _transactionBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  // Goals
  List<Goal> getGoals() {
    return _goalBox.values.toList();
  }

  Future<void> saveGoal(Goal goal) async {
    await _goalBox.put(goal.id, goal);
  }

  Future<void> deleteGoal(String id) async {
    await _goalBox.delete(id);
  }

  // Settings
  String? getApiKey() {
    return _settingsBox.get(HiveConstants.apiKey);
  }

  Future<void> saveApiKey(String key) async {
    await _settingsBox.put(HiveConstants.apiKey, key);
  }

  bool getIsDarkMode() {
    return _settingsBox.get(
      HiveConstants.themeMode,
      defaultValue: true,
    ); // Default dark
  }

  Future<void> saveThemeMode(bool isDark) async {
    await _settingsBox.put(HiveConstants.themeMode, isDark);
  }
}
