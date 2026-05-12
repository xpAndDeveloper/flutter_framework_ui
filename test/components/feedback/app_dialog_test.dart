import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject({
    String? title,
    Widget? content,
    List<Widget> actions = const [],
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppDialog(
          title: title,
          content: content ?? const Text('内容区域'),
          actions: actions,
        ),
      ),
    );
  }

  group('AppDialog', () {
    testWidgets('基础渲染：有标题时显示标题', (tester) async {
      await tester.pumpWidget(buildSubject(title: '提示标题'));
      expect(find.text('提示标题'), findsOneWidget);
    });

    testWidgets('基础渲染：显示内容 Widget', (tester) async {
      await tester.pumpWidget(
        buildSubject(content: const Text('这是内容')),
      );
      expect(find.text('这是内容'), findsOneWidget);
    });

    testWidgets('无标题时不渲染标题区域', (tester) async {
      await tester.pumpWidget(buildSubject());
      // 仅确认内容正常，无崩溃
      expect(find.byType(AppDialog), findsOneWidget);
    });

    testWidgets('actions 列表中的按钮正常渲染', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildSubject(
          title: '确认',
          actions: [
            TextButton(
              onPressed: () => tapped = true,
              child: const Text('确定'),
            ),
          ],
        ),
      );
      expect(find.text('确定'), findsOneWidget);
      await tester.tap(find.text('确定'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('show() 静态方法弹出对话框', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => Scaffold(
              body: TextButton(
                onPressed: () => AppDialog.show(
                  ctx,
                  title: '弹窗标题',
                  content: const Text('弹窗内容'),
                ),
                child: const Text('打开'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('弹窗标题'), findsOneWidget);
      expect(find.text('弹窗内容'), findsOneWidget);
    });

    testWidgets('showConfirm() 弹出确认/取消按钮', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => Scaffold(
              body: TextButton(
                onPressed: () => AppDialog.showConfirm(
                  ctx,
                  title: '删除确认',
                  message: '确定要删除吗？',
                ),
                child: const Text('删除'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(find.text('删除确认'), findsOneWidget);
      expect(find.text('确认'), findsOneWidget);
      expect(find.text('取消'), findsOneWidget);
    });

    testWidgets('Semantics 标注存在', (tester) async {
      await tester.pumpWidget(buildSubject(title: '无障碍标题'));
      final semantics = tester.getSemantics(find.byType(AppDialog));
      expect(semantics.label, contains('无障碍标题'));
    });
  });
}
