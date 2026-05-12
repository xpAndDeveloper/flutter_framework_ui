import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject({
    String label = 'Test',
    VoidCallback? onPressed,
    AppButtonVariant variant = AppButtonVariant.primary,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? icon,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppButton(
          label: label,
          onPressed: onPressed,
          variant: variant,
          size: size,
          isLoading: isLoading,
          isDisabled: isDisabled,
          icon: icon,
        ),
      ),
    );
  }

  group('AppButton', () {
    testWidgets('primary 变体正常渲染，显示 label 文字', (tester) async {
      await tester.pumpWidget(buildSubject(label: 'Click Me'));
      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('isDisabled=true 时 onPressed 不触发', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildSubject(
          label: 'Disabled',
          onPressed: () => tapped = true,
          isDisabled: true,
        ),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('isLoading=true 时显示 CircularProgressIndicator', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(label: 'Loading', isLoading: true));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // label 文字不可见（被 loading 替换）
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('onPressed 触发时回调被调用', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildSubject(
          label: 'Tap Me',
          onPressed: () => tapped = true,
        ),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('small size 渲染不报错', (tester) async {
      await tester.pumpWidget(
        buildSubject(label: 'Small', size: AppButtonSize.small),
      );
      expect(find.text('Small'), findsOneWidget);
    });

    testWidgets('medium size 渲染不报错', (tester) async {
      await tester.pumpWidget(
        buildSubject(label: 'Medium', size: AppButtonSize.medium),
      );
      expect(find.text('Medium'), findsOneWidget);
    });

    testWidgets('large size 渲染不报错', (tester) async {
      await tester.pumpWidget(
        buildSubject(label: 'Large', size: AppButtonSize.large),
      );
      expect(find.text('Large'), findsOneWidget);
    });

    testWidgets('secondary 变体渲染不报错', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          label: 'Secondary',
          variant: AppButtonVariant.secondary,
        ),
      );
      expect(find.text('Secondary'), findsOneWidget);
    });

    testWidgets('outline 变体渲染不报错', (tester) async {
      await tester.pumpWidget(
        buildSubject(label: 'Outline', variant: AppButtonVariant.outline),
      );
      expect(find.text('Outline'), findsOneWidget);
    });

    testWidgets('ghost 变体渲染不报错', (tester) async {
      await tester.pumpWidget(
        buildSubject(label: 'Ghost', variant: AppButtonVariant.ghost),
      );
      expect(find.text('Ghost'), findsOneWidget);
    });

    testWidgets('danger 变体渲染不报错', (tester) async {
      await tester.pumpWidget(
        buildSubject(label: 'Danger', variant: AppButtonVariant.danger),
      );
      expect(find.text('Danger'), findsOneWidget);
    });

    testWidgets('带 icon 时渲染不报错', (tester) async {
      await tester.pumpWidget(
        buildSubject(
          label: 'With Icon',
          icon: const Icon(Icons.star),
        ),
      );
      expect(find.text('With Icon'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('primary 变体颜色跟随 colorScheme.primary', (tester) async {
      // 注入自定义 ThemeData，验证 AppButton 使用 colorScheme 而非硬编码颜色
      const customPrimary = Color(0xFF123456);
      final customTheme = ThemeData(
        colorScheme: const ColorScheme.light(primary: customPrimary),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: customTheme,
          home: Scaffold(
            body: AppButton(label: 'Themed', onPressed: () {}),
          ),
        ),
      );
      // AppButton primary 使用 Material widget，其 color 应与 colorScheme.primary 一致
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(AppButton),
          matching: find.byType(Material),
        ).first,
      );
      expect(material.color, customPrimary);
    });

    testWidgets('danger 变体颜色跟随 colorScheme.error', (tester) async {
      const customError = Color(0xFFAB1234);
      final customTheme = ThemeData(
        colorScheme: const ColorScheme.light(error: customError),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: customTheme,
          home: Scaffold(
            body: AppButton(
              label: 'Error',
              variant: AppButtonVariant.danger,
              onPressed: () {},
            ),
          ),
        ),
      );
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(AppButton),
          matching: find.byType(Material),
        ).first,
      );
      expect(material.color, customError);
    });
  });
}
