# flutter_framework_ui — 目录结构、依赖与设计决策

## 目录结构

```
lib/
├── src/
│   ├── domain/
│   │   └── (无，UI 层不含业务逻辑)
│   ├── data/
│   │   └── (无)
│   └── presentation/
│       ├── theme/
│       │   ├── app_theme.dart
│       │   ├── app_colors.dart
│       │   ├── app_text_styles.dart
│       │   └── app_spacing.dart
│       ├── components/
│       │   ├── buttons/
│       │   ├── inputs/
│       │   ├── feedback/
│       │   ├── layout/
│       │   └── navigation/
│       └── animations/
│           ├── app_transitions.dart
│           └── animation_presets.dart
├── flutter_framework_ui.dart
test/
├── widget/
│   └── (每个组件对应一个测试文件)
└── golden/
    └── (Golden 截图测试)
```

## 依赖关系

```yaml
dependencies:
  flutter_framework_base:
    path: ../flutter_framework_base
  flutter_framework_core:
    path: ../flutter_framework_core
  flutter_framework_network:
    path: ../flutter_framework_network
  flutter_framework_storage:
    path: ../flutter_framework_storage
  cached_network_image: ^3.x
  shimmer: ^3.x

dev_dependencies:
  golden_toolkit: ^0.x
  flutter_test:
    sdk: flutter
```

## 设计决策记录

| 决策 | 原因 |
|------|------|
| 基于 Material 3 而非自建设计系统 | 降低维护成本，跟随 Flutter 官方更新 |
| 使用 ThemeExtension 扩展 Token | 类型安全，与 Flutter 主题系统集成，支持热更新 |
| 组件不直接调用 GetIt | UI 组件保持纯展示职责，业务逻辑通过回调传入 |
| Golden 测试覆盖所有核心组件 | 防止视觉回归，在 CI 中自动检测 UI 变更 |
| const 构造函数强制要求 | 减少不必要的 Widget 重建，提升性能 |
