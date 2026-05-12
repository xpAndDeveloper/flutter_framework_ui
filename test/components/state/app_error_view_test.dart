import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject({
    String message = '加载失败',
    VoidCallback? onRetry,
    String retryLabel = '重试',
    Widget? icon,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppErrorView(
          message: message,
          onRetry: onRetry,
          retryLabel: retryLabel,
          icon: icon,
        ),
      ),
    );
  }

  group('AppErrorView', () {
    testWidgets('基础渲染：显示错误消息', (tester) async {
      await tester.pumpWidget(buildSubject(message: '网络连接失败'));
      expect(find.text('网络连接失败'), findsOneWidget);
    });

    testWidgets('无 onRetry 时不渲染重试按钮', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('onRetry 存在时渲染重试按钮', (tester) async {
      await tester.pumpWidget(buildSubject(onRetry: () {}));
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('点击重试按钮触发 onRetry', (tester) async {
      var retried = false;
      await tester.pumpWidget(buildSubject(onRetry: () => retried = true));
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(retried, isTrue);
    });

    testWidgets('retryLabel 文字生效', (tester) async {
      await tester.pumpWidget(
        buildSubject(onRetry: () {}, retryLabel: '刷新页面'),
      );
      expect(find.text('刷新页面'), findsOneWidget);
    });

    testWidgets('自定义 icon 正常渲染', (tester) async {
      await tester.pumpWidget(
        buildSubject(icon: const Icon(Icons.wifi_off)),
      );
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('Semantics 标注包含 message', (tester) async {
      await tester.pumpWidget(buildSubject(message: '无障碍错误信息'));
      final semantics = tester.getSemantics(find.byType(AppErrorView));
      expect(semantics.label, contains('无障碍错误信息'));
    });
  });
}
