import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('UPayColors', () {
    test('brandPrimary == Color(0xFF00BD8D)', () {
      expect(UPayColors.brandPrimary, const Color(0xFF00BD8D));
    });

    test('statusError == Color(0xFFDE4B4B)', () {
      expect(UPayColors.statusError, const Color(0xFFDE4B4B));
    });

    test('textPrimaryLight == Color(0xFF111A34)', () {
      expect(UPayColors.textPrimaryLight, const Color(0xFF111A34));
    });

    test('bgPageDark == Color(0xFF000000)', () {
      expect(UPayColors.bgPageDark, const Color(0xFF000000));
    });

    test('borderFocus == brandPrimary', () {
      expect(UPayColors.borderFocus, UPayColors.brandPrimary);
    });
  });
}
