import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';

// ---------------------------------------------------------------------------
// AppBubblePopupDirection — 气泡方向枚举
// ---------------------------------------------------------------------------

/// 气泡相对于锚点 Widget 的显示方向。
enum AppBubblePopupDirection {
  /// 气泡显示在锚点上方，箭头朝下指向锚点
  top,

  /// 气泡显示在锚点下方，箭头朝上指向锚点
  bottom,

  /// 气泡显示在锚点左侧，箭头朝右指向锚点
  left,

  /// 气泡显示在锚点右侧，箭头朝左指向锚点
  right,
}

// ---------------------------------------------------------------------------
// AppBubbleTrigger — 触发方式枚举
// ---------------------------------------------------------------------------

/// 气泡触发方式。
enum AppBubbleTrigger {
  /// 单击锚点触发
  tap,

  /// 长按锚点触发
  longPress,

  /// 仅通过 [AppBubblePopupController] 手动控制，不绑定手势
  manual,
}

// ---------------------------------------------------------------------------
// AppBubblePopupController — 命令式控制器
// ---------------------------------------------------------------------------

/// 气泡弹出框的命令式控制器。
///
/// 示例：
/// ```dart
/// final _ctrl = AppBubblePopupController();
///
/// AppBubblePopup(
///   controller: _ctrl,
///   triggerMode: AppBubbleTrigger.manual,
///   content: Text('提示内容'),
///   child: IconButton(
///     icon: Icon(Icons.info_outline),
///     onPressed: () => _ctrl.show(),
///   ),
/// )
/// ```
class AppBubblePopupController {
  _AppBubblePopupState? _state;

  bool _isVisible = false;

  /// 当前气泡是否可见
  bool get isVisible => _isVisible;

  /// 显示气泡
  void show() => _state?._show();

  /// 隐藏气泡
  void hide() => _state?._hide();

  void _attach(_AppBubblePopupState state) => _state = state;
  void _detach() => _state = null;
  void _onVisibilityChanged(bool visible) => _isVisible = visible;
}

// ---------------------------------------------------------------------------
// AppBubblePopup — 主 Widget
// ---------------------------------------------------------------------------

/// 气泡弹出框，通过 [Overlay] 在锚点 [child] 旁显示富内容气泡。
///
/// 支持上/下/左/右四个方向，点击外部区域自动关闭。
///
/// 示例：
/// ```dart
/// AppBubblePopup(
///   direction: AppBubblePopupDirection.bottom,
///   content: Padding(
///     padding: EdgeInsets.all(12),
///     child: Text('这是气泡内容'),
///   ),
///   child: Text('点我'),
/// )
/// ```
class AppBubblePopup extends StatefulWidget {
  const AppBubblePopup({
    super.key,
    required this.child,
    required this.content,
    this.direction = AppBubblePopupDirection.bottom,
    this.controller,
    this.triggerMode = AppBubbleTrigger.tap,
  });

  /// 锚点 Widget
  final Widget child;

  /// 气泡内展示的内容 Widget
  final Widget content;

  /// 气泡方向（默认 bottom）
  final AppBubblePopupDirection direction;

  /// 命令式控制器（可选）
  final AppBubblePopupController? controller;

  /// 触发方式（默认 tap）
  final AppBubbleTrigger triggerMode;

  @override
  State<AppBubblePopup> createState() => _AppBubblePopupState();
}

class _AppBubblePopupState extends State<AppBubblePopup> {
  OverlayEntry? _barrierEntry;
  OverlayEntry? _bubbleEntry;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(AppBubblePopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach();
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    _hide();
    widget.controller?._detach();
    super.dispose();
  }

  void _show() {
    if (_visible) return;
    if (!mounted) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final anchorPos = renderBox.localToGlobal(Offset.zero);
    final anchorSize = renderBox.size;
    final overlay = Overlay.of(context);
    final tokens = Theme.of(context).extension<AppColorTokens>();

    // Barrier entry（透明全屏，点击关闭）
    _barrierEntry = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hide,
        child: const SizedBox.expand(),
      ),
    );

    // 气泡 entry
    _bubbleEntry = OverlayEntry(
      builder: (_) => _BubbleOverlay(
        anchorPos: anchorPos,
        anchorSize: anchorSize,
        direction: widget.direction,
        tokens: tokens,
        content: widget.content,
      ),
    );

    overlay.insert(_barrierEntry!);
    overlay.insert(_bubbleEntry!);

    _visible = true;
    widget.controller?._onVisibilityChanged(true);
  }

  void _hide() {
    if (!_visible) return;
    _barrierEntry?.remove();
    _bubbleEntry?.remove();
    _barrierEntry = null;
    _bubbleEntry = null;
    _visible = false;
    widget.controller?._onVisibilityChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    switch (widget.triggerMode) {
      case AppBubbleTrigger.tap:
        child = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _show,
          child: child,
        );
      case AppBubbleTrigger.longPress:
        child = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPress: _show,
          child: child,
        );
      case AppBubbleTrigger.manual:
        break; // 不绑定手势
    }

    return child;
  }
}

// ---------------------------------------------------------------------------
// _BubbleOverlay — 气泡定位层
// ---------------------------------------------------------------------------

class _BubbleOverlay extends StatelessWidget {
  const _BubbleOverlay({
    required this.anchorPos,
    required this.anchorSize,
    required this.direction,
    required this.tokens,
    required this.content,
  });

  final Offset anchorPos;
  final Size anchorSize;
  final AppBubblePopupDirection direction;
  final AppColorTokens? tokens;
  final Widget content;

  static const double _arrowHeight = 8.0;
  static const double _bubbleMaxWidth = 240.0;
  static const double _gap = 4.0;

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _BubbleLayoutDelegate(
        anchorPos: anchorPos,
        anchorSize: anchorSize,
        direction: direction,
        arrowHeight: _arrowHeight,
        gap: _gap,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {}, // 阻止点击穿透到 Barrier
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _bubbleMaxWidth),
          child: _BubbleContainer(
            direction: direction,
            tokens: tokens,
            child: content,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _BubbleLayoutDelegate — SingleChildLayout 定位
// ---------------------------------------------------------------------------

class _BubbleLayoutDelegate extends SingleChildLayoutDelegate {
  const _BubbleLayoutDelegate({
    required this.anchorPos,
    required this.anchorSize,
    required this.direction,
    required this.arrowHeight,
    required this.gap,
  });

  final Offset anchorPos;
  final Size anchorSize;
  final AppBubblePopupDirection direction;
  final double arrowHeight;
  final double gap;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      maxWidth: math.min(240.0, constraints.maxWidth),
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final anchorCenterX = anchorPos.dx + anchorSize.width / 2;
    final anchorCenterY = anchorPos.dy + anchorSize.height / 2;

    return switch (direction) {
      AppBubblePopupDirection.bottom => Offset(
          anchorCenterX - childSize.width / 2,
          anchorPos.dy + anchorSize.height + gap,
        ),
      AppBubblePopupDirection.top => Offset(
          anchorCenterX - childSize.width / 2,
          anchorPos.dy - childSize.height - gap,
        ),
      AppBubblePopupDirection.left => Offset(
          anchorPos.dx - childSize.width - gap,
          anchorCenterY - childSize.height / 2,
        ),
      AppBubblePopupDirection.right => Offset(
          anchorPos.dx + anchorSize.width + gap,
          anchorCenterY - childSize.height / 2,
        ),
    };
  }

  @override
  bool shouldRelayout(_BubbleLayoutDelegate oldDelegate) =>
      anchorPos != oldDelegate.anchorPos ||
      anchorSize != oldDelegate.anchorSize ||
      direction != oldDelegate.direction;
}

// ---------------------------------------------------------------------------
// _BubbleContainer — 气泡容器（背景 + 边框 + 箭头）
// ---------------------------------------------------------------------------

class _BubbleContainer extends StatelessWidget {
  const _BubbleContainer({
    required this.direction,
    required this.tokens,
    required this.child,
  });

  final AppBubblePopupDirection direction;
  final AppColorTokens? tokens;
  final Widget child;

  static const double _arrowH = 8.0;
  static const double _arrowW = 14.0;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        tokens?.bg.elevated ?? Theme.of(context).colorScheme.surfaceContainerHigh;
    final borderColor =
        tokens?.border.defaultColor ??
            Theme.of(context).colorScheme.outlineVariant;

    // 根据方向添加 padding，为箭头留出空间
    final padding = switch (direction) {
      AppBubblePopupDirection.top    => const EdgeInsets.only(bottom: _arrowH),
      AppBubblePopupDirection.bottom => const EdgeInsets.only(top: _arrowH),
      AppBubblePopupDirection.left   => const EdgeInsets.only(right: _arrowH),
      AppBubblePopupDirection.right  => const EdgeInsets.only(left: _arrowH),
    };

    return Padding(
      padding: padding,
      child: CustomPaint(
        painter: _BubblePainter(
          direction: direction,
          bgColor: bgColor,
          borderColor: borderColor,
          arrowH: _arrowH,
          arrowW: _arrowW,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppRadius.sm,
          ),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _BubblePainter — 三角箭头绘制
// ---------------------------------------------------------------------------

class _BubblePainter extends CustomPainter {
  const _BubblePainter({
    required this.direction,
    required this.bgColor,
    required this.borderColor,
    required this.arrowH,
    required this.arrowW,
  });

  final AppBubblePopupDirection direction;
  final Color bgColor;
  final Color borderColor;
  final double arrowH;
  final double arrowW;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = _buildArrowPath(size);
    canvas.drawPath(path, bgPaint);
    canvas.drawPath(path, borderPaint);
  }

  Path _buildArrowPath(Size size) {
    final path = Path();
    final halfW = arrowW / 2;

    switch (direction) {
      case AppBubblePopupDirection.bottom:
        // 箭头在顶部，朝上
        final tipX = size.width / 2;
        path.moveTo(tipX - halfW, arrowH);
        path.lineTo(tipX, 0);
        path.lineTo(tipX + halfW, arrowH);
        path.close();
      case AppBubblePopupDirection.top:
        // 箭头在底部，朝下
        final tipX = size.width / 2;
        path.moveTo(tipX - halfW, size.height - arrowH);
        path.lineTo(tipX, size.height);
        path.lineTo(tipX + halfW, size.height - arrowH);
        path.close();
      case AppBubblePopupDirection.right:
        // 箭头在左侧，朝左
        final tipY = size.height / 2;
        path.moveTo(arrowH, tipY - halfW);
        path.lineTo(0, tipY);
        path.lineTo(arrowH, tipY + halfW);
        path.close();
      case AppBubblePopupDirection.left:
        // 箭头在右侧，朝右
        final tipY = size.height / 2;
        path.moveTo(size.width - arrowH, tipY - halfW);
        path.lineTo(size.width, tipY);
        path.lineTo(size.width - arrowH, tipY + halfW);
        path.close();
    }

    return path;
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) =>
      direction != oldDelegate.direction ||
      bgColor != oldDelegate.bgColor ||
      borderColor != oldDelegate.borderColor;
}
