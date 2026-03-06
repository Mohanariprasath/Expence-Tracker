import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/src/app.dart';
// import 'package:my_app/src/core/services/storage_service.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    // Mock storage
    // Mock storage
    // final storageOverride = StorageService();
    // In a real test we'd mock init, but for now just fix the compilation
    // Assuming init is needed or we mock the provider.
    // Since we can't easily mock hive init in a unit test without setup,
    // we will just fix the class name for now and wrap in ProviderScope.

    await tester.pumpWidget(const ProviderScope(child: AntigravityApp()));
  });
}
