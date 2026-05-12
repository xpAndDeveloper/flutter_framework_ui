import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject({
    Widget? child,
    VoidCallback? onTap,
    double elevation = 0,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppCard(
          onTap: onTap,
          elevation: elevation,
          child: child ?? const Text('Card Content'),
        ),
      ),
    );
  }

  group('AppCard', () {
    testWidgets('渲染 child', (tester) async {
      await tester.pumpWidget(
        buildSubject(child: const Text('Hello Card')),
      );
      expect(find.text('Hello Card'), findsOneWidget);
    });

    testWidgets('onTap 触发时回调被调用', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildSubject(onTap: () => tapped = true),
      );
      await tester.tap(find.byType(AppCard));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('无 onTap 时不抛错', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byType(AppCard), findsOneWidget);
      // 点击也不应该抛错
      await tester.tap(find.byType(AppCard));
      await tester.pump();
    });

    testWidgets('自定义 elevation 渲染不报错', (tester) async {
      await tester.pumpWidget(buildSubject(elevation: 4));
      expect(find.byType(AppCard), findsOneWidget);
    });
  });
}
