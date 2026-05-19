import 'dart:async';

import 'package:flutter/material.dart';

class NumKeyboard extends StatefulWidget {
  const NumKeyboard({
    super.key,
    this.decimal = true,
    this.max,
    this.scale = 2,
    required this.controller,
    required this.onTextChanged,
    this.doneLabel,
    this.doneDisabled = false,
    this.onDone,
    this.buttonHeight = 48.0,
  });

  final bool decimal;
  final String? max;
  final int scale;
  final TextEditingController controller;
  final void Function(String) onTextChanged;
  final String? doneLabel;
  final bool doneDisabled;
  final VoidCallback? onDone;

  /// Height of each keyboard row.
  final double buttonHeight;

  @override
  State<NumKeyboard> createState() => _NumKeyboardState();
}

class _NumKeyboardState extends State<NumKeyboard> {
  Timer? _longPressTimer;

  void _handleType(String text) {
    if (widget.max != null) {
      final current = double.tryParse(widget.controller.text + text) ?? 0;
      final max = double.tryParse(widget.max!) ?? double.infinity;
      if (current >= max) {
        widget.controller.text = widget.max!;
        widget.controller.selection =
            TextSelection.collapsed(offset: widget.controller.text.length);
        widget.onTextChanged(widget.controller.text);
        return;
      }
    }

    if (text == '.' && widget.controller.text.contains('.')) return;
    if (text == '.' && widget.controller.text.isEmpty) text = '0.';
    if (widget.controller.text == '0' && text != '.') {
      widget.controller.text = '';
    }

    final combined = widget.controller.text + text;
    if (combined.contains('.') &&
        combined.split('.').last.length > widget.scale) {
      return;
    }

    widget.controller.text = widget.controller.text.isEmpty
        ? text
        : widget.controller.text + text;
    widget.controller.selection =
        TextSelection.collapsed(offset: widget.controller.text.length);
    widget.onTextChanged(widget.controller.text);
  }

  void _handleBackspace() {
    final value = widget.controller.text;
    if (value.isEmpty) return;
    widget.controller.text = value.length == 1 ? '' : value.substring(0, value.length - 1);
    widget.controller.selection =
        TextSelection.collapsed(offset: widget.controller.text.length);
    widget.onTextChanged(widget.controller.text);
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.buttonHeight * 4,
      child: Column(
        children: [
          _row(['1', '2', '3']),
          _row(['4', '5', '6']),
          _row(['7', '8', '9']),
          Row(
            children: [
              widget.decimal
                  ? _key('.')
                  : Expanded(child: SizedBox(height: widget.buttonHeight)),
              _key('0'),
              _backspaceKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(List<String> keys) => Row(
        children: keys.map(_key).toList(),
      );

  Widget _key(String label) {
    final theme = Theme.of(context);
    return Expanded(
      child: SizedBox(
        height: widget.buttonHeight,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.onSurface,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            padding: EdgeInsets.zero,
          ),
          onPressed: () => _handleType(label),
          child: Text(
            label,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _backspaceKey() {
    final theme = Theme.of(context);
    return Expanded(
      child: SizedBox(
        height: widget.buttonHeight,
        child: GestureDetector(
          onLongPressStart: (_) {
            _longPressTimer =
                Timer.periodic(const Duration(milliseconds: 50), (_) {
              _handleBackspace();
            });
          },
          onLongPressEnd: (_) => _longPressTimer?.cancel(),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              foregroundColor: theme.colorScheme.onSurface,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              padding: EdgeInsets.zero,
            ),
            onPressed: _handleBackspace,
            child: Icon(
              Icons.backspace_outlined,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
