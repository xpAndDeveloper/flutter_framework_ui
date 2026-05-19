import 'package:flutter/material.dart';

enum EmptyViewState { loading, empty, hasContent }

class EmptyView extends StatefulWidget {
  const EmptyView({
    super.key,
    required this.child,
    required this.onLoad,
    this.emptyMessage,
    this.emptyIcon,
    this.loadingWidget,
  });

  /// The content to show when data is present.
  final Widget child;

  /// Called once on init; when Future resolves the loading state ends.
  /// If the result is falsy or null, empty state is shown; otherwise content.
  final Future<bool> Function() onLoad;

  final String? emptyMessage;
  final Widget? emptyIcon;
  final Widget? loadingWidget;

  @override
  State<EmptyView> createState() => _EmptyViewState();
}

class _EmptyViewState extends State<EmptyView> {
  EmptyViewState _state = EmptyViewState.loading;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final hasData = await widget.onLoad();
      if (mounted) {
        setState(() {
          _state = hasData ? EmptyViewState.hasContent : EmptyViewState.empty;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _state = EmptyViewState.empty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_state) {
      EmptyViewState.loading => widget.loadingWidget ??
          Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
      EmptyViewState.empty => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.emptyIcon ??
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              const SizedBox(height: 12),
              Text(
                widget.emptyMessage ?? 'No data',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      EmptyViewState.hasContent => widget.child,
    };
  }
}

/// A simpler, purely declarative empty placeholder — no loading state.
class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({
    super.key,
    this.message,
    this.icon,
  });

  final String? message;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ??
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          const SizedBox(height: 12),
          Text(
            message ?? 'No data',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
