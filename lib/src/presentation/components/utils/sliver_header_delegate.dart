import 'package:flutter/material.dart';

typedef SliverHeaderBuilder = Widget Function(BuildContext context, double shrinkOffset, bool overlapsContent);

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverHeaderDelegate({
    required this.maxHeight,
    this.minHeight = 0,
    required Widget child,
  })  : builder = ((_, __, ___) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  SliverHeaderDelegate.fixedHeight({required double height, required Widget child})
      : builder = ((_, __, ___) => child),
        maxHeight = height,
        minHeight = height;

  SliverHeaderDelegate.builder({required this.maxHeight, this.minHeight = 0, required this.builder});

  final double maxHeight;
  final double minHeight;
  final SliverHeaderBuilder builder;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: builder(context, shrinkOffset, overlapsContent));
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverHeaderDelegate old) =>
      old.maxExtent != maxExtent || old.minExtent != minExtent;
}
