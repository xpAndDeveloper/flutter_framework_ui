import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppFormField', () {
    testWidgets('Form.validate() triggers validator and shows errorText', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  AppFormField(
                    label: '姓名',
                    validator: AppValidators.required(message: '姓名不能为空'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // 初始无 errorText
      expect(find.text('姓名不能为空'), findsNothing);

      // 触发校验
      formKey.currentState!.validate();
      await tester.pump();

      // 应显示错误信息
      expect(find.text('姓名不能为空'), findsOneWidget);
    });

    testWidgets('AutovalidateMode.onUserInteraction shows error after input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: AppFormField(
                label: '用户名',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: AppValidators.minLength(4, message: '至少4个字符'),
              ),
            ),
          ),
        ),
      );

      // 初始无错误
      expect(find.text('至少4个字符'), findsNothing);

      // 输入不足长度的内容
      await tester.enterText(find.byType(TextField), 'ab');
      await tester.pump();

      // 应自动显示错误
      expect(find.text('至少4个字符'), findsOneWidget);

      // 补足长度后错误消失
      await tester.enterText(find.byType(TextField), 'abcde');
      await tester.pump();
      expect(find.text('至少4个字符'), findsNothing);
    });

    testWidgets('Form.validate() returns true when all fields valid', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppFormField(
                label: '邮箱',
                validator: AppValidators.required(),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test@example.com');
      await tester.pump();

      expect(formKey.currentState!.validate(), isTrue);
    });
  });
}
