import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_radius.dart';

/// Toast 显示位置
enum AppToastPosition { top, center, bottom }

/// 轻量级 Toast 提示（叠加在界面上方，不占用 SnackBar 位置）。
///
/// 使用 OverlayEntry 实现，自动在 duration 后消失。
class AppToast {
  AppToast._();

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    AppToastPosition position = AppToastPosition.bottom,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AppToastOverlay(
        message: message,
        position: position,
        onDismiss: () => entry.remove(),
        duration: duration,
      ),
    );
    overlay.insert(entry);
  }
}

class _AppToastOverlay extends StatefulWidget {
  const _AppToastOverlay({
    required this.message,
    required this.position,
    required this.onDismiss,
    required this.duration,
  });

  final String message;
  final AppToastPosition position;
  final VoidCallback onDismiss;
  final Duration duration;

  @override
  State<_AppToastOverlay> createState() => _AppToastOverlayState();
}

class _AppToastOverlayState extends State<_AppToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AlignmentGeometry get _alignment => switch (widget.position) {
        AppToastPosition.top => Alignment.topCenter,
        AppToastPosition.center => Alignment.center,
        AppToastPosition.bottom => Alignment.bottomCenter,
      };

  EdgeInsetsGeometry get _padding => switch (widget.position) {
        AppToastPosition.top =>
          const EdgeInsets.only(top: AppSpacing.space10 + AppSpacing.space8),
        AppToastPosition.center => EdgeInsets.zero,
        AppToastPosition.bottom =>
          const EdgeInsets.only(bottom: AppSpacing.space10 + AppSpacing.space8),
      };

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Padding(
          padding: _padding,
          child: Align(
            alignment: _alignment,
            child: FadeTransition(
              opacity: _opacity,
              child: Semantics(
                liveRegion: true,
                label: widget.message,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width - AppSpacing.space10,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space5,
                    vertical: AppSpacing.space3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937).withValues(alpha: 0.9),
                    borderRadius: AppRadius.s,
                  ),
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppPrimitiveColors.textInverseLight,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
