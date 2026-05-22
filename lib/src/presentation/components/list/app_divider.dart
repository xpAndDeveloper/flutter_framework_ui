import 'package:flutter/material.dart';
import '../../theme/app_color_tokens.dart';

/// 标准分割线组件。
///
/// 颜色从 AppColorTokens.border.divider 读取，不硬编码。
class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.indent, this.endIndent});

  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppColorTokens>();
    final dividerColor = tokens?.border.divider ?? Theme.of(context).dividerColor;

    return Divider(
      color: dividerColor,
      height: 1,
      thickness: 1,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
