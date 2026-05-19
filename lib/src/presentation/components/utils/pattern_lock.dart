import 'package:flutter/material.dart';

class PatternLock extends StatefulWidget {
  const PatternLock({
    super.key,
    this.dimension = 3,
    this.relativePadding = 0.7,
    this.selectedColor,
    this.notSelectedColor,
    this.pointRadius = 10,
    this.pointStrokeWidth = 2,
    this.showInput = true,
    this.showPath = true,
    this.selectThreshold = 25,
    this.fillPoints = false,
    required this.onInputComplete,
    required this.onInputStart,
  });

  /// Number of points horizontally and vertically.
  final int dimension;

  /// Padding of the points area relative to the distance between points.
  final double relativePadding;

  /// Color of selected points. Falls back to [ThemeData.colorScheme.primary] when null.
  final Color? selectedColor;

  /// 未选中点的颜色。null 时跟随主题 colorScheme.outline。
  final Color? notSelectedColor;
  final double pointRadius;
  final double pointStrokeWidth;

  /// Whether to display the user's drawn path.
  final bool showInput;

  /// Whether to draw lines connecting selected points.
  final bool showPath;

  /// Distance threshold to trigger a point selection.
  final int selectThreshold;
  final bool fillPoints;

  final void Function(List<int>) onInputComplete;
  final VoidCallback onInputStart;

  @override
  State<PatternLock> createState() => _PatternLockState();
}

class _PatternLockState extends State<PatternLock> {
  List<int> _used = [];
  Offset? _currentPoint;

  @override
  Widget build(BuildContext context) {
    final selectedColor =
        widget.selectedColor ?? Theme.of(context).colorScheme.primary;
    final notSelectedColor =
        widget.notSelectedColor ?? Theme.of(context).colorScheme.outline;

    return GestureDetector(
      onPanEnd: (_) {
        if (_used.isNotEmpty) widget.onInputComplete(_used);
        setState(() {
          _used = [];
          _currentPoint = null;
        });
      },
      onPanUpdate: (details) {
        if (_used.isEmpty) widget.onInputStart();
        final box = context.findRenderObject() as RenderBox;
        final local = box.globalToLocal(details.globalPosition);

        setState(() {
          _currentPoint = local;
          for (int i = 0; i < widget.dimension * widget.dimension; i++) {
            final dist = (_circlePosition(i, box.size) - local).distance;
            if (!_used.contains(i) && dist < widget.selectThreshold) {
              _used.add(i);
            }
          }
        });
      },
      child: CustomPaint(
        painter: _LockPainter(
          dimension: widget.dimension,
          used: _used,
          currentPoint: _currentPoint,
          relativePadding: widget.relativePadding,
          selectedColor: selectedColor,
          notSelectedColor: notSelectedColor,
          pointRadius: widget.pointRadius,
          pointStrokeWidth: widget.pointStrokeWidth,
          showInput: widget.showInput,
          showPath: widget.showPath,
          fillPoints: widget.fillPoints,
        ),
        size: Size.infinite,
      ),
    );
  }

  Offset _circlePosition(int n, Size size) =>
      _calcCirclePosition(n, size, widget.dimension, widget.relativePadding);
}

@immutable
class _LockPainter extends CustomPainter {
  _LockPainter({
    required this.dimension,
    required this.used,
    this.currentPoint,
    required this.relativePadding,
    required this.selectedColor,
    required this.notSelectedColor,
    required this.pointRadius,
    required this.pointStrokeWidth,
    required this.showInput,
    required this.showPath,
    required bool fillPoints,
  }) : _paint = Paint()
          ..color = notSelectedColor
          ..style = fillPoints ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = 1;

  final int dimension;
  final List<int> used;
  final Offset? currentPoint;
  final double relativePadding;
  final double pointRadius;
  final double pointStrokeWidth;
  final bool showInput;
  final bool showPath;
  final Color selectedColor;
  final Color notSelectedColor;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    Offset pos(int n) => _calcCirclePosition(n, size, dimension, relativePadding);

    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        final idx = i * dimension + j;
        final selected = showInput && used.contains(idx);

        _paint
          ..style = PaintingStyle.stroke
          ..color = selected ? selectedColor : notSelectedColor
          ..strokeWidth = 1;
        canvas.drawCircle(pos(idx), pointRadius, _paint);

        if (selected) {
          _paint
            ..style = PaintingStyle.fill
            ..color = selectedColor;
          canvas.drawCircle(pos(idx), pointRadius / 3, _paint);
        }
      }
    }

    if (showInput && showPath) {
      _paint
        ..strokeWidth = pointStrokeWidth
        ..color = selectedColor;
      for (int i = 0; i < used.length - 1; i++) {
        canvas.drawLine(pos(used[i]), pos(used[i + 1]), _paint);
      }
      if (used.isNotEmpty && currentPoint != null) {
        canvas.drawLine(pos(used.last), currentPoint!, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Offset _calcCirclePosition(
    int n, Size size, int dimension, double relativePadding) {
  final o = size.width > size.height
      ? Offset((size.width - size.height) / 2, 0)
      : Offset(0, (size.height - size.width) / 2);
  return o +
      Offset(
        size.shortestSide /
            (dimension - 1 + relativePadding * 2) *
            (n % dimension + relativePadding),
        size.shortestSide /
            (dimension - 1 + relativePadding * 2) *
            (n ~/ dimension + relativePadding),
      );
}
