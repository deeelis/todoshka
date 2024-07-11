import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todoshka/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Add Task Integration Test', () {
    testWidgets('Add Task Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: ToDoApp(),
        ),
      );

      expect(find.byKey(const ValueKey('add_task_floating_button')), findsOneWidget);
      final floatingButton = find.byKey(const ValueKey('add_task_floating_button'));
      await tester.tap(floatingButton);
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byKey(const ValueKey("task_details_page")), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey("text_field")), 'Test Task',);

      await tester.tap(find.byKey(const ValueKey("save_button")));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Test Task', findRichText: true), findsAtLeastNWidgets(1));
    });
  });
}