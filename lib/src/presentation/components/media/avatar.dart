import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.url,
    this.width = 50,
    this.radius = 4,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.placeholder,
  });

  final String? url;
  final double width;
  final double radius;
  final double borderWidth;
  final Color borderColor;

  /// 首字母或短文字，用于 url 为空时显示占位文字。
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasUrl = url != null && url!.isNotEmpty;
    final isNetwork = hasUrl && _isNetworkImage(url);

    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
        border: borderWidth == 0
            ? null
            : Border.all(width: borderWidth, color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        color: theme.colorScheme.surfaceContainerHighest,
        image: (!hasUrl || !isNetwork)
            ? (hasUrl ? _localDecoration() : null)
            : null,
      ),
      child: isNetwork
          ? ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              child: CachedNetworkImage(
                imageUrl: url!,
                width: width,
                height: width,
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholderWidget(theme),
                errorWidget: (_, __, ___) => _placeholderWidget(theme),
              ),
            )
          : (!hasUrl ? _placeholderWidget(theme) : null),
    );
  }

  DecorationImage? _localDecoration() {
    final src = url!;
    final ImageProvider? provider = _isLocalImage(src)
        ? FileImage(File(src))
        : AssetImage(src);
    if (provider == null) return null;
    return DecorationImage(fit: BoxFit.cover, image: provider);
  }

  Widget _placeholderWidget(ThemeData theme) {
    final text = placeholder;
    if (text != null && text.isNotEmpty) {
      return Center(
        child: Text(
          text.substring(0, text.length > 2 ? 2 : text.length).toUpperCase(),
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: width * 0.35,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return Icon(
      Icons.person_outline,
      size: width * 0.5,
      color: theme.colorScheme.onSurfaceVariant,
    );
  }

  static bool _isNetworkImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return false;
    final uri = Uri.tryParse(imageUrl);
    return uri?.scheme == 'http' || uri?.scheme == 'https';
  }

  static bool _isLocalImage(String filePath) {
    return File(filePath).existsSync();
  }
}
