import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject({
    AppLoadingSize size = AppLoadingSize.medium,
    Color? color,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppLoadingIndicator(
          size: size,
          color: color,
        ),
      ),
    );
  }

  group('AppLoadingIndicator', () {
    testWidgets('small size 渲染不报错', (tester) async {
      await tester.pumpWidget(buildSubject(size: AppLoadingSize.small));
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AppLoadingIndicator),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 16.0);
      expect(sizedBox.height, 16.0);
    });

    testWidgets('medium size 渲染不报错', (tester) async {
      await tester.pumpWidget(buildSubject(size: AppLoadingSize.medium));
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AppLoadingIndicator),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 24.0);
      expect(sizedBox.height, 24.0);
    });

    testWidgets('large size 渲染不报错', (tester) async {
      await tester.pumpWidget(buildSubject(size: AppLoadingSize.large));
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AppLoadingIndicator),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 40.0);
      expect(sizedBox.height, 40.0);
    });

    testWidgets('指定 color 时颜色正确', (tester) async {
      const testColor = Colors.red;
      await tester.pumpWidget(buildSubject(color: testColor));
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.color, testColor);
    });

    testWidgets('不指定 color 时使用 theme primary', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
