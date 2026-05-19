import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.height = 1.0, this.color, this.indent = 0, this.endIndent = 0});

  final double height;
  final Color? color;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: height,
      color: color ?? Theme.of(context).dividerColor,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

class AppVerticalDivider extends StatelessWidget {
  const AppVerticalDivider({super.key, this.width = 1.0, this.color});

  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: width,
      thickness: width,
      color: color ?? Theme.of(context).dividerColor,
    );
  }
}

class AppSpaceDivider extends StatelessWidget {
  const AppSpaceDivider({super.key, this.height = 8.0, this.color});

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(height: height, color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest);
  }
}
