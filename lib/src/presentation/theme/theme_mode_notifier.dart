import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_framework_core/flutter_framework_core.dart';
import 'app_theme_mode.dart';

/// 管理应用主题模式（亮色/暗色/跟随系统）的状态。
///
/// 状态自动持久化到 [StorageService]，应用重启后恢复。
/// 默认值为 [AppThemeMode.system]（跟随系统）。
///
/// 用法：
/// ```dart
/// // 切换到暗色模式
/// ref.read(themeModeProvider.notifier).setMode(AppThemeMode.dark);
///
/// // 在 MaterialApp 中消费
/// themeMode: ref.watch(themeModeProvider).toFlutterThemeMode(),
/// ```
class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier(this._storage) : super(AppThemeMode.system) {
    _loadFromStorage();
  }

  final StorageService _storage;
  static const _storageKey = 'app_theme_mode';

  /// 切换主题模式并持久化。
  Future<void> setMode(AppThemeMode mode) async {
    state = mode;
    await _storage.write(_storageKey, mode.name);
  }

  Future<void> _loadFromStorage() async {
    final result = await _storage.read(_storageKey);
    result.fold(
      onSuccess: (value) {
        if (value != null && value.isNotEmpty) {
          // byName 在找不到时会抛出，用 firstWhereOrNull 更安全
          final matched = AppThemeMode.values.where((e) => e.name == value).firstOrNull;
          if (matched != null) state = matched;
        }
      },
      onFailure: (_) {
        // 读取失败时保留默认值 system，不向上抛出
      },
    );
  }
}

/// 应用主题模式 Provider。
///
/// 依赖 [storageServiceProvider]，接入方必须在 [ProviderScope] 中覆盖后者。
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>(
  (ref) => ThemeModeNotifier(ref.read(storageServiceProvider)),
);
