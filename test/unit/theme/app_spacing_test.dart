import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppSpacing', () {
    test('md 值为 16.0', () {
      expect(AppSpacing.md, 16.0);
    });

    test('xs 小于 sm（递增验证）', () {
      expect(AppSpacing.xs, lessThan(AppSpacing.sm));
    });
  });
}
