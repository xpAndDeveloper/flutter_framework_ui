/// UPay 字阶 Token — 对应 UPay Design System v1.0.5 字体规范。
///
/// ## 字体族
/// 设计稿基线：Roboto / Source Han Sans SC
/// 运行时完整回退链：Roboto → Source Han Sans SC → Noto Sans SC → system-ui
///
/// ## ScreenAdapter 适配
/// 此文件中所有 fontSize 均为设计稿 pt 值（逻辑像素），**不在 Token 层做运行时换算**。
/// 如需 ScreenAdapter 适配，调用方按需转换：
/// ```dart
/// // 方式 1：copyWith
/// AppTextStyles.body.copyWith(fontSize: ScreenAdapter.sp(14))
/// // 方式 2：扩展语法糖
/// AppTextStyles.body.copyWith(fontSize: 14.sp)
/// ```
///
/// ## 字阶速查
/// | Token       | size/lh | weight | 用途          |
/// |-------------|---------|--------|---------------|
/// | display     | 32/32   | 700    | 大数字展示     |
/// | title1      | 18/18   | 600    | 一级标题       |
/// | title2      | 16/16   | 600    | 页面主标题     |
/// | title3      | 14/14   | 600    | 导航/模块标题  |
/// | headline    | 14/14   | 600    | 列表标题       |
/// | body        | 14/20   | 400    | 正文           |
/// | subhead     | 12/16   | 400    | 次级说明       |
/// | footnote    | 12/16   | 400    | 辅助说明       |
/// | footnote2   | 10/12   | 400    | 数字角标       |
/// | caption1    | 12/16   | 400+0.1| 标签/时间戳    |
/// | caption2    | 10/12   | 400+0.1| 紧凑按钮文案   |
///
/// 金额特规（amount*）独立于通用字阶，固定使用 Roboto 字体。
library;

import 'package:flutter/material.dart';

// ── 字体族常量 ─────────────────────────────────────────────────
const String _fontFamily = 'Roboto';
const List<String> _fontFamilyFallback = [
  'Source Han Sans SC',
  'Noto Sans SC',
  'PingFang SC',
  'system-ui',
  '-apple-system',
  'BlinkMacSystemFont',
  'Segoe UI',
  'sans-serif',
];

// ── 通用字阶 ───────────────────────────────────────────────────
abstract final class AppTextStyles {
  /// 32pt / 行高 1.0 / Bold 700 — 强强调展示、大数字
  static const TextStyle display = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 32,
    height: 1.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  /// 18pt / 行高 1.0 / Semibold 600 — 一级标题、主强调文本
  static const TextStyle title1 = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 18,
    height: 1.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// 16pt / 行高 1.0 / Semibold 600 — 页面主标题、次级强调
  static const TextStyle title2 = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 16,
    height: 1.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// 14pt / 行高 1.0 / Semibold 600 — 导航标题、模块标题
  static const TextStyle title3 = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 14,
    height: 1.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// 14pt / 行高 1.0 / Semibold 600 — 列表标题、重点内容
  static const TextStyle headline = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 14,
    height: 1.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  /// 14pt / 行高 ≈1.43 / Regular 400 — 正文内容
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// 12pt / 行高 ≈1.33 / Regular 400 — 次级说明（默认单行）
  static const TextStyle subhead = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// 12pt / 行高 ≈1.33 / Regular 400 — 表单辅助说明、列表元信息
  static const TextStyle footnote = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// 10pt / 行高 1.2 / Regular 400 — 数字角标、极短提示
  static const TextStyle footnote2 = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 10,
    height: 12 / 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  /// 12pt / 行高 ≈1.33 / Regular 400 / tracking 0.1 — 标签、时间戳
  static const TextStyle caption1 = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );

  /// 10pt / 行高 1.2 / Regular 400 / tracking 0.1 — 最小辅助信息、紧凑按钮
  /// S 按钮（≤4 汉字）使用此字阶，超过 4 字须升级为 M（footnote）
  static const TextStyle caption2 = TextStyle(
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
    fontSize: 10,
    height: 12 / 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );

  // ── 金额特规（固定 Roboto，不跟随平台字体）──────────────────

  /// 32pt / 行高 1.0 / Bold 700 — 支付完成主金额
  static const TextStyle amountComplete = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    height: 1.0,
    fontWeight: FontWeight.w700,
  );

  /// 28pt / 行高 1.0 / Semibold 600 — 首页余额
  static const TextStyle amountBalance = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    height: 1.0,
    fontWeight: FontWeight.w600,
  );

  /// 24pt / 行高 1.0 / Semibold 600 — 转账确认金额
  static const TextStyle amountConfirm = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    height: 1.0,
    fontWeight: FontWeight.w600,
  );

  /// 32pt / 行高 1.0 / Semibold 600 — 金额输入框
  static const TextStyle amountInput = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    height: 1.0,
    fontWeight: FontWeight.w600,
  );

  /// 14pt / 行高 1.0 / Semibold 600 — 列表金额
  static const TextStyle amountList = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    height: 1.0,
    fontWeight: FontWeight.w600,
  );

  /// 12pt / 行高 ≈1.33 / Medium 500 — 小金额
  static const TextStyle amountSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );

  /// 10pt / 行高 1.2 / Medium 500 — 费率
  static const TextStyle amountRate = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    height: 12 / 10,
    fontWeight: FontWeight.w500,
  );

  // ── 旧字阶别名（已废弃）────────────────────────────────────
  @Deprecated('请使用 display') static const headingXl = display;
  @Deprecated('请使用 title1') static const headingSm = title1;
  @Deprecated('请使用 body') static const bodyMd = body;
  @Deprecated('请使用 subhead') static const bodySm = subhead;
  @Deprecated('请使用 caption2') static const caption = caption2;
  static const headingLg = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3);
  static const headingMd = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4);
  static const bodyLg    = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static const labelLg   = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const labelMd   = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static const labelSm   = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
}
