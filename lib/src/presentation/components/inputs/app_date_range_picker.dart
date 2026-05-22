import 'package:flutter/material.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_radius.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

// ---------------------------------------------------------------------------
// AppDateRange — 日期区间值对象
// ---------------------------------------------------------------------------

/// 不可变日期区间值对象。
///
/// [startDate] 与 [endDate] 均不含时间信息（time component 为 00:00:00），
/// 且 [endDate] >= [startDate]。
@immutable
class AppDateRange {
  const AppDateRange({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  bool operator ==(Object other) =>
      other is AppDateRange &&
      other.startDate == startDate &&
      other.endDate == endDate;

  @override
  int get hashCode => Object.hash(startDate, endDate);

  @override
  String toString() =>
      'AppDateRange(${_formatDate(startDate)} ~ ${_formatDate(endDate)})';
}

// ---------------------------------------------------------------------------
// AppDateRangePreset — 内置快捷预设枚举
// ---------------------------------------------------------------------------

/// 内置快捷日期预设。
///
/// 调用 [toDateRange] 获取对应 [AppDateRange]（以今天为基准计算）。
enum AppDateRangePreset {
  /// 今日（startDate = endDate = 今天）
  today,

  /// 本周一至今天
  thisWeek,

  /// 本月 1 日至今天
  thisMonth,

  /// 自由选择，不自动计算区间
  custom,
}

/// [AppDateRangePreset] 扩展：计算对应的 [AppDateRange]。
extension AppDateRangePresetX on AppDateRangePreset {
  /// 根据预设计算对应日期区间（以今天为基准）。
  ///
  /// [custom] 返回 null，由调用方自行处理。
  AppDateRange? toDateRange() {
    final today = _today();
    return switch (this) {
      AppDateRangePreset.today => AppDateRange(startDate: today, endDate: today),
      AppDateRangePreset.thisWeek => AppDateRange(
          startDate: today.subtract(Duration(days: today.weekday - 1)),
          endDate: today,
        ),
      AppDateRangePreset.thisMonth => AppDateRange(
          startDate: DateTime(today.year, today.month, 1),
          endDate: today,
        ),
      AppDateRangePreset.custom => null,
    };
  }

  /// 预设的显示标签（中文）
  String get label => switch (this) {
        AppDateRangePreset.today => '今日',
        AppDateRangePreset.thisWeek => '本周',
        AppDateRangePreset.thisMonth => '本月',
        AppDateRangePreset.custom => '自定义',
      };
}

// ---------------------------------------------------------------------------
// AppDateRangePresetOption — 外部注入自定义快捷项
// ---------------------------------------------------------------------------

/// 自定义快捷选项，用于通过 [showAppDateRangePicker] 的 `customPresets` 参数注入。
@immutable
class AppDateRangePresetOption {
  const AppDateRangePresetOption({
    required this.label,
    required this.range,
  });

  final String label;
  final AppDateRange range;
}

// ---------------------------------------------------------------------------
// showAppDateRangePicker — 顶层函数
// ---------------------------------------------------------------------------

/// 弹出日期范围选择器 Bottom Sheet。
///
/// 用户确认后调用 [onConfirm]，取消则不调用。
///
/// 示例：
/// ```dart
/// showAppDateRangePicker(
///   context: context,
///   onConfirm: (range) {
///     setState(() => _selectedRange = range);
///   },
/// );
/// ```
void showAppDateRangePicker({
  required BuildContext context,
  required void Function(AppDateRange) onConfirm,
  AppDateRange? initialRange,
  DateTime? firstDate,
  DateTime? lastDate,
  String title = '选择日期范围',
  List<AppDateRangePresetOption>? customPresets,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AppDateRangePickerSheet(
      onConfirm: onConfirm,
      initialRange: initialRange,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      title: title,
      customPresets: customPresets ?? const [],
    ),
  );
}

// ---------------------------------------------------------------------------
// _AppDateRangePickerSheet — Bottom Sheet 容器
// ---------------------------------------------------------------------------

class _AppDateRangePickerSheet extends StatefulWidget {
  const _AppDateRangePickerSheet({
    required this.onConfirm,
    required this.firstDate,
    required this.lastDate,
    required this.title,
    required this.customPresets,
    this.initialRange,
  });

  final void Function(AppDateRange) onConfirm;
  final AppDateRange? initialRange;
  final DateTime firstDate;
  final DateTime lastDate;
  final String title;
  final List<AppDateRangePresetOption> customPresets;

  @override
  State<_AppDateRangePickerSheet> createState() =>
      _AppDateRangePickerSheetState();
}

class _AppDateRangePickerSheetState extends State<_AppDateRangePickerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AppDateRange? _selectedRange;

  static const _builtinPresets = [
    AppDateRangePreset.today,
    AppDateRangePreset.thisWeek,
    AppDateRangePreset.thisMonth,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedRange = widget.initialRange;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _canConfirm => _selectedRange != null;

  void _confirm() {
    if (_selectedRange == null) return;
    Navigator.of(context).pop();
    widget.onConfirm(_selectedRange!);
  }

  void _cancel() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppColorTokens>();
    final bgColor = tokens?.bg.elevated ?? Theme.of(context).colorScheme.surface;
    final textPrimary = tokens?.text.primary ?? Theme.of(context).colorScheme.onSurface;
    final textSecondary = tokens?.text.secondary ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
    final brandPrimary = tokens?.brand.primary ?? Theme.of(context).colorScheme.primary;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.space5),
            ),
          ),
          child: Column(
            children: [
              // 拖拽把手
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.space3),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              // 标题
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.space5,
                  AppSpacing.space4,
                  AppSpacing.space5,
                  AppSpacing.space2,
                ),
                child: Text(
                  widget.title,
                  style: AppTextStyles.headline.copyWith(color: textPrimary),
                ),
              ),
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: brandPrimary,
                unselectedLabelColor: textSecondary,
                indicatorColor: brandPrimary,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: AppTextStyles.labelMd,
                unselectedLabelStyle: AppTextStyles.labelMd,
                tabs: const [
                  Tab(text: '快捷'),
                  Tab(text: '自定义'),
                ],
              ),
              // Tab 内容
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _PresetTab(
                      builtinPresets: _builtinPresets,
                      customPresets: widget.customPresets,
                      selectedRange: _selectedRange,
                      onSelected: (range) => setState(() => _selectedRange = range),
                      tokens: tokens,
                    ),
                    _CustomTab(
                      initialRange: _selectedRange,
                      firstDate: widget.firstDate,
                      lastDate: widget.lastDate,
                      onChanged: (range) => setState(() => _selectedRange = range),
                      tokens: tokens,
                    ),
                  ],
                ),
              ),
              // 底部按钮行
              _BottomBar(
                canConfirm: _canConfirm,
                onCancel: _cancel,
                onConfirm: _confirm,
                tokens: tokens,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _PresetTab — 快捷选项 Tab
// ---------------------------------------------------------------------------

class _PresetTab extends StatelessWidget {
  const _PresetTab({
    required this.builtinPresets,
    required this.customPresets,
    required this.selectedRange,
    required this.onSelected,
    required this.tokens,
  });

  final List<AppDateRangePreset> builtinPresets;
  final List<AppDateRangePresetOption> customPresets;
  final AppDateRange? selectedRange;
  final void Function(AppDateRange) onSelected;
  final AppColorTokens? tokens;

  @override
  Widget build(BuildContext context) {
    final brandPrimary =
        tokens?.brand.primary ?? Theme.of(context).colorScheme.primary;
    final bgSubtle =
        tokens?.bg.subtle ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final textPrimary =
        tokens?.text.primary ?? Theme.of(context).colorScheme.onSurface;
    final textSecondary =
        tokens?.text.secondary ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    // 将内置 preset 和自定义 preset 合并为统一列表
    final allItems = <({String label, AppDateRange range})>[
      for (final p in builtinPresets)
        if (p.toDateRange() case final r?) (label: p.label, range: r),
      for (final c in customPresets) (label: c.label, range: c.range),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.space5),
      itemCount: allItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.space3),
      itemBuilder: (context, index) {
        final item = allItems[index];
        final isSelected = selectedRange == item.range;
        return GestureDetector(
          onTap: () => onSelected(item.range),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space5,
              vertical: AppSpacing.space4,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? brandPrimary.withValues(alpha: 0.1)
                  : bgSubtle,
              border: Border.all(
                color: isSelected
                    ? brandPrimary
                    : Colors.transparent,
                width: 1.5,
              ),
              borderRadius: AppRadius.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTextStyles.body.copyWith(
                      color: isSelected ? brandPrimary : textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                Text(
                  '${_formatDate(item.range.startDate)} ~ ${_formatDate(item.range.endDate)}',
                  style: AppTextStyles.subhead.copyWith(
                    color: isSelected ? brandPrimary : textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// _CustomTab — 自定义日期区间 Tab
// ---------------------------------------------------------------------------

class _CustomTab extends StatefulWidget {
  const _CustomTab({
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    required this.tokens,
    this.initialRange,
  });

  final AppDateRange? initialRange;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(AppDateRange?) onChanged;
  final AppColorTokens? tokens;

  @override
  State<_CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<_CustomTab> {
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialRange?.startDate;
    _endDate = widget.initialRange?.endDate;
  }

  bool get _isValid =>
      _startDate != null &&
      _endDate != null &&
      !_endDate!.isBefore(_startDate!);

  void _notifyParent() {
    widget.onChanged(
      _isValid
          ? AppDateRange(startDate: _startDate!, endDate: _endDate!)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = widget.tokens;
    final brandPrimary =
        tokens?.brand.primary ?? Theme.of(context).colorScheme.primary;
    final statusError =
        tokens?.status.error ?? Theme.of(context).colorScheme.error;

    final calendarTheme = Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: brandPrimary,
        onPrimary: Colors.white,
        surface: Colors.transparent,
      ),
    );

    final showError = _startDate != null &&
        _endDate != null &&
        _endDate!.isBefore(_startDate!);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space5,
        vertical: AppSpacing.space3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DateLabel(label: '开始日期', date: _startDate, tokens: tokens),
          const SizedBox(height: AppSpacing.space2),
          Theme(
            data: calendarTheme,
            child: CalendarDatePicker(
              initialDate: _startDate ?? DateTime.now(),
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              onDateChanged: (date) {
                setState(() => _startDate = date);
                _notifyParent();
              },
            ),
          ),
          const SizedBox(height: AppSpacing.space5),
          _DateLabel(label: '结束日期', date: _endDate, tokens: tokens),
          const SizedBox(height: AppSpacing.space2),
          Theme(
            data: calendarTheme,
            child: CalendarDatePicker(
              initialDate: _endDate ?? DateTime.now(),
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              onDateChanged: (date) {
                setState(() => _endDate = date);
                _notifyParent();
              },
            ),
          ),
          if (showError) ...[
            const SizedBox(height: AppSpacing.space3),
            Text(
              '结束日期不能早于开始日期',
              style: AppTextStyles.subhead.copyWith(color: statusError),
            ),
          ],
          const SizedBox(height: AppSpacing.space5),
        ],
      ),
    );
  }
}

class _DateLabel extends StatelessWidget {
  const _DateLabel({
    required this.label,
    required this.date,
    required this.tokens,
  });

  final String label;
  final DateTime? date;
  final AppColorTokens? tokens;

  @override
  Widget build(BuildContext context) {
    final brandPrimary =
        tokens?.brand.primary ?? Theme.of(context).colorScheme.primary;
    final textSecondary =
        tokens?.text.secondary ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    final dateStr = date != null
        ? _formatDate(date!)
        : '未选择';

    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.labelMd.copyWith(color: textSecondary),
        ),
        const SizedBox(width: AppSpacing.space3),
        Text(
          dateStr,
          style: AppTextStyles.labelMd.copyWith(
            color: date != null ? brandPrimary : textSecondary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _BottomBar — 底部取消/确认按钮行
// ---------------------------------------------------------------------------

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.canConfirm,
    required this.onCancel,
    required this.onConfirm,
    required this.tokens,
  });

  final bool canConfirm;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final AppColorTokens? tokens;

  @override
  Widget build(BuildContext context) {
    final brandPrimary =
        tokens?.brand.primary ?? Theme.of(context).colorScheme.primary;
    final textSecondary =
        tokens?.text.secondary ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.space5,
        AppSpacing.space3,
        AppSpacing.space5,
        AppSpacing.space3 + bottomPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: textSecondary,
                side: BorderSide(color: textSecondary.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.space4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.md,
                ),
              ),
              child: const Text('取消'),
            ),
          ),
          const SizedBox(width: AppSpacing.space4),
          Expanded(
            child: FilledButton(
              onPressed: canConfirm ? onConfirm : null,
              style: FilledButton.styleFrom(
                backgroundColor: brandPrimary,
                disabledBackgroundColor:
                    brandPrimary.withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.space4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.md,
                ),
              ),
              child: const Text('确认'),
            ),
          ),
        ],
      ),
    );
  }
}
