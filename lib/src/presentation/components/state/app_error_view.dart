import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/app_button.dart';

/// 错误状态展示组件。
///
/// 用于网络异常、加载失败等场景，支持重试回调。
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = '重试',
    this.icon,
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: message,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon ??
                  Icon(
                    Icons.error_outline_rounded,
                    size: AppSpacing.xxxl,
                    color: theme.colorScheme.error,
                  ),
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: retryLabel,
                  variant: AppButtonVariant.outline,
                  onPressed: onRetry,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: AppSpacing.md,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
