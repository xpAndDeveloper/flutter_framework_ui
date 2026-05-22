import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';

/// 标准间距盒子，只使用 AppSpacing 常量。
///
/// 支持具名构造函数快速创建标准尺寸，也支持自定义 width/height。
class AppSpacingBox extends StatelessWidget {
  /// 自定义尺寸
  const AppSpacingBox({super.key, this.width, this.height});

  /// xs 间距（4）
  const AppSpacingBox.xs({super.key})
      : width = AppSpacing.space2,
        height = AppSpacing.space2;

  /// sm 间距（8）
  const AppSpacingBox.sm({super.key})
      : width = AppSpacing.space3,
        height = AppSpacing.space3;

  /// md 间距（16）
  const AppSpacingBox.md({super.key})
      : width = AppSpacing.space5,
        height = AppSpacing.space5;

  /// lg 间距（24）
  const AppSpacingBox.lg({super.key})
      : width = AppSpacing.space7,
        height = AppSpacing.space7;

  /// xl 间距（32）
  const AppSpacingBox.xl({super.key})
      : width = AppSpacing.space8,
        height = AppSpacing.space8;

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}
