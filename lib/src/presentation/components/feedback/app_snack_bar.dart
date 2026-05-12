import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_radius.dart';

/// SnackBar 类型
enum AppSnackBarType { info, success, warning, error }

/// SnackBar 工具类（不是 Widget，是静态方法工具）。
///
/// 通过 ScaffoldMessenger 显示，不侵占组件树。
class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context,
    String message, {
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final (bgColor, iconData) = switch (type) {
      AppSnackBarType.info => (AppColors.info, Icons.info_outline),
      AppSnackBarType.success => (AppColors.success, Icons.check_circle_outline),
      AppSnackBarType.warning => (AppColors.warning, Icons.warning_amber_outlined),
      AppSnackBarType.error => (AppColors.error, Icons.error_outline),
    };

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        content: Semantics(
          liveRegion: true,
          label: message,
          child: Row(
            children: [
              Icon(iconData, color: AppColors.white, size: AppSpacing.md + AppSpacing.xs),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
        action: (actionLabel != null && onAction != null)
            ? SnackBarAction(
                label: actionLabel,
                textColor: AppColors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) =>
      show(context, message, type: AppSnackBarType.success);

  static void showError(BuildContext context, String message) =>
      show(context, message, type: AppSnackBarType.error);

  static void showWarning(BuildContext context, String message) =>
      show(context, message, type: AppSnackBarType.warning);
}
