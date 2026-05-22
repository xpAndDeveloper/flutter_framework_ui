import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppShadow', () {
    // 任务 4.3
    test('smLight.length == 2', () {
      expect(AppShadow.smLight.length, 2);
    });

    test('brandDark.isEmpty == true', () {
      expect(AppShadow.brandDark.isEmpty, isTrue);
    });

    test('brandLight.first.color == rgba(0,189,141,0.35)', () {
      expect(AppShadow.brandLight.first.color, const Color(0x5900BD8D));
    });

    test('所有 dark 阴影均为空列表', () {
      expect(AppShadow.smDark, isEmpty);
      expect(AppShadow.mdDark, isEmpty);
      expect(AppShadow.lgDark, isEmpty);
      expect(AppShadow.xlDark, isEmpty);
      expect(AppShadow.successDark, isEmpty);
    });
  });
}
