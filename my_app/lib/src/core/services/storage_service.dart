import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Keys for boxes
const String kSettingsBox = 'settingsBox';
const String kTransactionsBox = 'transactionsBox';
const String kGoalsBox = 'goalsBox';

// Keys for values
const String kApiKey = 'geminiApiKey';
const String kThemeMode = 'themeMode';

class StorageService {
  late Box _settingsBox;
  late Box _transactionsBox;
  late Box _goalsBox;

  Future<void> init() async {
    await Hive.initFlutter();

    _settingsBox = await Hive.openBox(kSettingsBox);
    _transactionsBox = await Hive.openBox(kTransactionsBox);
    _goalsBox = await Hive.openBox(kGoalsBox);
  }

  // Settings
  Future<void> saveApiKey(String key) => _settingsBox.put(kApiKey, key);
  String? getApiKey() => _settingsBox.get(kApiKey);

  Future<void> saveThemeMode(String mode) => _settingsBox.put(kThemeMode, mode);
  String? getThemeMode() => _settingsBox.get(kThemeMode);

  // Transactions
  // Storing as JSON maps for simplicity initially, or HiveObjects if models allow
  List<dynamic> getTransactions() => _transactionsBox.values.toList();
  Future<void> addTransaction(Map<String, dynamic> data) =>
      _transactionsBox.add(data);
  Future<void> clearTransactions() => _transactionsBox.clear();

  // Goals
  List<dynamic> getGoals() => _goalsBox.values.toList();
  Future<void> addGoal(Map<String, dynamic> data) => _goalsBox.add(data);
}

// Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
