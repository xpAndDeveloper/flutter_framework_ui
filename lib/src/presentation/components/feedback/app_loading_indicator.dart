import 'package:flutter/material.dart';

enum AppLoadingSize { small, medium, large }

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = AppLoadingSize.medium,
    this.color,
  });

  final AppLoadingSize size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dimension = switch (size) {
      AppLoadingSize.small => 16.0,
      AppLoadingSize.medium => 24.0,
      AppLoadingSize.large => 40.0,
    };
    return SizedBox(
      width: dimension,
      height: dimension,
      child: CircularProgressIndicator(
        strokeWidth: size == AppLoadingSize.small ? 2 : 3,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
