import 'package:flutter/material.dart';

/// Displays text or a masking string based on [isCipherText].
///
/// Pass a [ValueNotifier<bool>] to [cipherNotifier] for reactive toggling.
/// Pass a static [isCipherText] when no reactive toggle is needed.
class CipherText extends StatelessWidget {
  const CipherText({
    super.key,
    required this.text,
    this.style,
    this.mask = '****',
    this.isCipherText = false,
    this.cipherNotifier,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle? style;

  /// The replacement string shown when cipher mode is active.
  final String mask;

  /// Static cipher toggle. Ignored when [cipherNotifier] is provided.
  final bool isCipherText;

  /// Reactive cipher toggle. When non-null, this takes precedence over [isCipherText].
  final ValueNotifier<bool>? cipherNotifier;

  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    if (cipherNotifier != null) {
      return ValueListenableBuilder<bool>(
        valueListenable: cipherNotifier!,
        builder: (context, cipher, _) {
          return Text(
            cipher ? mask : text,
            style: style,
            textAlign: textAlign,
          );
        },
      );
    }

    return Text(
      isCipherText ? mask : text,
      style: style,
      textAlign: textAlign,
    );
  }
}
