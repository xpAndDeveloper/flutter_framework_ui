import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppRadius', () {
    test('md 等于 BorderRadius.all(Radius.circular(8))', () {
      expect(AppRadius.md, const BorderRadius.all(Radius.circular(8)));
    });

    test('full 等于 BorderRadius.all(Radius.circular(9999))', () {
      expect(AppRadius.full, const BorderRadius.all(Radius.circular(9999)));
    });
  });
}
