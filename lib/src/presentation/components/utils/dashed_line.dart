import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    this.axis = Axis.horizontal,
    this.dashWidth = 10,
    this.dashHeight = 1,
    this.spacing = 1,
    this.count = 10,
    this.color = Colors.grey,
  });

  final Axis axis;
  final double dashWidth;
  final double dashHeight;
  final double spacing;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Flex(
          direction: axis,
          spacing: spacing,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (_) {
            return SizedBox(
              width: axis == Axis.horizontal ? dashWidth : dashHeight,
              height: axis == Axis.vertical ? dashWidth : dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}
