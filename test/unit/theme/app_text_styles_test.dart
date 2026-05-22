import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppTextStyles', () {
    test('display.fontSize 为 32', () {
      expect(AppTextStyles.display.fontSize, 32);
    });

    test('body.fontSize 为 14', () {
      expect(AppTextStyles.body.fontSize, 14);
    });

    // 任务 2.5：验证具体字阶属性
    test('subhead.height ≈ 16/12', () {
      expect(AppTextStyles.subhead.height, closeTo(16 / 12, 0.001));
    });

    test('caption1.letterSpacing == 0.1', () {
      expect(AppTextStyles.caption1.letterSpacing, 0.1);
    });

    test('amountConfirm.fontSize == 24', () {
      expect(AppTextStyles.amountConfirm.fontSize, 24);
    });
  });
}
