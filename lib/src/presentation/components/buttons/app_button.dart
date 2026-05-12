import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;

    final (bg, fg, border) = switch (variant) {
      AppButtonVariant.primary => (
        theme.colorScheme.primary,
        theme.colorScheme.onPrimary,
        null,
      ),
      AppButtonVariant.secondary => (
        theme.colorScheme.secondaryContainer,
        theme.colorScheme.onSecondaryContainer,
        null,
      ),
      AppButtonVariant.outline => (
        Colors.transparent,
        theme.colorScheme.primary,
        theme.colorScheme.primary,
      ),
      AppButtonVariant.ghost => (
        Colors.transparent,
        theme.colorScheme.primary,
        null,
      ),
      AppButtonVariant.danger => (
        theme.colorScheme.error,
        theme.colorScheme.onError,
        null,
      ),
    };

    final (hPad, vPad, fontSize) = switch (size) {
      AppButtonSize.small => (12.0, 6.0, 12.0),
      AppButtonSize.medium => (16.0, 10.0, 14.0),
      AppButtonSize.large => (24.0, 14.0, 16.0),
    };

    Widget child = isLoading
        ? SizedBox(
            width: fontSize,
            height: fontSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: fg,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 6)],
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          );

    return AnimatedOpacity(
      opacity: isDisabled ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Material(
        color: bg,
        borderRadius: border == null
            ? const BorderRadius.all(Radius.circular(8))
            : null,
        shape: border != null
            ? RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: border),
              )
            : null,
        child: InkWell(
          onTap: effectiveOnPressed,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: child,
          ),
        ),
      ),
    );
  }
}
