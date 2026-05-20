import 'package:flutter/material.dart';
import 'package:flutter_framework_base/flutter_framework_base.dart';
import '../../theme/app_color_tokens.dart';

class PasswordStrengthBar extends StatefulWidget {
  const PasswordStrengthBar({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onReset,
    this.labels = const _DefaultLabels(),
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  /// Call [onReset] to externally reset the bar to its initial state.
  final VoidCallback? onReset;

  final PasswordStrengthLabels labels;

  @override
  State<PasswordStrengthBar> createState() => _PasswordStrengthBarState();
}

class _PasswordStrengthBarState extends State<PasswordStrengthBar> {
  bool _isFirst = true;
  bool _hasFocus = true;
  PasswordStrength _strength = PasswordStrength.weak;
  bool _lengthOk = false;
  bool _hasUpper = false;
  bool _hasLower = false;
  bool _hasDigit = false;
  bool _startVerification = false;

  late VoidCallback _textListener;
  late VoidCallback _focusListener;

  @override
  void initState() {
    super.initState();
    _textListener = _onTextChanged;
    _focusListener = _onFocusChanged;
    widget.controller.addListener(_textListener);
    widget.focusNode.addListener(_focusListener);
  }

  void _onTextChanged() {
    final pw = widget.controller.text;
    setState(() {
      _isFirst = false;
      _startVerification = true;
      _strength = PasswordStrengthChecker.getStrength(pw);
      _lengthOk = PasswordStrengthChecker.lengthCompliance(pw);
      _hasUpper = PasswordStrengthChecker.azUpperCompliance(pw);
      _hasLower = PasswordStrengthChecker.azCompliance(pw);
      _hasDigit = PasswordStrengthChecker.numCompliance(pw);
    });
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = widget.focusNode.hasFocus;
      if (_hasFocus) _isFirst = false;
    });
  }

  void reset() {
    setState(() {
      _isFirst = true;
      _startVerification = false;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textListener);
    widget.focusNode.removeListener(_focusListener);
    super.dispose();
  }

  Color _barColor(BuildContext context, int level) {
    final text = widget.controller.text;
    if (text.isEmpty) return Theme.of(context).colorScheme.outlineVariant;
    return switch (_strength) {
      PasswordStrength.strong when level <= 3 =>
        Theme.of(context).colorScheme.primary,
      PasswordStrength.medium when level <= 2 =>
        Theme.of(context).extension<AppColorTokens>()?.status.warning
            ?? const Color(0xFFFFC563),
      PasswordStrength.weak when level <= 1 =>
        Theme.of(context).colorScheme.error,
      _ => Theme.of(context).colorScheme.outlineVariant,
    };
  }

  String _strengthLabel(BuildContext context) {
    if (widget.controller.text.isEmpty) return '';
    return switch (_strength) {
      PasswordStrength.strong => widget.labels.strong,
      PasswordStrength.medium => widget.labels.medium,
      PasswordStrength.weak => widget.labels.weak,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isValid = PasswordStrengthChecker.isValidPassword(widget.controller.text);
    if ((isValid && !_hasFocus) || _isFirst) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _bar(context, 1),
            const SizedBox(width: 4),
            _bar(context, 2),
            const SizedBox(width: 4),
            _bar(context, 3),
            const SizedBox(width: 4),
            Text(
              _strengthLabel(context),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _barColor(context, 1),
                  ),
            ),
          ],
        ),
        _rule(_lengthOk, widget.labels.lengthRule),
        _rule(_hasUpper, widget.labels.upperRule),
        _rule(_hasLower, widget.labels.lowerRule),
        _rule(_hasDigit, widget.labels.digitRule),
      ],
    );
  }

  Widget _bar(BuildContext context, int level) {
    return Container(
      width: 54,
      height: 4,
      decoration: BoxDecoration(
        color: _barColor(context, level),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _rule(bool compliant, String label) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final textColor = compliant
        ? theme.colorScheme.primary
        : (_startVerification ? errorColor : theme.colorScheme.onSurface);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            compliant ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            size: 12,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

abstract class PasswordStrengthLabels {
  const PasswordStrengthLabels();
  String get strong;
  String get medium;
  String get weak;
  String get lengthRule;
  String get upperRule;
  String get lowerRule;
  String get digitRule;
}

class _DefaultLabels extends PasswordStrengthLabels {
  const _DefaultLabels();

  @override String get strong => '强';
  @override String get medium => '中';
  @override String get weak => '弱';
  @override String get lengthRule => '8-16字符';
  @override String get upperRule => '至少一个大写字母(A-Z)';
  @override String get lowerRule => '至少一个小写字母(a-z)';
  @override String get digitRule => '至少一个数字';
}
