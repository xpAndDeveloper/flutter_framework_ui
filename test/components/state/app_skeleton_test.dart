import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSkeleton({double width = 100, double height = 20}) {
    return MaterialApp(
      home: Scaffold(
        body: AppSkeleton(width: width, height: height),
      ),
    );
  }

  Widget buildSkeletonText({int lines = 3}) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 300,
          child: AppSkeletonText(lines: lines),
        ),
      ),
    );
  }

  group('AppSkeleton', () {
    testWidgets('基础渲染：指定宽高正常显示', (tester) async {
      await tester.pumpWidget(buildSkeleton(width: 200, height: 40));
      expect(find.byType(AppSkeleton), findsOneWidget);
    });

    testWidgets('动画运行不崩溃', (tester) async {
      await tester.pumpWidget(buildSkeleton());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(AppSkeleton), findsOneWidget);
    });

    testWidgets('Semantics 标注存在', (tester) async {
      await tester.pumpWidget(buildSkeleton());
      final semantics = tester.getSemantics(find.byType(AppSkeleton));
      expect(semantics.label, '加载中');
    });

    testWidgets('主题从亮色切换到暗色不抛出 LateInitializationError',
        (tester) async {
      // 用 ValueNotifier 控制主题模式，模拟主题切换
      final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

      await tester.pumpWidget(
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeMode,
          builder: (_, mode, __) => MaterialApp(
            themeMode: mode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const Scaffold(
              body: AppSkeleton(width: 100, height: 20),
            ),
          ),
        ),
      );

      // 先让动画运行一帧
      await tester.pump(const Duration(milliseconds: 100));

      // 切换到暗色主题
      themeMode.value = ThemeMode.dark;
      await tester.pump(); // 触发 rebuild

      // 再次运行动画，不应抛出任何错误
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(AppSkeleton), findsOneWidget);
      themeMode.dispose();
    });
  });

  group('AppSkeletonText', () {
    testWidgets('lines=3 渲染 3 个 AppSkeleton', (tester) async {
      await tester.pumpWidget(buildSkeletonText(lines: 3));
      expect(find.byType(AppSkeleton), findsNWidgets(3));
    });

    testWidgets('lines=5 渲染 5 个 AppSkeleton', (tester) async {
      await tester.pumpWidget(buildSkeletonText(lines: 5));
      expect(find.byType(AppSkeleton), findsNWidgets(5));
    });

    testWidgets('默认 lines=3 正常渲染', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(width: 300, child: const AppSkeletonText()),
          ),
        ),
      );
      expect(find.byType(AppSkeletonText), findsOneWidget);
    });
  });
}
