import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';

/// 标准应用栏组件，实现 PreferredSizeWidget 以便在 Scaffold.appBar 中使用。
///
/// 颜色从 Theme.colorScheme 读取，支持自定义 leading、actions、背景色。
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 0,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBg = backgroundColor ?? theme.colorScheme.surface;

    return Semantics(
      header: true,
      child: AppBar(
        title: Text(
          title,
          style: AppTextStyles.headingSm.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        leading: leading,
        actions: actions,
        backgroundColor: effectiveBg,
        surfaceTintColor: Colors.transparent,
        centerTitle: centerTitle,
        elevation: elevation,
        scrolledUnderElevation: elevation,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
    );
  }
}
