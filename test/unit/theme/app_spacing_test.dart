import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppSpacing', () {
    test('space5 值为 16.0', () {
      expect(AppSpacing.space5, 16.0);
    });

    test('各档递增', () {
      expect(AppSpacing.space1, lessThan(AppSpacing.space2));
      expect(AppSpacing.space2, lessThan(AppSpacing.space3));
      expect(AppSpacing.space3, lessThan(AppSpacing.space4));
    });

    // 任务 3.3
    test('space5 == 16.0', () {
      expect(AppSpacing.space5, 16.0);
    });
  });
}
