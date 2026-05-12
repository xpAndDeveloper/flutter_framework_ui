import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  Widget buildSubject({
    TextEditingController? controller,
    String? label,
    String? hint,
    String? errorText,
    ValueChanged<String>? onChanged,
    bool enabled = true,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: AppTextField(
          controller: controller,
          label: label,
          hint: hint,
          errorText: errorText,
          onChanged: onChanged,
          enabled: enabled,
        ),
      ),
    );
  }

  group('AppTextField', () {
    testWidgets('默认渲染不报错', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byType(AppTextField), findsOneWidget);
    });

    testWidgets('label 正确显示', (tester) async {
      await tester.pumpWidget(buildSubject(label: 'Email'));
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('hint 正确显示', (tester) async {
      await tester.pumpWidget(buildSubject(hint: 'Enter email'));
      expect(find.text('Enter email'), findsOneWidget);
    });

    testWidgets('errorText 正确显示', (tester) async {
      await tester.pumpWidget(buildSubject(errorText: 'Invalid email'));
      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('onChanged 回调触发', (tester) async {
      String? changed;
      await tester.pumpWidget(
        buildSubject(onChanged: (v) => changed = v),
      );
      await tester.enterText(find.byType(TextField), 'hello');
      expect(changed, 'hello');
    });

    testWidgets('disabled 时不可编辑', (tester) async {
      await tester.pumpWidget(buildSubject(enabled: false));
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });
  });
}
