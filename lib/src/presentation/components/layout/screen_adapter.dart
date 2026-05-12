import 'package:flutter/material.dart';

/// 手机端屏幕适配工具 — 基于设计稿尺寸换算为真实逻辑像素
///
/// 使用方式：
/// ```dart
/// // 1. 在 MaterialApp 根节点处初始化（通常放在首个 Widget build 中）
/// ScreenAdapter.init(context);
///
/// // 2. 使用换算方法
/// width:  100.w  // 设计稿 100px 宽度
/// height: 50.h   // 设计稿 50px 高度
/// fontSize: 14.sp // 字体大小（自动跟随系统字体缩放）
/// borderRadius: BorderRadius.circular(8.r) // 圆角
/// ```
///
/// 默认设计稿基准为 750px 宽度（2x Retina）。
/// 若需修改基准，在 [init] 时传入 [designWidth] / [designHeight]。
class ScreenAdapter {
  ScreenAdapter._();

  /// 设计稿基准宽度（默认 750px）
  static double _designWidth = 750.0;

  /// 设计稿基准高度（默认 1334px，iPhone 8 标准）
  static double _designHeight = 1334.0;

  /// 当前设备屏幕宽度（逻辑像素）
  static double _screenWidth = 375.0;

  /// 当前设备屏幕高度（逻辑像素）
  static double _screenHeight = 667.0;

  /// 系统字体缩放比
  static double _textScaleFactor = 1.0;

  /// 宽度缩放比
  static double get _scaleWidth => _screenWidth / _designWidth;

  /// 高度缩放比
  static double get _scaleHeight => _screenHeight / _designHeight;

  /// 初始化：在根 Widget 的 build 中调用一次
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   ScreenAdapter.init(context);
  ///   return MaterialApp(...);
  /// }
  /// ```
  static void init(
    BuildContext context, {
    double designWidth = 750.0,
    double designHeight = 1334.0,
  }) {
    _designWidth = designWidth;
    _designHeight = designHeight;

    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;

    // 始终以竖屏方向为基准（取宽高中较小值作为宽度基准）
    _screenWidth = size.width < size.height ? size.width : size.height;
    _screenHeight = size.width < size.height ? size.height : size.width;

    _textScaleFactor = mediaQuery.textScaler.scale(1.0);
  }

  /// 将设计稿宽度（px）换算为设备逻辑像素
  static double w(double designPx) => designPx * _scaleWidth;

  /// 将设计稿高度（px）换算为设备逻辑像素
  static double h(double designPx) => designPx * _scaleHeight;

  /// 将设计稿字体大小（px）换算为设备逻辑像素
  ///
  /// [followTextScaler] 是否跟随系统字体缩放（默认 true，可访问性友好）
  static double sp(double designPx, {bool followTextScaler = true}) {
    final scaled = designPx * _scaleWidth;
    return followTextScaler ? scaled : scaled / _textScaleFactor;
  }

  /// 等比缩放 — 取宽/高缩放比的较小值，适用于图标、圆角等
  static double r(double designPx) =>
      designPx * (_scaleWidth < _scaleHeight ? _scaleWidth : _scaleHeight);

  /// 当前设备逻辑宽度
  static double get screenWidth => _screenWidth;

  /// 当前设备逻辑高度
  static double get screenHeight => _screenHeight;

  /// 宽度缩放比（只读，用于调试）
  static double get scaleWidth => _scaleWidth;

  /// 高度缩放比（只读，用于调试）
  static double get scaleHeight => _scaleHeight;
}

/// 数字扩展 — 语法糖，让换算更简洁
///
/// ```dart
/// Container(
///   width: 100.w,
///   height: 50.h,
///   child: Text('Hello', style: TextStyle(fontSize: 14.sp)),
/// )
/// ```
extension ScreenAdapterNumExt on num {
  /// 设计稿宽度（px）→ 设备逻辑像素
  double get w => ScreenAdapter.w(toDouble());

  /// 设计稿高度（px）→ 设备逻辑像素
  double get h => ScreenAdapter.h(toDouble());

  /// 设计稿字体大小（px）→ 设备逻辑像素（跟随系统字体缩放）
  double get sp => ScreenAdapter.sp(toDouble());

  /// 设计稿字体大小（px）→ 设备逻辑像素（忽略系统字体缩放）
  double get spFixed => ScreenAdapter.sp(toDouble(), followTextScaler: false);

  /// 等比缩放（宽高取较小值）
  double get r => ScreenAdapter.r(toDouble());
}
