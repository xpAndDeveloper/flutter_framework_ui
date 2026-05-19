import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  const MarqueeText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 10000),
    this.enableScroll = true,
    this.forceScroll = false,
  });

  final String text;
  final TextStyle? style;
  final Duration duration;
  final bool enableScroll;
  final bool forceScroll;

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final ScrollController _scrollController = ScrollController();
  Size _viewSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween(begin: Offset.zero, end: const Offset(1, 0)).animate(_controller);
    _animation.addListener(_onAnimate);
  }

  void _onAnimate() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (!pos.hasContentDimensions) return;
    final fullLength = pos.maxScrollExtent + 2 * _viewSize.width;
    _scrollController.jumpTo(_animation.value.dx * fullLength - _viewSize.width);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = widget.style ?? DefaultTextStyle.of(context).style;
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewSize = Size(constraints.maxWidth, constraints.maxHeight);
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: effectiveStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: _viewSize.width);

        final shouldScroll = widget.enableScroll && (widget.forceScroll || painter.didExceedMaxLines);
        if (shouldScroll) {
          _controller.repeat();
        } else {
          _controller.stop();
        }

        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: _viewSize.width),
            child: Text(widget.text, style: effectiveStyle, maxLines: 1),
          ),
        );
      },
    );
  }
}
