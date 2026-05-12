import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject({
    Widget? child,
    String? title,
    bool showDragHandle = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppBottomSheet(
          title: title,
          showDragHandle: showDragHandle,
          child: child ?? const Text('底部内容'),
        ),
      ),
    );
  }

  group('AppBottomSheet', () {
    testWidgets('基础渲染：显示 child 内容', (tester) async {
      await tester.pumpWidget(buildSubject(child: const Text('面板内容')));
      expect(find.text('面板内容'), findsOneWidget);
    });

    testWidgets('有标题时显示标题', (tester) async {
      await tester.pumpWidget(buildSubject(title: '选择操作'));
      expect(find.text('选择操作'), findsOneWidget);
    });

    testWidgets('无标题时不崩溃', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byType(AppBottomSheet), findsOneWidget);
    });

    testWidgets('show() 静态方法弹出底部面板', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => Scaffold(
              body: TextButton(
                onPressed: () => AppBottomSheet.show(
                  ctx,
                  title: '面板标题',
                  child: const Text('面板子内容'),
                ),
                child: const Text('打开'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('面板标题'), findsOneWidget);
      expect(find.text('面板子内容'), findsOneWidget);
    });

    testWidgets('Semantics 标注存在', (tester) async {
      await tester.pumpWidget(buildSubject(title: '无障碍面板'));
      final semantics = tester.getSemantics(find.byType(AppBottomSheet));
      expect(semantics.label, contains('无障碍面板'));
    });
  });
}
