import 'package:flutter/material.dart';

/// UPay 圆角 Token — 8 档，对应 UPay Design System v1.0.5 radius 规范。
///
/// | Token | 值    | 用途                        |
/// |-------|-------|-----------------------------|
/// | xs    | 2pt   | 细小标签、装饰性点状元素      |
/// | s     | 4pt   | 小按钮（S 尺寸）、小元素      |
/// | sm    | 8pt   | 按钮（M/L/XL）、输入框、Toast |
/// | md    | 12pt  | 卡片、列表项                 |
/// | lg    | 16pt  | 大卡片、Section 容器         |
/// | xl    | 20pt  | 大卡片、Alert                |
/// | r2xl  | 24pt  | Bottom Sheet                 |
/// | full  | 9999pt| 胶囊按钮、头像、圆形图标      |
abstract final class AppRadius {
  // ── BorderRadius 常量 ───────────────────────────────────────
  static const BorderRadius xs   = BorderRadius.all(Radius.circular(2));
  static const BorderRadius s    = BorderRadius.all(Radius.circular(4));
  static const BorderRadius sm   = BorderRadius.all(Radius.circular(8));
  static const BorderRadius md   = BorderRadius.all(Radius.circular(12));
  static const BorderRadius lg   = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xl   = BorderRadius.all(Radius.circular(20));
  static const BorderRadius r2xl = BorderRadius.all(Radius.circular(24));
  static const BorderRadius full = BorderRadius.all(Radius.circular(9999));

  // ── Radius 常量（用于 ClipRRect / decoration 等）────────────
  static const Radius radiusXs   = Radius.circular(2);
  static const Radius radiusS    = Radius.circular(4);
  static const Radius radiusSm   = Radius.circular(8);
  static const Radius radiusMd   = Radius.circular(12);
  static const Radius radiusLg   = Radius.circular(16);
  static const Radius radiusXl   = Radius.circular(20);
  static const Radius radius2xl  = Radius.circular(24);
  static const Radius radiusFull = Radius.circular(9999);

  // ── 旧字段别名（已废弃）────────────────────────────────────
  @Deprecated('请使用 s')    static const BorderRadius xxl = r2xl;
}
