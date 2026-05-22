import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme_mode.dart';
import '../../theme/theme_mode_notifier.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

/// 主题模式选择器组件。
///
/// 渲染三个选项（亮色/暗色/跟随系统），当前选中项高亮显示。
/// 内部通过 [themeModeProvider] 驱动状态，点击时直接切换并持久化。
///
/// 示例：
/// ```dart
/// const AppThemeModeSelector()
/// ```
class AppThemeModeSelector extends ConsumerWidget {
  const AppThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themeModeProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: AppThemeMode.values.map((mode) {
        final isSelected = current == mode;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.space2),
          child: _ThemeModeChip(
            mode: mode,
            isSelected: isSelected,
            onTap: () => ref.read(themeModeProvider.notifier).setMode(mode),
          ),
        );
      }).toList(),
    );
  }
}

class _ThemeModeChip extends StatelessWidget {
  const _ThemeModeChip({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  final AppThemeMode mode;
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconFor(mode),
              size: 16,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: AppSpacing.space2),
            Text(
              _labelFor(mode),
              style: AppTextStyles.labelSm.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(AppThemeMode mode) => switch (mode) {
        AppThemeMode.light => Icons.light_mode_outlined,
        AppThemeMode.dark => Icons.dark_mode_outlined,
        AppThemeMode.system => Icons.brightness_auto_outlined,
      };

  String _labelFor(AppThemeMode mode) => switch (mode) {
        AppThemeMode.light => '亮色',
        AppThemeMode.dark => '暗色',
        AppThemeMode.system => '跟随系统',
      };
}
