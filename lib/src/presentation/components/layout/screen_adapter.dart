import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

export 'package:flutter_screenutil/flutter_screenutil.dart'
    show ScreenUtil, ScreenUtilInit, SizeExtension;

/// 屏幕适配工具 — 基于 flutter_screenutil 实现。
///
/// 推荐用法：在 MaterialApp 外层包裹 [ScreenUtilInit]：
/// ```dart
/// ScreenUtilInit(
///   designSize: const Size(375, 812),
///   builder: (context, child) => MaterialApp(...),
/// )
/// ```
///
/// 也可使用数字扩展直接换算：
/// ```dart
/// width: 100.w   // 设计稿 100px 宽度
/// height: 50.h   // 设计稿 50px 高度
/// fontSize: 14.sp
/// borderRadius: BorderRadius.circular(8.r)
/// ```
class ScreenAdapter {
  ScreenAdapter._();

  /// 初始化（兼容旧 API）— 推荐改用 ScreenUtilInit wrapper。
  ///
  /// 注意：仅当 ScreenUtil 已通过 ScreenUtilInit 初始化后才有效。
  static void init(
    BuildContext context, {
    double designWidth = 375.0,
    double designHeight = 812.0,
  }) {
    // flutter_screenutil 通过 ScreenUtilInit 初始化，此方法作兼容保留
  }

  /// 将设计稿宽度（px）换算为设备逻辑像素
  static double w(double designPx) => designPx.w;

  /// 将设计稿高度（px）换算为设备逻辑像素
  static double h(double designPx) => designPx.h;

  /// 将设计稿字体大小（px）换算为设备逻辑像素
  static double sp(double designPx, {bool followTextScaler = true}) =>
      followTextScaler ? designPx.sp : designPx.sp;

  /// 等比缩放（宽高取较小值）
  static double r(double designPx) => designPx.r;

  /// 当前设备逻辑宽度
  static double get screenWidth => ScreenUtil().screenWidth;

  /// 当前设备逻辑高度
  static double get screenHeight => ScreenUtil().screenHeight;

  /// 宽度缩放比
  static double get scaleWidth => ScreenUtil().scaleWidth;

  /// 高度缩放比
  static double get scaleHeight => ScreenUtil().scaleHeight;
}
