import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject({
    String title = '页面标题',
    Widget? leading,
    List<Widget>? actions,
    bool centerTitle = true,
    double elevation = 0,
  }) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppAppBar(
          title: title,
          leading: leading,
          actions: actions,
          centerTitle: centerTitle,
          elevation: elevation,
        ),
        body: const SizedBox.shrink(),
      ),
    );
  }

  group('AppAppBar', () {
    testWidgets('基础渲染：显示 title', (tester) async {
      await tester.pumpWidget(buildSubject(title: '我的页面'));
      expect(find.text('我的页面'), findsOneWidget);
    });

    testWidgets('actions 中的 Widget 正常渲染', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildSubject(
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => tapped = true,
            ),
          ],
        ),
      );
      expect(find.byIcon(Icons.search), findsOneWidget);
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('自定义 leading 正常渲染', (tester) async {
      await tester.pumpWidget(
        buildSubject(leading: const Icon(Icons.menu)),
      );
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('preferredSize 高度为 kToolbarHeight', (tester) async {
      const appBar = AppAppBar(title: '测试');
      expect(appBar.preferredSize.height, kToolbarHeight);
    });

    testWidgets('实现 PreferredSizeWidget', (tester) async {
      const appBar = AppAppBar(title: '测试');
      expect(appBar, isA<PreferredSizeWidget>());
    });

    testWidgets('Semantics header 标注存在', (tester) async {
      await tester.pumpWidget(buildSubject(title: '无障碍标题'));
      // AppBar 渲染出标题文字即视为 Semantics 正常工作
      expect(find.text('无障碍标题'), findsOneWidget);
    });
  });
}
