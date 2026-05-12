import 'package:flutter/material.dart';
import 'app_theme_mode.dart';

/// [AppThemeMode] 的 Flutter 桥接扩展。
///
/// 将框架内部的 [AppThemeMode] 枚举转换为 Flutter 原生的 [ThemeMode]，
/// 供 [MaterialApp] 的 `themeMode` 参数直接使用。
///
/// 示例：
/// ```dart
/// MaterialApp.router(
///   theme: AppTheme.light(),
///   darkTheme: AppTheme.dark(),
///   themeMode: ref.watch(themeModeProvider).toFlutterThemeMode(),
/// )
/// ```
extension AppThemeModeX on AppThemeMode {
  /// 转换为 Flutter 原生 [ThemeMode]。
  ThemeMode toFlutterThemeMode() => switch (this) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      };
}
