import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_color_tokens.dart';
import 'app_text_styles.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// UPay 主题工厂 — 生成 Light / Dark ThemeData。
///
/// 使用 UPay Design System v1.0.5 Token 构建，通过 AppColorTokens ThemeExtension
/// 注入全量语义颜色，Dark 模式统一取消阴影（elevation = 0，无 shadow）。
abstract final class AppTheme {
  static ThemeData light() {
    const tokens = AppColorTokens.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: UPayColors.bgPageLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: UPayColors.brandPrimary,
        brightness: Brightness.light,
        primary: UPayColors.brandPrimary,
        onPrimary: UPayColors.textOnPrimaryCta,
        error: UPayColors.statusError,
        surface: UPayColors.bgBaseLight,
        onSurface: UPayColors.textPrimaryLight,
      ),
      extensions: const [tokens],
      textTheme: _buildTextTheme(UPayColors.textPrimaryLight),
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
        color: UPayColors.bgElevatedLight,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: UPayColors.bgSubtleLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space5,
          vertical: AppSpacing.space4,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: UPayColors.borderDefaultLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: UPayColors.borderDefaultLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(
            color: UPayColors.borderFocus,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: UPayColors.statusError),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: UPayColors.borderDividerLight,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UPayColors.brandPrimaryCta,
          foregroundColor: UPayColors.textOnPrimaryCta,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
          minimumSize: const Size(0, 48),
        ),
      ),
    );
  }

  static ThemeData dark() {
    const tokens = AppColorTokens.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: UPayColors.bgPageDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: UPayColors.brandPrimary,
        brightness: Brightness.dark,
        primary: UPayColors.brandPrimary,
        onPrimary: UPayColors.textOnPrimaryCta,
        error: UPayColors.statusError,
        surface: UPayColors.bgBaseDark,
        onSurface: UPayColors.textPrimaryDark,
      ),
      extensions: const [tokens],
      textTheme: _buildTextTheme(UPayColors.textPrimaryDark),
      cardTheme: const CardThemeData(
        elevation: 0,       // Dark 模式无阴影
        shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
        color: UPayColors.bgElevatedDark,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: UPayColors.bgSubtleDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space5,
          vertical: AppSpacing.space4,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: UPayColors.borderDefaultDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: UPayColors.borderDefaultDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(
            color: UPayColors.borderFocus,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: UPayColors.statusError),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: UPayColors.borderDividerDark,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UPayColors.brandPrimaryCta,
          foregroundColor: UPayColors.textOnPrimaryCta,
          elevation: 0,     // Dark 模式无阴影
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
          minimumSize: const Size(0, 48),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color defaultColor) {
    return TextTheme(
      displayLarge:   AppTextStyles.display.copyWith(color: defaultColor),
      titleLarge:     AppTextStyles.title1.copyWith(color: defaultColor),
      titleMedium:    AppTextStyles.title2.copyWith(color: defaultColor),
      titleSmall:     AppTextStyles.title3.copyWith(color: defaultColor),
      labelLarge:     AppTextStyles.headline.copyWith(color: defaultColor),
      bodyLarge:      AppTextStyles.body.copyWith(color: defaultColor),
      bodyMedium:     AppTextStyles.subhead.copyWith(color: defaultColor),
      bodySmall:      AppTextStyles.footnote.copyWith(color: defaultColor),
      labelMedium:    AppTextStyles.caption1.copyWith(color: defaultColor),
      labelSmall:     AppTextStyles.caption2.copyWith(color: defaultColor),
    );
  }
}
