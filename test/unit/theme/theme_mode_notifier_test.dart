import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_framework_base/flutter_framework_base.dart';
import 'package:flutter_framework_core/flutter_framework_core.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageService extends Mock implements StorageService {}

class _TestStorageException extends AppException {
  const _TestStorageException(super.message);
}

void main() {
  late MockStorageService mockStorage;
  late ProviderContainer container;

  setUp(() {
    mockStorage = MockStorageService();
    // Default: no persisted value
    when(() => mockStorage.read(any()))
        .thenAnswer((_) async => const Success(null));

    container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(mockStorage),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ThemeModeNotifier', () {
    test('initial state is system when no persisted value', () async {
      // Give time for async _loadFromStorage
      await Future.microtask(() {});
      expect(container.read(themeModeProvider), equals(AppThemeMode.system));
    });

    test('initial state restores light from storage', () async {
      when(() => mockStorage.read('app_theme_mode'))
          .thenAnswer((_) async => const Success('light'));

      final c = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(c.dispose);
      // Read the provider to trigger construction, then await the async load
      c.read(themeModeProvider);
      await Future.delayed(Duration.zero);
      expect(c.read(themeModeProvider), equals(AppThemeMode.light));
    });

    test('initial state restores dark from storage', () async {
      when(() => mockStorage.read('app_theme_mode'))
          .thenAnswer((_) async => const Success('dark'));

      final c = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(c.dispose);
      c.read(themeModeProvider);
      await Future.delayed(Duration.zero);
      expect(c.read(themeModeProvider), equals(AppThemeMode.dark));
    });

    test('setMode to light updates state and persists', () async {
      when(() => mockStorage.write(any(), any()))
          .thenAnswer((_) async => const Success(null));

      await container.read(themeModeProvider.notifier).setMode(AppThemeMode.light);

      expect(container.read(themeModeProvider), equals(AppThemeMode.light));
      verify(() => mockStorage.write('app_theme_mode', 'light')).called(1);
    });

    test('setMode to dark updates state and persists', () async {
      when(() => mockStorage.write(any(), any()))
          .thenAnswer((_) async => const Success(null));

      await container.read(themeModeProvider.notifier).setMode(AppThemeMode.dark);

      expect(container.read(themeModeProvider), equals(AppThemeMode.dark));
      verify(() => mockStorage.write('app_theme_mode', 'dark')).called(1);
    });

    test('setMode to system updates state and persists', () async {
      when(() => mockStorage.write(any(), any()))
          .thenAnswer((_) async => const Success(null));

      // First set dark
      await container.read(themeModeProvider.notifier).setMode(AppThemeMode.dark);
      // Then back to system
      await container.read(themeModeProvider.notifier).setMode(AppThemeMode.system);

      expect(container.read(themeModeProvider), equals(AppThemeMode.system));
      verify(() => mockStorage.write('app_theme_mode', 'system')).called(1);
    });

    test('invalid stored value falls back to system', () async {
      when(() => mockStorage.read('app_theme_mode'))
          .thenAnswer((_) async => const Success('invalid_value'));

      final c = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(c.dispose);

      await Future.microtask(() {});
      // invalid_value 找不到对应枚举，应保持 system 默认值
      expect(c.read(themeModeProvider), equals(AppThemeMode.system));
    });

    test('storage failure falls back to system', () async {
      when(() => mockStorage.read('app_theme_mode')).thenAnswer(
        (_) async => const Failure(_TestStorageException('read error')),
      );

      final c = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
      );
      addTearDown(c.dispose);

      await Future.microtask(() {});
      expect(c.read(themeModeProvider), equals(AppThemeMode.system));
    });
  });

  group('AppThemeModeX', () {
    test('light maps to ThemeMode.light', () {
      expect(AppThemeMode.light.toFlutterThemeMode(), equals(ThemeMode.light));
    });

    test('dark maps to ThemeMode.dark', () {
      expect(AppThemeMode.dark.toFlutterThemeMode(), equals(ThemeMode.dark));
    });

    test('system maps to ThemeMode.system', () {
      expect(AppThemeMode.system.toFlutterThemeMode(), equals(ThemeMode.system));
    });
  });
}
