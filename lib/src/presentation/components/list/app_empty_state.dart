import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/app_button.dart';

/// 空状态占位组件。
///
/// 通常在列表无数据、搜索无结果等场景使用。
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? action;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: subtitle != null ? '$title. $subtitle' : title,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    size: AppSpacing.xxxl,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  child: icon!,
                ),
                const SizedBox(height: AppSpacing.space5),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.title1.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.space3),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: AppSpacing.space7),
                action!,
              ] else if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.space7),
                AppButton(
                  label: actionLabel!,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
