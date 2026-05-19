import 'package:flutter/material.dart';

/// Interface for items displayed in [AppBottomSheetPicker].
abstract class PickerItem {
  String get displayLabel;
  String? get itemId => null;
}

typedef PickerItemBuilder<T> = Widget Function(BuildContext context, T value);

/// Shows a modal bottom sheet with a scrollable list of [items].
/// Returns the selected item or null if dismissed.
Future<T?> showAppBottomSheetPicker<T extends PickerItem>(
  BuildContext context, {
  required List<T> items,
  T? selectedItem,
  PickerItemBuilder<T>? itemBuilder,
  bool canSearch = false,
  String? searchHint,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: canSearch,
    builder: (ctx) {
      if (canSearch) {
        return _SearchablePicker<T>(
          items: items,
          selectedItem: selectedItem,
          itemBuilder: itemBuilder,
          searchHint: searchHint,
        );
      }
      return _SimplePicker<T>(
        items: items,
        selectedItem: selectedItem,
        itemBuilder: itemBuilder,
      );
    },
  );
}

class _SimplePicker<T extends PickerItem> extends StatelessWidget {
  const _SimplePicker({
    required this.items,
    this.selectedItem,
    this.itemBuilder,
  });

  final List<T> items;
  final T? selectedItem;
  final PickerItemBuilder<T>? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 32, top: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      constraints: BoxConstraints(
        maxHeight: items.length > 6 ? 300 : items.length * 44.0 + 60,
        minHeight: 50,
      ),
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final item = items[i];
          final row = itemBuilder != null
              ? itemBuilder!(ctx, item)
              : Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Text(
                    item.displayLabel,
                    textAlign: TextAlign.center,
                    style: item.itemId == selectedItem?.itemId
                        ? TextStyle(
                            color: Theme.of(ctx).colorScheme.primary,
                            fontSize: 16,
                          )
                        : Theme.of(ctx).textTheme.titleMedium,
                  ),
                );
          return GestureDetector(
            onTap: () => Navigator.of(ctx).pop(item),
            child: row,
          );
        },
      ),
    );
  }
}

class _SearchablePicker<T extends PickerItem> extends StatefulWidget {
  const _SearchablePicker({
    required this.items,
    this.selectedItem,
    this.itemBuilder,
    this.searchHint,
  });

  final List<T> items;
  final T? selectedItem;
  final PickerItemBuilder<T>? itemBuilder;
  final String? searchHint;

  @override
  State<_SearchablePicker<T>> createState() => _SearchablePickerState<T>();
}

class _SearchablePickerState<T extends PickerItem>
    extends State<_SearchablePicker<T>> {
  final TextEditingController _searchController = TextEditingController();
  late List<T> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.items
          : widget.items
              .where((e) => e.displayLabel.toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 500,
      padding: const EdgeInsets.only(bottom: 32, top: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.searchHint ?? '搜索...',
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none),
                  hintStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final item = _filtered[i];
                final row = widget.itemBuilder != null
                    ? widget.itemBuilder!(ctx, item)
                    : Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: Text(
                          item.displayLabel,
                          textAlign: TextAlign.center,
                          style: item.itemId == widget.selectedItem?.itemId
                              ? TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 16,
                                )
                              : theme.textTheme.titleMedium,
                        ),
                      );
                return GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(item),
                  child: row,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
