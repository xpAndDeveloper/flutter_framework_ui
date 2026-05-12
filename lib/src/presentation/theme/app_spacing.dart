/// UPay 间距刻度 — 4pt Base / 8pt Major，共 12 档。
///
/// 使用 space1~space12 而非语义命名，避免不同场景对"小/中/大"理解不一致。
/// 常用对照：
///   页面左右边距（手机）  = space5  (16pt)
///   卡片内边距（默认）    = space5  (16pt)
///   卡片间距             = space4  (12pt)
///   区块间距             = space7  (24pt)
///   组件最小垂直间距      = space2  (4pt)
abstract final class AppSpacing {
  static const double space1  = 2.0;
  static const double space2  = 4.0;
  static const double space3  = 8.0;
  static const double space4  = 12.0;
  static const double space5  = 16.0;
  static const double space6  = 20.0;
  static const double space7  = 24.0;
  static const double space8  = 32.0;
  static const double space9  = 40.0;
  static const double space10 = 48.0;
  static const double space11 = 60.0;
  static const double space12 = 80.0;

  // ── 旧字段别名（已废弃）────────────────────────────────────
  @Deprecated('请使用 space2') static const double xs   = space2;
  @Deprecated('请使用 space3') static const double sm   = space3;
  @Deprecated('请使用 space5') static const double md   = space5;
  @Deprecated('请使用 space7') static const double lg   = space7;
  @Deprecated('请使用 space8') static const double xl   = space8;
  @Deprecated('请使用 space10') static const double xxl  = space10;
  static const double xxxl = 64.0; // 旧值，无对应刻度，保留向后兼容
}
