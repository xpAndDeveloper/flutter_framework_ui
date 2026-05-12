import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppBreakpoints constants', () {
    test('mobile constant is 600.0', () {
      expect(AppBreakpoints.mobile, equals(600.0));
    });

    test('tablet constant is 960.0', () {
      expect(AppBreakpoints.tablet, equals(960.0));
    });

    test('desktop constant is 1280.0', () {
      expect(AppBreakpoints.desktop, equals(1280.0));
    });
  });
}
