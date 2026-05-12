import 'package:flutter/material.dart';

/// UPay 阴影 Token — 对应 UPay Design System v1.0.5 shadow 规范。
///
/// Dark 模式所有阴影统一为空列表（等效 CSS `none`），通过背景层级和边框区分层次。
///
/// 使用方式：
/// ```dart
/// // 根据当前主题选择阴影
/// final isDark = Theme.of(context).brightness == Brightness.dark;
/// BoxDecoration(boxShadow: isDark ? AppShadow.smDark : AppShadow.smLight)
///
/// // 或借助辅助方法
/// BoxDecoration(boxShadow: AppShadow.sm(context))
/// ```
abstract final class AppShadow {
  // ── sm：卡片默认阴影 ─────────────────────────────────────────
  static List<BoxShadow> get smLight => const [
    BoxShadow(
      color: Color(0x0F0F121E),  // rgba(15,18,30,.06)
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A0F121E),  // rgba(15,18,30,.04)
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  static List<BoxShadow> get smDark => const [];

  // ── md：悬浮卡片阴影 ─────────────────────────────────────────
  static List<BoxShadow> get mdLight => const [
    BoxShadow(
      color: Color(0x140F121E),  // rgba(15,18,30,.08)
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0D0F121E),  // rgba(15,18,30,.05)
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  static List<BoxShadow> get mdDark => const [];

  // ── lg：弹层阴影 ──────────────────────────────────────────────
  static List<BoxShadow> get lgLight => const [
    BoxShadow(
      color: Color(0x1E0F121E),  // rgba(15,18,30,.12)
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x0F0F121E),  // rgba(15,18,30,.06)
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  static List<BoxShadow> get lgDark => const [];

  // ── xl：模态框阴影 ────────────────────────────────────────────
  static List<BoxShadow> get xlLight => const [
    BoxShadow(
      color: Color(0x290F121E),  // rgba(15,18,30,.16)
      blurRadius: 48,
      offset: Offset(0, 24),
    ),
    BoxShadow(
      color: Color(0x140F121E),  // rgba(15,18,30,.08)
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
  static List<BoxShadow> get xlDark => const [];

  // ── brand：主按钮悬浮阴影 ─────────────────────────────────────
  static List<BoxShadow> get brandLight => const [
    BoxShadow(
      color: Color(0x5900BD8D),  // rgba(0,189,141,.35)
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
  static List<BoxShadow> get brandDark => const [];

  // ── success：支付成功状态阴影 ─────────────────────────────────
  static List<BoxShadow> get successLight => const [
    BoxShadow(
      color: Color(0x4700BD8D),  // rgba(0,189,141,.28)
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
  static List<BoxShadow> get successDark => const [];

  // ── 主题感知辅助方法 ──────────────────────────────────────────

  static List<BoxShadow> sm(BuildContext context) =>
      _isDark(context) ? smDark : smLight;

  static List<BoxShadow> md(BuildContext context) =>
      _isDark(context) ? mdDark : mdLight;

  static List<BoxShadow> lg(BuildContext context) =>
      _isDark(context) ? lgDark : lgLight;

  static List<BoxShadow> xl(BuildContext context) =>
      _isDark(context) ? xlDark : xlLight;

  static List<BoxShadow> brand(BuildContext context) =>
      _isDark(context) ? brandDark : brandLight;

  static List<BoxShadow> success(BuildContext context) =>
      _isDark(context) ? successDark : successLight;

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
