import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppTheme', () {
    group('light()', () {
      late ThemeData theme;

      setUp(() {
        theme = AppTheme.light();
      });

      test('returns a ThemeData instance', () {
        expect(theme, isA<ThemeData>());
      });

      test('brightness is light', () {
        expect(theme.brightness, Brightness.light);
      });

      test('contains AppColorTokens extension', () {
        final tokens = theme.extension<AppColorTokens>();
        expect(tokens, isNotNull);
      });

      test('AppColorTokens extension matches light preset', () {
        final tokens = theme.extension<AppColorTokens>()!;
        expect(tokens.cardBackground, AppColorTokens.light.cardBackground);
        expect(tokens.divider, AppColorTokens.light.divider);
        expect(tokens.inputBorder, AppColorTokens.light.inputBorder);
        expect(tokens.inputFill, AppColorTokens.light.inputFill);
      });

      test('uses Material3', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('cardTheme has zero elevation', () {
        expect(theme.cardTheme.elevation, 0);
      });

      test('inputDecorationTheme is filled', () {
        expect(theme.inputDecorationTheme.filled, isTrue);
      });
    });

    group('dark()', () {
      late ThemeData theme;

      setUp(() {
        theme = AppTheme.dark();
      });

      test('returns a ThemeData instance', () {
        expect(theme, isA<ThemeData>());
      });

      test('brightness is dark', () {
        expect(theme.brightness, Brightness.dark);
      });

      test('contains AppColorTokens extension', () {
        final tokens = theme.extension<AppColorTokens>();
        expect(tokens, isNotNull);
      });

      test('AppColorTokens extension matches dark preset', () {
        final tokens = theme.extension<AppColorTokens>()!;
        expect(tokens.cardBackground, AppColorTokens.dark.cardBackground);
        expect(tokens.divider, AppColorTokens.dark.divider);
        expect(tokens.inputBorder, AppColorTokens.dark.inputBorder);
        expect(tokens.inputFill, AppColorTokens.dark.inputFill);
      });

      test('uses Material3', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('cardTheme has zero elevation', () {
        expect(theme.cardTheme.elevation, 0);
      });
    });

    group('text theme integration', () {
      test('light theme displayLarge has headingXl fontSize', () {
        final theme = AppTheme.light();
        expect(theme.textTheme.displayLarge?.fontSize, 32);
      });

      test('dark theme displayLarge has headingXl fontSize', () {
        final theme = AppTheme.dark();
        expect(theme.textTheme.displayLarge?.fontSize, 32);
      });

      test('light theme bodyMedium has bodyMd fontSize', () {
        final theme = AppTheme.light();
        expect(theme.textTheme.bodyMedium?.fontSize, 14);
      });
    });
  });
}
