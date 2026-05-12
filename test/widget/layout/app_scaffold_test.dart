import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppScaffold', () {
    Widget buildApp(Widget scaffold) {
      return MaterialApp(home: scaffold);
    }

    testWidgets('renders without error by default', (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppScaffold(
            body: Text('body'),
          ),
        ),
      );
      expect(find.text('body'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('displays appBar when provided', (tester) async {
      await tester.pumpWidget(
        buildApp(
          AppScaffold(
            appBar: AppBar(title: const Text('My Title')),
            body: const Text('body'),
          ),
        ),
      );
      expect(find.text('My Title'), findsOneWidget);
    });

    testWidgets('does not wrap body in AppSafeArea when useSafeArea=false',
        (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppScaffold(
            useSafeArea: false,
            body: Text('body'),
          ),
        ),
      );
      // When useSafeArea is false, AppSafeArea widget should not be present.
      expect(find.byType(AppSafeArea), findsNothing);
      expect(find.text('body'), findsOneWidget);
    });

    testWidgets('wraps body in AppSafeArea when useSafeArea=true (default)',
        (tester) async {
      await tester.pumpWidget(
        buildApp(
          const AppScaffold(
            body: Text('body'),
          ),
        ),
      );
      expect(find.byType(AppSafeArea), findsOneWidget);
    });
  });
}
