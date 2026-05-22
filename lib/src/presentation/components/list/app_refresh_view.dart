import 'package:flutter/material.dart';
import '../feedback/app_loading_indicator.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

// ---------------------------------------------------------------------------
// LoadMoreStatus
// ---------------------------------------------------------------------------

/// 上拉加载更多的状态枚举。
enum LoadMoreStatus {
  /// 空闲，未触发加载
  idle,

  /// 加载中
  loading,

  /// 无更多数据
  noMore,

  /// 加载失败
  failed,
}

// ---------------------------------------------------------------------------
// AppRefreshController
// ---------------------------------------------------------------------------

/// `AppRefreshView` 的命令式控制器。
///
/// 业务方持有此实例，在数据加载完成后调用对应方法更新底部状态。
///
/// 示例：
/// ```dart
/// final _controller = AppRefreshController();
///
/// Future<void> _onLoadMore() async {
///   final items = await repo.fetchNextPage();
///   if (items.isEmpty) {
///     _controller.setNoMore();
///   } else {
///     setState(() => _list.addAll(items));
///     _controller.finishLoadMore();
///   }
/// }
/// ```
class AppRefreshController extends ChangeNotifier {
  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.idle;

  /// 当前加载更多状态
  LoadMoreStatus get loadMoreStatus => _loadMoreStatus;

  /// 通知加载更多已完成，状态回到 [LoadMoreStatus.idle]
  void finishLoadMore() => _updateStatus(LoadMoreStatus.idle);

  /// 标记已无更多数据，底部显示"没有更多了"
  void setNoMore() => _updateStatus(LoadMoreStatus.noMore);

  /// 标记加载失败，底部显示重试按钮
  void setLoadFailed() => _updateStatus(LoadMoreStatus.failed);

  /// 重置到 [LoadMoreStatus.idle]，在新一轮下拉刷新前调用
  void reset() => _updateStatus(LoadMoreStatus.idle);

  void _updateStatus(LoadMoreStatus status) {
    if (_loadMoreStatus == status) return;
    _loadMoreStatus = status;
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// AppRefreshView
// ---------------------------------------------------------------------------

/// 统一封装下拉刷新 + 上拉加载更多的列表 Widget。
///
/// - **下拉刷新**：基于 [RefreshIndicator]，[onRefresh] 为 null 时禁用
/// - **上拉加载**：监听 [ScrollController]，距底部 ≤200px 触发 [onLoadMore]
/// - **底部状态**：由 [AppRefreshController] 驱动，自动渲染 loading/noMore/failed UI
///
/// 接入示例：
/// ```dart
/// final _controller = AppRefreshController();
/// final _items = <String>[];
///
/// AppRefreshView(
///   controller: _controller,
///   itemCount: _items.length,
///   itemBuilder: (context, index) => ListTile(title: Text(_items[index])),
///   onRefresh: () async {
///     final fresh = await repo.fetchPage(1);
///     setState(() { _items
///       ..clear()
///       ..addAll(fresh); });
///     _controller.reset();
///   },
///   onLoadMore: () async {
///     final next = await repo.fetchNextPage();
///     if (next.isEmpty) {
///       _controller.setNoMore();
///     } else {
///       setState(() => _items.addAll(next));
///       _controller.finishLoadMore();
///     }
///   },
/// )
/// ```
class AppRefreshView extends StatefulWidget {
  const AppRefreshView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.controller,
    this.onRefresh,
    this.onLoadMore,
    this.padding,
    this.noMoreText = '没有更多了',
    this.failedText = '加载失败，请重试',
    this.retryText = '重试',
  });

  /// 列表数据项数量
  final int itemCount;

  /// 列表项构建器，签名与 [ListView.builder.itemBuilder] 一致
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// 控制器，用于通知加载完成/无更多/失败
  final AppRefreshController controller;

  /// 下拉刷新回调；为 null 时禁用下拉刷新
  final Future<void> Function()? onRefresh;

  /// 上拉加载更多回调；为 null 时不显示底部加载区块
  final Future<void> Function()? onLoadMore;

  /// 列表内边距
  final EdgeInsetsGeometry? padding;

  /// 无更多数据时的提示文字
  final String noMoreText;

  /// 加载失败时的提示文字
  final String failedText;

  /// 重试按钮文字
  final String retryText;

  @override
  State<AppRefreshView> createState() => _AppRefreshViewState();
}

class _AppRefreshViewState extends State<AppRefreshView> {
  late final ScrollController _scrollController;
  bool _loadingMore = false;

  static const double _loadMoreThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (widget.onLoadMore != null) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final nearBottom = pos.pixels >= pos.maxScrollExtent - _loadMoreThreshold;
    if (nearBottom &&
        !_loadingMore &&
        widget.controller.loadMoreStatus == LoadMoreStatus.idle) {
      _triggerLoadMore();
    }
  }

  Future<void> _triggerLoadMore() async {
    if (widget.onLoadMore == null) return;
    _loadingMore = true;
    widget.controller._updateStatus(LoadMoreStatus.loading);
    try {
      await widget.onLoadMore!();
    } catch (_) {
      widget.controller.setLoadFailed();
    } finally {
      _loadingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget list = CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              widget.itemBuilder,
              childCount: widget.itemCount,
            ),
          ),
        ),
        if (widget.onLoadMore != null)
          SliverToBoxAdapter(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) =>
                  _Footer(
                    status: widget.controller.loadMoreStatus,
                    noMoreText: widget.noMoreText,
                    failedText: widget.failedText,
                    retryText: widget.retryText,
                    onRetry: _triggerLoadMore,
                  ),
            ),
          ),
      ],
    );

    if (widget.onRefresh != null) {
      list = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: list,
      );
    }

    return list;
  }
}

// ---------------------------------------------------------------------------
// SliverAppRefreshView
// ---------------------------------------------------------------------------

/// Sliver 版下拉刷新 + 上拉加载更多，供放入 [CustomScrollView.slivers]。
///
/// 与 [AppRefreshView] 的区别：
/// - 不内置 [CustomScrollView]，由业务方自行组合
/// - 下拉刷新通过 [RefreshIndicator] 包裹外层 [CustomScrollView] 实现
/// - 上拉加载触发需要业务方传入 [scrollController] 并挂到 [CustomScrollView]
///
/// **典型用法：**
/// ```dart
/// final _ctrl = AppRefreshController();
/// final _scrollCtrl = ScrollController();
///
/// RefreshIndicator(
///   onRefresh: _onRefresh,
///   child: CustomScrollView(
///     controller: _scrollCtrl,
///     slivers: [
///       SliverAppBar(title: Text('标题'), pinned: true),
///       SliverAppRefreshView(
///         controller: _ctrl,
///         scrollController: _scrollCtrl,
///         itemCount: _items.length,
///         itemBuilder: (ctx, i) => ListTile(title: Text(_items[i])),
///         onLoadMore: _onLoadMore,
///       ),
///     ],
///   ),
/// )
/// ```
class SliverAppRefreshView extends StatefulWidget {
  const SliverAppRefreshView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.controller,
    required this.scrollController,
    this.onLoadMore,
    this.noMoreText = '没有更多了',
    this.failedText = '加载失败，请重试',
    this.retryText = '重试',
  });

  /// 列表数据项数量
  final int itemCount;

  /// 列表项构建器，签名与 [ListView.builder.itemBuilder] 一致
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// 加载更多状态控制器
  final AppRefreshController controller;

  /// 外部 [CustomScrollView] 所使用的 [ScrollController]，
  /// 用于监听滚动位置触发上拉加载
  final ScrollController scrollController;

  /// 上拉加载更多回调；为 null 时不显示底部加载区块
  final Future<void> Function()? onLoadMore;

  /// 无更多数据时的提示文字
  final String noMoreText;

  /// 加载失败时的提示文字
  final String failedText;

  /// 重试按钮文字
  final String retryText;

  @override
  State<SliverAppRefreshView> createState() => _SliverAppRefreshViewState();
}

class _SliverAppRefreshViewState extends State<SliverAppRefreshView> {
  bool _loadingMore = false;
  static const double _loadMoreThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    if (widget.onLoadMore != null) {
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void didUpdateWidget(SliverAppRefreshView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      if (widget.onLoadMore != null) {
        widget.scrollController.addListener(_onScroll);
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.scrollController.hasClients) return;
    final pos = widget.scrollController.position;
    final nearBottom = pos.pixels >= pos.maxScrollExtent - _loadMoreThreshold;
    if (nearBottom &&
        !_loadingMore &&
        widget.controller.loadMoreStatus == LoadMoreStatus.idle) {
      _triggerLoadMore();
    }
  }

  Future<void> _triggerLoadMore() async {
    if (widget.onLoadMore == null) return;
    _loadingMore = true;
    widget.controller._updateStatus(LoadMoreStatus.loading);
    try {
      await widget.onLoadMore!();
    } catch (_) {
      widget.controller.setLoadFailed();
    } finally {
      _loadingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            widget.itemBuilder,
            childCount: widget.itemCount,
          ),
        ),
        if (widget.onLoadMore != null)
          SliverToBoxAdapter(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) => _Footer(
                status: widget.controller.loadMoreStatus,
                noMoreText: widget.noMoreText,
                failedText: widget.failedText,
                retryText: widget.retryText,
                onRetry: _triggerLoadMore,
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _Footer — 底部加载状态区块
// ---------------------------------------------------------------------------

class _Footer extends StatelessWidget {
  const _Footer({
    required this.status,
    required this.noMoreText,
    required this.failedText,
    required this.retryText,
    required this.onRetry,
  });

  final LoadMoreStatus status;
  final String noMoreText;
  final String failedText;
  final String retryText;
  final VoidCallback onRetry;

  static const double _height = 56.0;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppColorTokens>();
    final secondaryColor = tokens?.text.secondary ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);

    return switch (status) {
      LoadMoreStatus.loading => SizedBox(
          height: _height,
          child: const Center(
            child: AppLoadingIndicator(size: AppLoadingSize.small),
          ),
        ),
      LoadMoreStatus.noMore => SizedBox(
          height: _height,
          child: Center(
            child: Text(
              noMoreText,
              style: AppTextStyles.body.copyWith(color: secondaryColor),
            ),
          ),
        ),
      LoadMoreStatus.failed => SizedBox(
          height: _height,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  failedText,
                  style: AppTextStyles.body.copyWith(color: secondaryColor),
                ),
                const SizedBox(width: AppSpacing.space3),
                TextButton(
                  onPressed: onRetry,
                  child: Text(retryText),
                ),
              ],
            ),
          ),
        ),
      LoadMoreStatus.idle => const SizedBox.shrink(),
    };
  }
}
