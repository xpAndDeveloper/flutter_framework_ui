import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

Widget _buildStepper({
  required double value,
  ValueChanged<double>? onChanged,
  double min = 0,
  double max = double.infinity,
  double step = 1,
  int? decimalPlaces,
  bool enabled = true,
}) {
  return MaterialApp(
    home: Scaffold(
      body: AppStepper(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        step: step,
        decimalPlaces: decimalPlaces,
        enabled: enabled,
      ),
    ),
  );
}

void main() {
  group('AppStepper', () {
    testWidgets('点击 + 调用 onChanged(value + step)', (tester) async {
      double? changed;
      await tester.pumpWidget(_buildStepper(
        value: 5,
        min: 0,
        max: 10,
        step: 1,
        onChanged: (v) => changed = v,
      ));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(changed, equals(6.0));
    });

    testWidgets('点击 − 调用 onChanged(value - step)', (tester) async {
      double? changed;
      await tester.pumpWidget(_buildStepper(
        value: 5,
        min: 0,
        max: 10,
        step: 1,
        onChanged: (v) => changed = v,
      ));

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(changed, equals(4.0));
    });

    testWidgets('value == max 时 + 按钮不可点击', (tester) async {
      double? changed;
      await tester.pumpWidget(_buildStepper(
        value: 10,
        min: 0,
        max: 10,
        onChanged: (v) => changed = v,
      ));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(changed, isNull);
    });

    testWidgets('value == min 时 − 按钮不可点击', (tester) async {
      double? changed;
      await tester.pumpWidget(_buildStepper(
        value: 0,
        min: 0,
        max: 10,
        onChanged: (v) => changed = v,
      ));

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(changed, isNull);
    });

    testWidgets('enabled=false 时两个按钮均不可点击', (tester) async {
      double? changed;
      await tester.pumpWidget(_buildStepper(
        value: 5,
        min: 0,
        max: 10,
        enabled: false,
        onChanged: (v) => changed = v,
      ));

      await tester.tap(find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(changed, isNull);
    });

    testWidgets('decimalPlaces=2 时显示两位小数', (tester) async {
      await tester.pumpWidget(_buildStepper(
        value: 1.5,
        decimalPlaces: 2,
      ));

      expect(find.text('1.50'), findsOneWidget);
    });

    testWidgets('decimalPlaces=0 时显示整数', (tester) async {
      await tester.pumpWidget(_buildStepper(
        value: 5.0,
        decimalPlaces: 0,
      ));

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('step=0.1 时自动推断 decimalPlaces=2', (tester) async {
      await tester.pumpWidget(_buildStepper(
        value: 1.0,
        step: 0.1,
      ));

      expect(find.text('1.00'), findsOneWidget);
    });

    testWidgets('step=1（整数）时自动推断 decimalPlaces=0', (tester) async {
      await tester.pumpWidget(_buildStepper(
        value: 3.0,
        step: 1,
      ));

      expect(find.text('3'), findsOneWidget);
    });
  });
}
