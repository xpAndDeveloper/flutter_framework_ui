import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject(Widget Function(BuildContext) builder) {
    return MaterialApp(
      home: Builder(builder: (ctx) => Scaffold(body: builder(ctx))),
    );
  }

  group('AppSnackBar', () {
    testWidgets('show() 显示 info 类型消息', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          (ctx) => TextButton(
            onPressed: () => AppSnackBar.show(ctx, '信息提示'),
            child: const Text('触发'),
          ),
        ),
      );
      await tester.tap(find.text('触发'));
      await tester.pump();
      expect(find.text('信息提示'), findsOneWidget);
    });

    testWidgets('showSuccess() 显示成功消息', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          (ctx) => TextButton(
            onPressed: () => AppSnackBar.showSuccess(ctx, '操作成功'),
            child: const Text('触发'),
          ),
        ),
      );
      await tester.tap(find.text('触发'));
      await tester.pump();
      expect(find.text('操作成功'), findsOneWidget);
    });

    testWidgets('showError() 显示错误消息', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          (ctx) => TextButton(
            onPressed: () => AppSnackBar.showError(ctx, '加载失败'),
            child: const Text('触发'),
          ),
        ),
      );
      await tester.tap(find.text('触发'));
      await tester.pump();
      expect(find.text('加载失败'), findsOneWidget);
    });

    testWidgets('showWarning() 显示警告消息', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          (ctx) => TextButton(
            onPressed: () => AppSnackBar.showWarning(ctx, '注意事项'),
            child: const Text('触发'),
          ),
        ),
      );
      await tester.tap(find.text('触发'));
      await tester.pump();
      expect(find.text('注意事项'), findsOneWidget);
    });

    testWidgets('带 actionLabel 时显示操作按钮并触发回调', (tester) async {
      var actionTapped = false;
      await tester.pumpWidget(
        buildSubject(
          (ctx) => TextButton(
            onPressed: () => AppSnackBar.show(
              ctx,
              '消息',
              actionLabel: '撤销',
              onAction: () => actionTapped = true,
            ),
            child: const Text('触发'),
          ),
        ),
      );
      await tester.tap(find.text('触发'));
      // 等待 SnackBar 入场动画完成
      await tester.pumpAndSettle();
      // 确认 SnackBarAction 文字已渲染
      expect(find.text('撤销'), findsOneWidget);
      await tester.tap(find.text('撤销'));
      await tester.pump();
      expect(actionTapped, isTrue);
    });
  });
}
