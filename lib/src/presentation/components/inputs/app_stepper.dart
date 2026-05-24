import 'package:flutter/material.dart';

/// 行内步进器组件。
///
/// `[−] [value] [+]` 三段式布局，支持 min/max/step 约束。
///
/// ```dart
/// AppStepper(
///   value: _quantity,
///   min: 1,
///   max: 100,
///   step: 1,
///   onChanged: (v) => setState(() => _quantity = v),
/// )
/// ```
class AppStepper extends StatelessWidget {
  const AppStepper({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = double.infinity,
    this.step = 1,
    this.decimalPlaces,
    this.enabled = true,
  });

  /// 当前值（受控）。
  final double value;

  /// 值变化回调，传入新值。
  final ValueChanged<double>? onChanged;

  /// 最小值，默认 `0`。
  final double min;

  /// 最大值，默认 `double.infinity`。
  final double max;

  /// 每次步进的增量，默认 `1`。
  final double step;

  /// 显示的小数位数；`null` 时根据 [step] 自动推断：
  /// step 为整数则 `0`，否则 `2`。
  final int? decimalPlaces;

  /// 是否可交互，默认 `true`。
  final bool enabled;

  int get _displayDecimalPlaces {
    if (decimalPlaces != null) return decimalPlaces!;
    return step % 1 == 0 ? 0 : 2;
  }

  String get _displayValue => value.toStringAsFixed(_displayDecimalPlaces);

  double _round(double v) {
    final places = _displayDecimalPlaces;
    if (places == 0) return v.roundToDouble();
    final factor = _pow10(places);
    return (v * factor).round() / factor;
  }

  static double _pow10(int n) {
    double result = 1;
    for (int i = 0; i < n; i++) {
      result *= 10;
    }
    return result;
  }

  void _increment() {
    if (onChanged == null) return;
    final next = _round(value + step);
    onChanged!(next > max ? max : next);
  }

  void _decrement() {
    if (onChanged == null) return;
    final next = _round(value - step);
    onChanged!(next < min ? min : next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canDecrement = enabled && value > min;
    final canIncrement = enabled && value < max;

    final borderColor = enabled
        ? theme.colorScheme.outline
        : theme.colorScheme.outline.withValues(alpha: 0.38);
    final textColor = enabled
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);
    final iconColor = (bool active) => active
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // − 按钮
            _StepButton(
              icon: Icons.remove,
              onTap: canDecrement ? _decrement : null,
              iconColor: iconColor(canDecrement),
            ),
            // 分隔线
            VerticalDivider(width: 1, thickness: 1, color: borderColor),
            // 值显示
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _displayValue,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ),
            // 分隔线
            VerticalDivider(width: 1, thickness: 1, color: borderColor),
            // + 按钮
            _StepButton(
              icon: Icons.add,
              onTap: canIncrement ? _increment : null,
              iconColor: iconColor(canIncrement),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onTap,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}
