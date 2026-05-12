import 'package:flutter/material.dart';
import 'app_colors.dart';

// ─── 嵌套命名空间数据类 ──────────────────────────────────────

@immutable
class BrandTokens {
  const BrandTokens({
    required this.primary,
    required this.primaryHover,
    required this.primarySoft,
    required this.primaryCta,
    required this.secondary,
  });

  final Color primary;
  final Color primaryHover;
  final Color primarySoft;
  final Color primaryCta;
  final Color secondary;

  BrandTokens copyWith({
    Color? primary, Color? primaryHover, Color? primarySoft,
    Color? primaryCta, Color? secondary,
  }) => BrandTokens(
    primary: primary ?? this.primary,
    primaryHover: primaryHover ?? this.primaryHover,
    primarySoft: primarySoft ?? this.primarySoft,
    primaryCta: primaryCta ?? this.primaryCta,
    secondary: secondary ?? this.secondary,
  );

  BrandTokens lerp(BrandTokens other, double t) => BrandTokens(
    primary:      Color.lerp(primary, other.primary, t)!,
    primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
    primarySoft:  Color.lerp(primarySoft, other.primarySoft, t)!,
    primaryCta:   Color.lerp(primaryCta, other.primaryCta, t)!,
    secondary:    Color.lerp(secondary, other.secondary, t)!,
  );
}

@immutable
class StatusTokens {
  const StatusTokens({
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.error,
    required this.errorSoft,
    required this.neutral,
    required this.neutralSoft,
  });

  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color error;
  final Color errorSoft;
  final Color neutral;
  final Color neutralSoft;

  StatusTokens copyWith({
    Color? success, Color? successSoft, Color? warning, Color? warningSoft,
    Color? error, Color? errorSoft, Color? neutral, Color? neutralSoft,
  }) => StatusTokens(
    success: success ?? this.success, successSoft: successSoft ?? this.successSoft,
    warning: warning ?? this.warning, warningSoft: warningSoft ?? this.warningSoft,
    error: error ?? this.error, errorSoft: errorSoft ?? this.errorSoft,
    neutral: neutral ?? this.neutral, neutralSoft: neutralSoft ?? this.neutralSoft,
  );

  StatusTokens lerp(StatusTokens other, double t) => StatusTokens(
    success:     Color.lerp(success, other.success, t)!,
    successSoft: Color.lerp(successSoft, other.successSoft, t)!,
    warning:     Color.lerp(warning, other.warning, t)!,
    warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
    error:       Color.lerp(error, other.error, t)!,
    errorSoft:   Color.lerp(errorSoft, other.errorSoft, t)!,
    neutral:     Color.lerp(neutral, other.neutral, t)!,
    neutralSoft: Color.lerp(neutralSoft, other.neutralSoft, t)!,
  );
}

@immutable
class FinanceTokens {
  const FinanceTokens({
    required this.income,
    required this.expense,
    required this.pending,
    required this.refund,
    required this.frozen,
  });

  final Color income;
  final Color expense;
  final Color pending;
  final Color refund;
  final Color frozen;

  FinanceTokens copyWith({
    Color? income, Color? expense, Color? pending, Color? refund, Color? frozen,
  }) => FinanceTokens(
    income: income ?? this.income, expense: expense ?? this.expense,
    pending: pending ?? this.pending, refund: refund ?? this.refund,
    frozen: frozen ?? this.frozen,
  );

  FinanceTokens lerp(FinanceTokens other, double t) => FinanceTokens(
    income:  Color.lerp(income, other.income, t)!,
    expense: Color.lerp(expense, other.expense, t)!,
    pending: Color.lerp(pending, other.pending, t)!,
    refund:  Color.lerp(refund, other.refund, t)!,
    frozen:  Color.lerp(frozen, other.frozen, t)!,
  );
}

@immutable
class TextTokens {
  const TextTokens({
    required this.title,
    required this.body,
    required this.primary,
    required this.secondary,
    required this.muted,
    required this.disabled,
    required this.inverse,
    required this.link,
    required this.income,
    required this.expense,
    required this.pending,
    required this.error,
    required this.onPrimaryCta,
  });

  final Color title;
  final Color body;
  /// 通用主文字默认锚点（与 title/body 同值，AI 写代码时使用此字段）
  final Color primary;
  final Color secondary;
  final Color muted;
  final Color disabled;
  final Color inverse;
  final Color link;
  final Color income;
  final Color expense;
  final Color pending;
  final Color error;
  final Color onPrimaryCta;

  TextTokens copyWith({
    Color? title, Color? body, Color? primary, Color? secondary, Color? muted,
    Color? disabled, Color? inverse, Color? link, Color? income, Color? expense,
    Color? pending, Color? error, Color? onPrimaryCta,
  }) => TextTokens(
    title: title ?? this.title, body: body ?? this.body,
    primary: primary ?? this.primary, secondary: secondary ?? this.secondary,
    muted: muted ?? this.muted, disabled: disabled ?? this.disabled,
    inverse: inverse ?? this.inverse, link: link ?? this.link,
    income: income ?? this.income, expense: expense ?? this.expense,
    pending: pending ?? this.pending, error: error ?? this.error,
    onPrimaryCta: onPrimaryCta ?? this.onPrimaryCta,
  );

  TextTokens lerp(TextTokens other, double t) => TextTokens(
    title:        Color.lerp(title, other.title, t)!,
    body:         Color.lerp(body, other.body, t)!,
    primary:      Color.lerp(primary, other.primary, t)!,
    secondary:    Color.lerp(secondary, other.secondary, t)!,
    muted:        Color.lerp(muted, other.muted, t)!,
    disabled:     Color.lerp(disabled, other.disabled, t)!,
    inverse:      Color.lerp(inverse, other.inverse, t)!,
    link:         Color.lerp(link, other.link, t)!,
    income:       Color.lerp(income, other.income, t)!,
    expense:      Color.lerp(expense, other.expense, t)!,
    pending:      Color.lerp(pending, other.pending, t)!,
    error:        Color.lerp(error, other.error, t)!,
    onPrimaryCta: Color.lerp(onPrimaryCta, other.onPrimaryCta, t)!,
  );
}

@immutable
class BgTokens {
  const BgTokens({
    required this.page,
    required this.base,
    required this.subtle,
    required this.elevated,
    required this.brandSoft,
    required this.overlay,
  });

  final Color page;
  final Color base;
  final Color subtle;
  final Color elevated;
  final Color brandSoft;
  final Color overlay;

  BgTokens copyWith({
    Color? page, Color? base, Color? subtle,
    Color? elevated, Color? brandSoft, Color? overlay,
  }) => BgTokens(
    page: page ?? this.page, base: base ?? this.base,
    subtle: subtle ?? this.subtle, elevated: elevated ?? this.elevated,
    brandSoft: brandSoft ?? this.brandSoft, overlay: overlay ?? this.overlay,
  );

  BgTokens lerp(BgTokens other, double t) => BgTokens(
    page:      Color.lerp(page, other.page, t)!,
    base:      Color.lerp(base, other.base, t)!,
    subtle:    Color.lerp(subtle, other.subtle, t)!,
    elevated:  Color.lerp(elevated, other.elevated, t)!,
    brandSoft: Color.lerp(brandSoft, other.brandSoft, t)!,
    overlay:   Color.lerp(overlay, other.overlay, t)!,
  );
}

@immutable
class BorderTokens {
  const BorderTokens({
    required this.defaultColor,
    required this.divider,
    required this.strong,
    required this.focus,
  });

  final Color defaultColor;
  final Color divider;
  final Color strong;
  final Color focus;

  BorderTokens copyWith({
    Color? defaultColor, Color? divider, Color? strong, Color? focus,
  }) => BorderTokens(
    defaultColor: defaultColor ?? this.defaultColor,
    divider: divider ?? this.divider,
    strong: strong ?? this.strong,
    focus: focus ?? this.focus,
  );

  BorderTokens lerp(BorderTokens other, double t) => BorderTokens(
    defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
    divider:      Color.lerp(divider, other.divider, t)!,
    strong:       Color.lerp(strong, other.strong, t)!,
    focus:        Color.lerp(focus, other.focus, t)!,
  );
}

// ─── AppColorTokens ThemeExtension ──────────────────────────

/// UPay 全量语义颜色 Token，通过 ThemeExtension 注入 ThemeData。
///
/// 使用方式：
/// ```dart
/// final t = Theme.of(context).extension<AppColorTokens>()!;
/// color: t.brand.primary      // 品牌主色
/// color: t.text.title         // 标题文字
/// color: t.text.primary       // 默认主文字（AI 写代码时首选）
/// color: t.bg.page            // 页面背景
/// color: t.status.error       // 错误语义色
/// color: t.finance.income     // 收入金额色
/// color: t.border.focus       // 聚焦边框
/// ```
@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.brand,
    required this.status,
    required this.finance,
    required this.text,
    required this.bg,
    required this.border,
  });

  final BrandTokens brand;
  final StatusTokens status;
  final FinanceTokens finance;
  final TextTokens text;
  final BgTokens bg;
  final BorderTokens border;

  // ── Light 预设 ───────────────────────────────────────────
  static const light = AppColorTokens(
    brand: BrandTokens(
      primary:      UPayColors.brandPrimary,
      primaryHover: UPayColors.brandPrimaryHover,
      primarySoft:  UPayColors.brandPrimarySoftLight,
      primaryCta:   UPayColors.brandPrimaryCta,
      secondary:    UPayColors.brandSecondaryLight,
    ),
    status: StatusTokens(
      success:     UPayColors.statusSuccess,
      successSoft: UPayColors.statusSuccessSoftLight,
      warning:     UPayColors.statusWarning,
      warningSoft: UPayColors.statusWarningSoftLight,
      error:       UPayColors.statusError,
      errorSoft:   UPayColors.statusErrorSoftLight,
      neutral:     UPayColors.statusNeutralLight,
      neutralSoft: UPayColors.statusNeutralSoftLight,
    ),
    finance: FinanceTokens(
      income:  UPayColors.financeIncome,
      expense: UPayColors.financeExpense,
      pending: UPayColors.financePending,
      refund:  UPayColors.financeRefund,
      frozen:  UPayColors.financeFrozenLight,
    ),
    text: TextTokens(
      title:        UPayColors.textPrimaryLight,
      body:         UPayColors.textPrimaryLight,
      primary:      UPayColors.textPrimaryLight,
      secondary:    UPayColors.textSecondaryLight,
      muted:        UPayColors.textTertiaryLight,
      disabled:     UPayColors.textDisabledLight,
      inverse:      UPayColors.textInverseLight,
      link:         UPayColors.textLink,
      income:       UPayColors.textIncome,
      expense:      UPayColors.textExpense,
      pending:      UPayColors.textPending,
      error:        UPayColors.textError,
      onPrimaryCta: UPayColors.textOnPrimaryCta,
    ),
    bg: BgTokens(
      page:      UPayColors.bgPageLight,
      base:      UPayColors.bgBaseLight,
      subtle:    UPayColors.bgSubtleLight,
      elevated:  UPayColors.bgElevatedLight,
      brandSoft: UPayColors.bgBrandSoftLight,
      overlay:   UPayColors.bgOverlayLight,
    ),
    border: BorderTokens(
      defaultColor: UPayColors.borderDefaultLight,
      divider:      UPayColors.borderDividerLight,
      strong:       UPayColors.borderStrongLight,
      focus:        UPayColors.borderFocus,
    ),
  );

  // ── Dark 预设 ────────────────────────────────────────────
  static const dark = AppColorTokens(
    brand: BrandTokens(
      primary:      UPayColors.brandPrimary,
      primaryHover: UPayColors.brandPrimaryHover,
      primarySoft:  UPayColors.brandPrimarySoftDark,
      primaryCta:   UPayColors.brandPrimaryCta,
      secondary:    UPayColors.brandSecondaryDark,
    ),
    status: StatusTokens(
      success:     UPayColors.statusSuccess,
      successSoft: UPayColors.statusSuccessSoftDark,
      warning:     UPayColors.statusWarning,
      warningSoft: UPayColors.statusWarningSoftDark,
      error:       UPayColors.statusError,
      errorSoft:   UPayColors.statusErrorSoftDark,
      neutral:     UPayColors.statusNeutralDark,
      neutralSoft: UPayColors.statusNeutralSoftDark,
    ),
    finance: FinanceTokens(
      income:  UPayColors.financeIncome,
      expense: UPayColors.financeExpense,
      pending: UPayColors.financePending,
      refund:  UPayColors.financeRefund,
      frozen:  UPayColors.financeFrozenDark,
    ),
    text: TextTokens(
      title:        UPayColors.textPrimaryDark,
      body:         UPayColors.textPrimaryDark,
      primary:      UPayColors.textPrimaryDark,
      secondary:    UPayColors.textSecondaryDark,
      muted:        UPayColors.textTertiaryDark,
      disabled:     UPayColors.textDisabledDark,
      inverse:      UPayColors.textInverseDark,
      link:         UPayColors.textLink,
      income:       UPayColors.textIncome,
      expense:      UPayColors.textExpense,
      pending:      UPayColors.textPending,
      error:        UPayColors.textError,
      onPrimaryCta: UPayColors.textOnPrimaryCta,
    ),
    bg: BgTokens(
      page:      UPayColors.bgPageDark,
      base:      UPayColors.bgBaseDark,
      subtle:    UPayColors.bgSubtleDark,
      elevated:  UPayColors.bgElevatedDark,
      brandSoft: UPayColors.bgBrandSoftDark,
      overlay:   UPayColors.bgOverlayDark,
    ),
    border: BorderTokens(
      defaultColor: UPayColors.borderDefaultDark,
      divider:      UPayColors.borderDividerDark,
      strong:       UPayColors.borderStrongDark,
      focus:        UPayColors.borderFocus,
    ),
  );

  @override
  AppColorTokens copyWith({
    BrandTokens? brand, StatusTokens? status, FinanceTokens? finance,
    TextTokens? text, BgTokens? bg, BorderTokens? border,
  }) => AppColorTokens(
    brand:   brand   ?? this.brand,
    status:  status  ?? this.status,
    finance: finance ?? this.finance,
    text:    text    ?? this.text,
    bg:      bg      ?? this.bg,
    border:  border  ?? this.border,
  );

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) return this;
    return AppColorTokens(
      brand:   brand.lerp(other.brand, t),
      status:  status.lerp(other.status, t),
      finance: finance.lerp(other.finance, t),
      text:    text.lerp(other.text, t),
      bg:      bg.lerp(other.bg, t),
      border:  border.lerp(other.border, t),
    );
  }

  // ── Shimmer 颜色（供 AppSkeleton 使用）──────────────────
  Color get shimmerBase      => bg.subtle;
  Color get shimmerHighlight => bg.base;

  // ── 旧字段向后兼容（已废弃）──────────────────────────────
  @Deprecated('请使用 bg.elevated') Color get cardBackground => bg.elevated;
  @Deprecated('请使用 border.divider') Color get divider => border.divider;
  @Deprecated('请使用 border.defaultColor') Color get inputBorder => border.defaultColor;
  @Deprecated('请使用 bg.subtle') Color get inputFill => bg.subtle;
}
