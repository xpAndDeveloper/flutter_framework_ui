import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppTextStyles', () {
    test('headingXl.fontSize 为 32', () {
      expect(AppTextStyles.headingXl.fontSize, 32);
    });

    test('bodyMd.fontSize 为 14', () {
      expect(AppTextStyles.bodyMd.fontSize, 14);
    });
  });
}
