import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_framework_core/flutter_framework_core.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

/// 语言选择器组件。
///
/// 渲染传入的语言列表，当前选中语言高亮显示。
/// 内部通过 [appLocaleProvider] 驱动状态，点击时直接切换并持久化。
///
/// 示例：
/// ```dart
/// AppLocaleSelector(
///   supportedLocales: const [Locale('zh'), Locale('en')],
/// )
/// ```
///
/// 自定义语言名称显示：
/// ```dart
/// AppLocaleSelector(
///   supportedLocales: const [Locale('zh'), Locale('en')],
///   labelBuilder: (locale) => switch (locale.languageCode) {
///     'zh' => '中文',
///     'en' => 'English',
///     _ => locale.languageCode,
///   },
/// )
/// ```
class AppLocaleSelector extends ConsumerWidget {
  const AppLocaleSelector({
    super.key,
    required this.supportedLocales,
    this.labelBuilder,
  });

  /// 支持的语言列表，由接入方传入。
  final List<Locale> supportedLocales;

  /// 自定义语言名称显示函数。
  /// 若为 null，使用内置的语言名称映射。
  final String Function(Locale locale)? labelBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(appLocaleProvider);
    return Wrap(
      spacing: AppSpacing.space2,
      runSpacing: AppSpacing.space2,
      children: supportedLocales.map((locale) {
        final isSelected = currentLocale?.languageCode == locale.languageCode;
        final label = labelBuilder?.call(locale) ?? _defaultLabel(locale);
        return _LocaleChip(
          label: label,
          isSelected: isSelected,
          onTap: () => ref.read(appLocaleProvider.notifier).setLocale(locale),
        );
      }).toList(),
    );
  }

  static String _defaultLabel(Locale locale) => switch (locale.languageCode) {
        'zh' => '中文',
        'en' => 'English',
        'ja' => '日本語',
        'ko' => '한국어',
        'fr' => 'Français',
        'de' => 'Deutsch',
        'es' => 'Español',
        _ => locale.languageCode.toUpperCase(),
      };
}

class _LocaleChip extends StatelessWidget {
  const _LocaleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space5,
          vertical: AppSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppPrimitiveColors.brandPrimary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isSelected
                ? AppPrimitiveColors.brandPrimary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSm.copyWith(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
