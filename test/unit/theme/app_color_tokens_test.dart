import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppColorTokens', () {
    group('light preset', () {
      test('brand.primary == Color(0xFF00BD8D)', () {
        expect(AppColorTokens.light.brand.primary, const Color(0xFF00BD8D));
      });

      test('bg.page == Color(0xFFF7F8FB)', () {
        expect(AppColorTokens.light.bg.page, const Color(0xFFF7F8FB));
      });

      test('text.primary == text.title == text.body', () {
        expect(AppColorTokens.light.text.primary, AppColorTokens.light.text.title);
        expect(AppColorTokens.light.text.primary, AppColorTokens.light.text.body);
      });

      test('shimmerBase == bg.subtle', () {
        expect(AppColorTokens.light.shimmerBase, AppColorTokens.light.bg.subtle);
      });

      test('shimmerHighlight == bg.base', () {
        expect(AppColorTokens.light.shimmerHighlight, AppColorTokens.light.bg.base);
      });

      test('status.success == Color(0xFF00BD8D)', () {
        expect(AppColorTokens.light.status.success, const Color(0xFF00BD8D));
      });

      test('status.error == Color(0xFFDE4B4B)', () {
        expect(AppColorTokens.light.status.error, const Color(0xFFDE4B4B));
      });
    });

    group('dark preset', () {
      test('bg.page == Color(0xFF000000)', () {
        expect(AppColorTokens.dark.bg.page, const Color(0xFF000000));
      });

      test('bg.elevated == Color(0xFF222222)', () {
        expect(AppColorTokens.dark.bg.elevated, const Color(0xFF222222));
      });

      test('text.primary == text.title', () {
        expect(AppColorTokens.dark.text.primary, AppColorTokens.dark.text.title);
      });
    });

    group('copyWith', () {
      test('only replaces specified namespace', () {
        final newBrand = AppColorTokens.light.brand.copyWith(
          primary: const Color(0xFF123456),
        );
        final copied = AppColorTokens.light.copyWith(brand: newBrand);

        expect(copied.brand.primary, const Color(0xFF123456));
        expect(copied.status, AppColorTokens.light.status);
        expect(copied.bg, AppColorTokens.light.bg);
      });

      test('copyWith with no args returns equivalent object', () {
        final copied = AppColorTokens.light.copyWith();
        expect(copied.brand.primary, AppColorTokens.light.brand.primary);
        expect(copied.text.title, AppColorTokens.light.text.title);
      });
    });

    group('lerp', () {
      test('t=0 returns light values', () {
        final result = AppColorTokens.light.lerp(AppColorTokens.dark, 0.0);
        expect(result.brand.primary, AppColorTokens.light.brand.primary);
        expect(result.bg.page, AppColorTokens.light.bg.page);
      });

      test('t=1 returns dark values', () {
        final result = AppColorTokens.light.lerp(AppColorTokens.dark, 1.0);
        expect(result.bg.page, AppColorTokens.dark.bg.page);
        expect(result.text.title, AppColorTokens.dark.text.title);
      });

      test('lerp with null other returns self', () {
        final result = AppColorTokens.light.lerp(null, 0.5);
        expect(result.brand.primary, AppColorTokens.light.brand.primary);
      });

      test('t=0.5 produces intermediate color', () {
        final result = AppColorTokens.light.lerp(AppColorTokens.dark, 0.5);
        final expected = Color.lerp(
          AppColorTokens.light.bg.page,
          AppColorTokens.dark.bg.page,
          0.5,
        )!;
        expect(result.bg.page, expected);
      });

      test('lerp does not throw', () {
        expect(
          () => AppColorTokens.light.lerp(AppColorTokens.dark, 0.5),
          returnsNormally,
        );
      });
    });

    group('bg / border compat', () {
      test('bg.elevated matches card background color', () {
        expect(AppColorTokens.light.bg.elevated, const Color(0xFFFFFFFF));
      });

      test('border.divider matches divider color', () {
        expect(AppColorTokens.light.border.divider, const Color(0xFFEBEEF2));
      });
    });
  });
}
