import 'package:flutter/material.dart';

/// 原始颜色常量（Token JSON 直接映射）。
///
/// 此类仅存放颜色值，不含语义。语义映射请使用 [AppColorTokens]。
/// 外部模块可直接引用此类进行颜色复用。
abstract final class AppPrimitiveColors {
  // ── Brand ──────────────────────────────────────────────
  static const Color brandPrimary      = Color(0xFF00BD8D);
  static const Color brandPrimaryHover = Color(0xFF33CAA4);
  static const Color brandPrimarySoftLight = Color(0xFFE8F9F5);
  static const Color brandPrimarySoftDark  = Color(0xFF00261C);
  static const Color brandPrimaryCta   = Color(0xFF00BD8D);
  static const Color brandSecondaryLight = Color(0xFF121212);
  static const Color brandSecondaryDark  = Color(0xFFFFFFFF);

  // ── Status ─────────────────────────────────────────────
  static const Color statusSuccess          = Color(0xFF00BD8D);
  static const Color statusSuccessSoftLight = Color(0xFFE8F9F5);
  static const Color statusSuccessSoftDark  = Color(0xFF00261C);
  static const Color statusWarning          = Color(0xFFFFA600);
  static const Color statusWarningSoftLight = Color(0xFFFFF6E5);
  static const Color statusWarningSoftDark  = Color(0xFF332100);
  static const Color statusError            = Color(0xFFDE4B4B);
  static const Color statusErrorSoftLight   = Color(0xFFFCEDED);
  static const Color statusErrorSoftDark    = Color(0xFF2C0F0F);
  static const Color statusNeutralLight     = Color(0xFF666F83);
  static const Color statusNeutralDark      = Color(0xFFC5CAD5);
  static const Color statusNeutralSoftLight = Color(0xFFF7F8FB);
  static const Color statusNeutralSoftDark  = Color(0xFF1A1A1A);

  // ── Finance ────────────────────────────────────────────
  static const Color financeIncome  = Color(0xFF00BD8D);
  static const Color financeExpense = Color(0xFFDE4B4B);
  static const Color financePending = Color(0xFFFFA600);
  static const Color financeRefund  = Color(0xFFFFA600);
  static const Color financeFrozenLight = Color(0xFF858B9C);
  static const Color financeFrozenDark  = Color(0xFFC5CAD5);

  // ── Text (Light) ───────────────────────────────────────
  static const Color textPrimaryLight   = Color(0xFF111A34);
  static const Color textSecondaryLight = Color(0xFF666F83);
  static const Color textTertiaryLight  = Color(0xFF858B9C);
  static const Color textInverseLight   = Color(0xFFFFFFFF);
  static const Color textDisabledLight  = Color(0xFFC5CAD5);

  // ── Text (Dark) ────────────────────────────────────────
  static const Color textPrimaryDark    = Color(0xFFFFFFFF);
  static const Color textSecondaryDark  = Color(0xFFC5CAD5);
  static const Color textTertiaryDark   = Color(0xFF858B9C);
  static const Color textInverseDark    = Color(0xFF111A34);
  static const Color textDisabledDark   = Color(0xFF555555);

  // ── Semantic text (mode-independent) ──────────────────
  static const Color textLink       = Color(0xFF00BD8D);
  static const Color textIncome     = Color(0xFF00BD8D);
  static const Color textExpense    = Color(0xFFDE4B4B);
  static const Color textPending    = Color(0xFFFFA600);
  static const Color textError      = Color(0xFFDE4B4B);
  static const Color textOnPrimaryCta = Color(0xFFFFFFFF);

  // ── Background (Light) ────────────────────────────────
  static const Color bgPageLight      = Color(0xFFF6F6F6);
  static const Color bgBaseLight      = Color(0xFFFFFFFF);
  static const Color bgSubtleLight    = Color(0xFFF7F8FB);
  static const Color bgElevatedLight  = Color(0xFFFFFFFF);
  static const Color bgBrandSoftLight = Color(0xFFE8F9F5);
  static const Color bgOverlayLight   = Color(0x33000000); // rgba(0,0,0,0.2)

  // ── Background (Dark) ─────────────────────────────────
  static const Color bgPageDark       = Color(0xFF000000);
  static const Color bgBaseDark       = Color(0xFF121212);
  static const Color bgSubtleDark     = Color(0xFF1A1A1A);
  static const Color bgElevatedDark   = Color(0xFF222222);
  static const Color bgBrandSoftDark  = Color(0xFF00261C);
  static const Color bgOverlayDark    = Color(0x99121212); // rgba(18,18,18,0.6)

  // ── Border (Light) ────────────────────────────────────
  static const Color borderDefaultLight  = Color(0xFFDFE1F8);
  static const Color borderDividerLight  = Color(0xFFEBEEF2);
  static const Color borderStrongLight   = Color(0xFFC5CAD5);
  static const Color borderFocus         = Color(0xFF00BD8D);

  // ── Border (Dark) ─────────────────────────────────────
  static const Color borderDefaultDark   = Color(0xFF333333);
  static const Color borderDividerDark   = Color(0xFF333333);
  static const Color borderStrongDark    = Color(0xFF4A4A4A);

  // ── Shadow base colors ────────────────────────────────
  static const Color shadowBase         = Color(0xFF0F121E); // rgba(15,18,30,x)
  static const Color shadowBrandColor   = Color(0xFF00BD8D); // rgba(0,189,141,x)
}

/// 向后兼容别名（已废弃，请迁移至 AppPrimitiveColors）。
@Deprecated('请使用 AppPrimitiveColors。AppColors 将在下个主版本移除。')
abstract final class AppColors {
  static const primary       = AppPrimitiveColors.brandPrimary;
  static const success       = AppPrimitiveColors.statusSuccess;
  static const warning       = AppPrimitiveColors.statusWarning;
  static const error         = AppPrimitiveColors.statusError;
  static const white         = AppPrimitiveColors.textInverseLight;
  static const grey800       = Color(0xFF1F2937);
  // ignore: deprecated_member_use_from_same_package
  static const info          = AppPrimitiveColors.statusNeutralLight;
}
