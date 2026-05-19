import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer loading placeholder that wraps any widget.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: baseColor ?? scheme.surfaceContainerHighest,
      highlightColor: highlightColor ?? scheme.surface,
      child: child,
    );
  }
}

/// A simple rectangular shimmer placeholder block.
class ShimmerRect extends StatelessWidget {
  const ShimmerRect({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4.0,
    this.baseColor,
    this.highlightColor,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: baseColor ?? scheme.surfaceContainerHighest,
      highlightColor: highlightColor ?? scheme.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
