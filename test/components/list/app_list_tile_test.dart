import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject({
    String title = '标题',
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool enabled = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppListTile(
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          onTap: onTap,
          onLongPress: onLongPress,
          enabled: enabled,
        ),
      ),
    );
  }

  group('AppListTile', () {
    testWidgets('基础渲染：显示 title', (tester) async {
      await tester.pumpWidget(buildSubject(title: '列表项'));
      expect(find.text('列表项'), findsOneWidget);
    });

    testWidgets('subtitle 存在时渲染副标题', (tester) async {
      await tester.pumpWidget(buildSubject(subtitle: '副标题'));
      expect(find.text('副标题'), findsOneWidget);
    });

    testWidgets('onTap 回调正常触发', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildSubject(onTap: () => tapped = true));
      await tester.tap(find.byType(AppListTile));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('enabled=false 时 onTap 不触发', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildSubject(onTap: () => tapped = true, enabled: false),
      );
      await tester.tap(find.byType(AppListTile));
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('leading widget 正常渲染', (tester) async {
      await tester.pumpWidget(
        buildSubject(leading: const Icon(Icons.person)),
      );
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('trailing widget 正常渲染', (tester) async {
      await tester.pumpWidget(
        buildSubject(trailing: const Icon(Icons.chevron_right)),
      );
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('Semantics 标注包含 title', (tester) async {
      await tester.pumpWidget(buildSubject(title: '无障碍列表项'));
      final semantics = tester.getSemantics(find.byType(AppListTile));
      expect(semantics.label, contains('无障碍列表项'));
    });
  });
}
