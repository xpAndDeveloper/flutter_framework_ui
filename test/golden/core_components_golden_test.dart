/// Golden Tests — 核心 UI 组件视觉回归防护
///
/// 使用方法：
/// - 生成/更新基线：`flutter test --update-goldens test/golden/`
/// - 验证（CI）：`flutter test test/golden/`
///
/// 首次运行时需要先生成基线文件（goldens/ 目录下的 .png 文件）。
/// 基线文件应提交到版本控制，与代码同步更新。
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

/// 包裹 widget 到标准测试环境（light theme，固定尺寸）。
Widget _wrap(Widget child, {Size size = const Size(400, 200)}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  // -------------------------------------------------------------------------
  // AppButton
  // -------------------------------------------------------------------------
  group('AppButton golden', () {
    testWidgets('primary variant', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 100));
      await tester.pumpWidget(_wrap(
        const AppButton(label: '确认'),
        size: const Size(400, 100),
      ));
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_primary.png'),
      );
    });

    testWidgets('outline variant', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 100));
      await tester.pumpWidget(_wrap(
        const AppButton(label: '取消', variant: AppButtonVariant.outline),
        size: const Size(400, 100),
      ));
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_outline.png'),
      );
    });

    testWidgets('disabled state', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 100));
      await tester.pumpWidget(_wrap(
        const AppButton(label: '禁用', isDisabled: true),
        size: const Size(400, 100),
      ));
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_disabled.png'),
      );
    });
  });

  // -------------------------------------------------------------------------
  // AppStepper
  // -------------------------------------------------------------------------
  group('AppStepper golden', () {
    testWidgets('default state', (tester) async {
      await tester.binding.setSurfaceSize(const Size(200, 60));
      await tester.pumpWidget(_wrap(
        AppStepper(value: 5, min: 0, max: 10, onChanged: (_) {}),
        size: const Size(200, 60),
      ));
      await expectLater(
        find.byType(AppStepper),
        matchesGoldenFile('goldens/app_stepper_default.png'),
      );
    });

    testWidgets('at minimum value', (tester) async {
      await tester.binding.setSurfaceSize(const Size(200, 60));
      await tester.pumpWidget(_wrap(
        AppStepper(value: 0, min: 0, max: 10, onChanged: (_) {}),
        size: const Size(200, 60),
      ));
      await expectLater(
        find.byType(AppStepper),
        matchesGoldenFile('goldens/app_stepper_at_min.png'),
      );
    });
  });

  // -------------------------------------------------------------------------
  // AppCard
  // -------------------------------------------------------------------------
  group('AppCard golden', () {
    testWidgets('default card', (tester) async {
      await tester.binding.setSurfaceSize(const Size(300, 100));
      await tester.pumpWidget(_wrap(
        const AppCard(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('卡片内容'),
          ),
        ),
        size: const Size(300, 100),
      ));
      await expectLater(
        find.byType(AppCard),
        matchesGoldenFile('goldens/app_card_default.png'),
      );
    });
  });

  // -------------------------------------------------------------------------
  // AppEmptyState
  // -------------------------------------------------------------------------
  group('AppEmptyState golden', () {
    testWidgets('basic empty state', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 300));
      await tester.pumpWidget(_wrap(
        const AppEmptyState(message: '暂无数据'),
        size: const Size(400, 300),
      ));
      await expectLater(
        find.byType(AppEmptyState),
        matchesGoldenFile('goldens/app_empty_state_basic.png'),
      );
    });
  });
}
