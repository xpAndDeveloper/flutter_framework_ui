import 'package:flutter/material.dart';
import 'app_breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.desktop && desktop != null) return desktop!;
    if (width >= AppBreakpoints.mobile && tablet != null) return tablet!;
    return mobile;
  }
}

class ResponsiveValue<T> {
  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final T mobile;
  final T? tablet;
  final T? desktop;

  T resolve(BuildContext context) {
    if (AppBreakpoints.isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (AppBreakpoints.isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
}
