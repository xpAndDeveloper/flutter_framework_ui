import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject({
    String title = '暂无数据',
    String? subtitle,
    Widget? icon,
    Widget? action,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppEmptyState(
          title: title,
          subtitle: subtitle,
          icon: icon,
          action: action,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
      ),
    );
  }

  group('AppEmptyState', () {
    testWidgets('基础渲染：显示 title', (tester) async {
      await tester.pumpWidget(buildSubject(title: '没有记录'));
      expect(find.text('没有记录'), findsOneWidget);
    });

    testWidgets('subtitle 存在时渲染', (tester) async {
      await tester.pumpWidget(buildSubject(subtitle: '请添加数据后再来查看'));
      expect(find.text('请添加数据后再来查看'), findsOneWidget);
    });

    testWidgets('icon widget 正常渲染', (tester) async {
      await tester.pumpWidget(
        buildSubject(icon: const Icon(Icons.inbox_outlined)),
      );
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('actionLabel + onAction 渲染 AppButton 并触发', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildSubject(actionLabel: '去添加', onAction: () => tapped = true),
      );
      expect(find.text('去添加'), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('传入 action widget 时直接渲染', (tester) async {
      await tester.pumpWidget(
        buildSubject(action: const Text('自定义操作')),
      );
      expect(find.text('自定义操作'), findsOneWidget);
    });

    testWidgets('Semantics 标注包含 title', (tester) async {
      await tester.pumpWidget(buildSubject(title: '无障碍空状态'));
      final semantics = tester.getSemantics(find.byType(AppEmptyState));
      expect(semantics.label, contains('无障碍空状态'));
    });
  });
}
