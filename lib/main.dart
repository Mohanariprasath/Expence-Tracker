import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/app.dart';
import 'package:my_app/core/providers.dart';
import 'package:my_app/data/local/storage_service.dart';
import 'package:my_app/data/models/goal_model.dart';
import 'package:my_app/data/models/transaction_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found or invalid. Using default keys.");
  }

  // Hive Initialization
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(GoalAdapter());

  // Initialize Storage Service
  final storageService = StorageService();
  await storageService.init();

  runApp(
    ProviderScope(
      overrides: [storageProvider.overrideWithValue(storageService)],
      child: const AntigravityApp(),
    ),
  );
}
