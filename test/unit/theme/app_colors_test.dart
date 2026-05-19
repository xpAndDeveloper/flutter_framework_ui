import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppPrimitiveColors', () {
    test('brandPrimary == Color(0xFF00BD8D)', () {
      expect(AppPrimitiveColors.brandPrimary, const Color(0xFF00BD8D));
    });

    test('statusError == Color(0xFFDE4B4B)', () {
      expect(AppPrimitiveColors.statusError, const Color(0xFFDE4B4B));
    });

    test('textPrimaryLight == Color(0xFF111A34)', () {
      expect(AppPrimitiveColors.textPrimaryLight, const Color(0xFF111A34));
    });

    test('bgPageDark == Color(0xFF000000)', () {
      expect(AppPrimitiveColors.bgPageDark, const Color(0xFF000000));
    });

    test('borderFocus == brandPrimary', () {
      expect(AppPrimitiveColors.borderFocus, AppPrimitiveColors.brandPrimary);
    });
  });
}
