import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_color_tokens.dart';

/// 骨架屏加载占位组件。
///
/// 通过闪烁动画模拟内容加载中的状态，从 AppColorTokens 读取颜色。
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 在 build 中动态读取主题色 Token，确保主题切换时能正确响应
    final tokens = Theme.of(context).extension<AppColorTokens>() ??
        AppColorTokens.light;
    final colorAnimation = ColorTween(
      begin: tokens.shimmerBase,
      end: tokens.shimmerHighlight,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    return Semantics(
      label: '加载中',
      child: AnimatedBuilder(
        animation: colorAnimation,
        builder: (_, __) => Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: colorAnimation.value,
            borderRadius: widget.borderRadius ?? AppRadius.md,
          ),
        ),
      ),
    );
  }
}

/// 骨架屏行（多行文字占位）。
///
/// lines 控制行数，lineSpacing 控制行间距（默认 AppSpacing.sm）。
class AppSkeletonText extends StatelessWidget {
  const AppSkeletonText({
    super.key,
    this.lines = 3,
    this.lineSpacing,
  });

  final int lines;
  final double? lineSpacing;

  @override
  Widget build(BuildContext context) {
    final spacing = lineSpacing ?? AppSpacing.sm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines * 2 - 1, (i) {
        if (i.isOdd) return SizedBox(height: spacing);
        final lineIndex = i ~/ 2;
        // 最后一行稍短，模拟真实文字段落
        final isLast = lineIndex == lines - 1;
        if (isLast) {
          return FractionallySizedBox(
            widthFactor: 0.6,
            alignment: Alignment.centerLeft,
            child: AppSkeleton(
              width: double.infinity,
              height: AppSpacing.md,
              borderRadius: AppRadius.sm,
            ),
          );
        }
        return AppSkeleton(
          width: double.infinity,
          height: AppSpacing.md,
          borderRadius: AppRadius.sm,
        );
      }),
    );
  }
}
