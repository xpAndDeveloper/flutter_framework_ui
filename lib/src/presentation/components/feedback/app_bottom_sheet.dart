import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_color_tokens.dart';

/// 标准底部面板组件。
///
/// 支持可选标题、拖拽手柄，滚动控制由调用方决定。
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showDragHandle = true,
    this.isScrollControlled = true,
  });

  final Widget child;
  final String? title;
  final bool showDragHandle;
  final bool isScrollControlled;

  /// 便捷方法：显示底部面板
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool showDragHandle = true,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (_) => AppBottomSheet(
        title: title,
        showDragHandle: showDragHandle,
        isScrollControlled: isScrollControlled,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppColorTokens>();
    final bgColor = tokens?.bg.elevated ?? theme.colorScheme.surface;

    return Semantics(
      label: title ?? '底部面板',
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDragHandle) ...[
              const SizedBox(height: AppSpacing.space3),
              Container(
                width: AppSpacing.xxxl,
                height: AppSpacing.space2,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: AppRadius.full,
                ),
              ),
            ],
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.space7,
                  AppSpacing.space5,
                  AppSpacing.space7,
                  AppSpacing.space3,
                ),
                child: Text(
                  title!,
                  style: AppTextStyles.title1.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: AppSpacing.space3),
            ],
            Flexible(child: child),
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }
}
