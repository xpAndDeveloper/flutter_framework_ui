# flutter_framework_ui — 组件规范与响应式布局

## 组件规范

```dart
// 所有组件遵循此模式：
class AppButton extends StatelessWidget {
  const AppButton({                    // 1. const 构造函数
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;      // 2. 使用枚举控制变体
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    // 3. 从 Theme 读取样式，不硬编码颜色
    final colors = Theme.of(context).extension<AppColorTokens>()!;
    // ...
  }
}

enum AppButtonVariant { primary, secondary, outline, ghost, danger }
enum AppButtonSize { small, medium, large }
```

## 组件库清单

| 类别 | 组件 |
|------|------|
| **按钮** | `AppButton`、`AppIconButton`、`AppTextButton`、`AppFloatingButton` |
| **输入** | `AppTextField`、`AppSearchField`、`AppDropdown`、`AppDatePicker` |
| **反馈** | `AppDialog`、`AppBottomSheet`、`AppSnackBar`、`AppToast`、`AppLoadingOverlay` |
| **列表** | `AppListTile`、`AppCard`、`AppDivider`、`AppEmptyState` |
| **导航** | `AppAppBar`、`AppBottomNavBar`、`AppTabBar`、`AppDrawer` |
| **状态** | `AppLoadingIndicator`、`AppErrorView`、`AppEmptyView`、`AppSkeleton` |
| **布局** | `AppScaffold`、`ResponsiveLayout`、`AppSpacingBox`、`AppSafeArea` |

## 响应式布局

```dart
// 断点定义（移动优先，基于屏幕宽度）
class AppBreakpoints {
  static const mobile  = 600.0;   // < 600   手机竖屏
  static const tablet  = 960.0;   // 600~959 手机横屏 / 平板竖屏
  static const desktop = 1280.0;  // ≥ 960   平板横屏 / 桌面

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= mobile && w < desktop;
  }
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;
}

// 响应式构建工具（三档降级：desktop → tablet → mobile）
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;   // 未提供时降级使用 mobile
  final Widget? desktop;  // 未提供时降级使用 tablet ?? mobile

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.desktop && desktop != null) return desktop!;
    if (width >= AppBreakpoints.mobile && tablet != null) return tablet!;
    return mobile;
  }
}

// 响应式数值工具（用于间距、字号等随断点变化的场景）
class ResponsiveValue<T> {
  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final T mobile;
  final T? tablet;
  final T? desktop;

  T resolve(BuildContext context) {
    if (AppBreakpoints.isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (AppBreakpoints.isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
}
```

## 适配编码规范

**1. 移动优先**：始终以 `mobile` 参数为基准实现，tablet/desktop 为增强。

```dart
// 正确：移动优先，平板增强
ResponsiveLayout(
  mobile:  const AssetListView(),
  tablet:  const AssetSplitView(),   // 平板双栏
)

// 错误：不要在 build 里直接 if/else 写死尺寸
if (MediaQuery.of(context).size.width > 600) { ... }  // 禁止散落在组件中
```

**2. 使用 `MediaQuery.sizeOf` 而非 `MediaQuery.of`**：避免无关属性变更触发重建。

```dart
// 正确
final width = MediaQuery.sizeOf(context).width;

// 错误：订阅了整个 MediaQueryData，textScaleFactor 变化也会触发重建
final width = MediaQuery.of(context).size.width;
```

**3. 安全区域**：所有页面级组件必须包裹 `AppSafeArea`，保证刘海屏/底部手势条不遮挡关键操作区。
