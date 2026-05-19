import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    this.url,
    this.width = 100,
    this.height = 100,
    this.radius = 4,
    this.fit = BoxFit.contain,
    this.color,
    this.errorWidget,
    this.loadingWidget,
    this.onTap,
  });

  final String? url;
  final double width;
  final double height;
  final double radius;
  final BoxFit? fit;
  final Color? color;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: _buildImage(context),
      ),
    );

    if (onTap != null) {
      child = GestureDetector(onTap: onTap, child: child);
    }

    return child;
  }

  Widget _buildImage(BuildContext context) {
    final src = url ?? '';

    if (_isNetworkImage(url)) {
      return CachedNetworkImage(
        imageUrl: src,
        width: width,
        height: height,
        fit: fit,
        color: color,
        fadeInDuration: const Duration(milliseconds: 200),
        placeholder: (context, url) =>
            loadingWidget ?? _defaultLoading(context),
        errorWidget: (context, url, error) =>
            errorWidget ?? _defaultError(context),
      );
    }

    if (_isLocalImage(src)) {
      return Image.file(
        File(src),
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _defaultError(context),
      );
    }

    return Image.asset(
      src,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? _defaultError(context),
    );
  }

  Widget _defaultLoading(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: SizedBox(
          width: (width * 0.3).clamp(16.0, 32.0),
          height: (width * 0.3).clamp(16.0, 32.0),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _defaultError(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: width * 0.4,
      ),
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

  static ImageProvider imageProviderFrom(String src) {
    if (_isNetworkImage(src)) {
      return CachedNetworkImageProvider(src, cacheKey: src);
    }
    if (_isLocalImage(src)) {
      return FileImage(File(src));
    }
    return AssetImage(src);
  }
}
