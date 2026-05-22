import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_radius.dart';
import '../buttons/app_button.dart';

/// 标准对话框组件。
///
/// 支持：标题、内容区域（Widget）、操作按钮列表。
/// 业务逻辑通过回调传入，组件本身无副作用。
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.title,
    required this.content,
    this.actions = const [],
    this.barrierDismissible = true,
  });

  final String? title;
  final Widget content;
  final List<Widget> actions;
  final bool barrierDismissible;

  /// 便捷方法：显示对话框
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget content,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppDialog(
        title: title,
        content: content,
        actions: actions,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// 便捷方法：显示确认对话框（确认 + 取消）
  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '确认',
    String cancelText = '取消',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AppDialog(
        title: title,
        content: Text(message, style: AppTextStyles.body),
        actions: [
          AppButton(
            label: cancelText,
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          AppButton(
            label: confirmText,
            variant: isDestructive
                ? AppButtonVariant.danger
                : AppButtonVariant.primary,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: title ?? '对话框',
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: AppTextStyles.title1.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.space5),
              ],
              DefaultTextStyle(
                style: AppTextStyles.body.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                child: content,
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions
                      .map(
                        (action) => Padding(
                          padding: const EdgeInsets.only(left: AppSpacing.space3),
                          child: action,
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
