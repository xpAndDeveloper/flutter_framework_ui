import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

abstract class AppDropdownItem {
  String get displayLabel;
  String get itemId;
}

class AppDropdown<T extends AppDropdownItem> extends StatefulWidget {
  const AppDropdown({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    this.title,
    this.hint,
    this.fontSize,
    this.mustMark = false,
    this.alignRight = false,
  });

  final List<T> items;
  final T? value;
  final ValueChanged<T> onChanged;
  final String? title;
  final String? hint;
  final double? fontSize;

  /// Show a red asterisk prefix before [title].
  final bool mustMark;

  /// Align selected value text to the right.
  final bool alignRight;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T extends AppDropdownItem>
    extends State<AppDropdown<T>> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fs = widget.fontSize ?? 14.0;

    return DropdownButton2<T>(
      isExpanded: true,
      underline: const SizedBox.shrink(),
      hint: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (widget.title != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.mustMark)
                  Text(
                    '*',
                    style: TextStyle(
                        fontSize: fs,
                        color: theme.colorScheme.error),
                  ),
                Expanded(
                  child: Text(
                    widget.title!,
                    style: TextStyle(
                      fontSize: fs,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          Container(
            alignment: widget.alignRight
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: EdgeInsets.only(
                left: widget.title != null ? 104.0 : 0.0),
            child: Text(
              widget.value?.displayLabel ?? (widget.hint ?? '请选择'),
              style: TextStyle(
                fontSize: fs,
                color: widget.value == null
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      items: widget.items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Container(
                color: item.itemId == widget.value?.itemId
                    ? theme.colorScheme.primaryContainer
                    : null,
                alignment: widget.alignRight
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  item.displayLabel,
                  style: TextStyle(
                    fontSize: fs,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) widget.onChanged(value);
      },
      onMenuStateChange: (open) => setState(() => _open = open),
      buttonStyleData: ButtonStyleData(
        height: 48,
        padding: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline,
              width: 1,
            ),
          ),
        ),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(
          _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 220,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(),
    );
  }
}
