# flutter_framework_ui

Flutter 框架体系的 **UI 设计系统层**。提供统一的设计 Token、可复用组件库、亮色/暗色主题、响应式布局和国际化工具。

## 接入

```yaml
dependencies:
  flutter_framework_base:
    git:
      url: git@kong:xpAndDeveloper/flutter_framework_base.git
      ref: v1.0.0
  flutter_framework_core:
    git:
      url: git@kong:xpAndDeveloper/flutter_framework_core.git
      ref: v1.0.0
  flutter_framework_ui:
    git:
      url: git@kong:xpAndDeveloper/flutter_framework_ui.git
      ref: v1.0.0
```

---

## 模块定位

```
flutter_framework_ui
        │
flutter_framework_core   ← 依赖（主题/语言 Provider）
        │
flutter_framework_base   ← 依赖（Result<T>）
```

**对外承诺：** 所有组件支持 `const` 构造、随 Theme 变化，满足 WCAG 2.1 AA 无障碍标准。

---

## 快速开始

在 `MaterialApp` 中接入主题：

```dart
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

MaterialApp.router(
  theme:     AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: ref.watch(themeModeProvider).toFlutterThemeMode(),
  // ...
)
```

---

## 主题系统

### 切换主题

```dart
// 切换到暗色
ref.read(themeModeProvider.notifier).setMode(AppThemeMode.dark);

// 切换到亮色
ref.read(themeModeProvider.notifier).setMode(AppThemeMode.light);

// 跟随系统
ref.read(themeModeProvider.notifier).setMode(AppThemeMode.system);

// 读取当前模式
final mode = ref.watch(themeModeProvider);  // AppThemeMode

// 开箱即用的选择器 Widget
const AppThemeModeSelector()
```

### 修改品牌色

只需改一处，`ColorScheme.fromSeed` 自动派生完整 Material 3 色阶：

```dart
// flutter_framework_ui/lib/src/presentation/theme/app_colors.dart
static const primary = Color(0xFF2563EB);   // 改为你的品牌色
```

### 访问语义颜色 Token

```dart
final t = Theme.of(context).extension<AppColorTokens>()!;

color: t.brand.primary      // 品牌主色
color: t.text.title         // 标题文字色
color: t.text.primary       // 正文主色（AI 写代码首选）
color: t.bg.page            // 页面背景色
color: t.status.error       // 错误语义色
color: t.finance.income     // 收入金额色（绿）
color: t.border.focus       // 聚焦边框色
```

---

## 设计 Token

### 间距

```dart
AppSpacing.space2   // 4dp   — 最小组件间距
AppSpacing.space3   // 8dp
AppSpacing.space4   // 12dp  — 卡片间距
AppSpacing.space5   // 16dp  — 页面左右边距、卡片内边距
AppSpacing.space7   // 24dp  — 区块间距
AppSpacing.space8   // 32dp
```

### 圆角

```dart
AppRadius.sm   // BorderRadius.circular(8)
AppRadius.md   // BorderRadius.circular(12)
AppRadius.lg   // BorderRadius.circular(16)
AppRadius.xl   // BorderRadius.circular(24)
```

### 文字样式

```dart
AppTextStyles.displayLg    // 大标题
AppTextStyles.headingMd    // 页面标题
AppTextStyles.labelMd      // 标签、小标题
AppTextStyles.bodyMd       // 正文
AppTextStyles.bodySm       // 辅助说明
```

---

## 组件库

### 页面骨架

```dart
AppScaffold(
  appBar: AppBar(title: const Text('页面标题')),
  body: ...,
)
```

### 按钮

```dart
AppButton(label: '确认', onPressed: () {})
AppButton(label: '次要操作', variant: AppButtonVariant.secondary, onPressed: () {})
AppButton(label: '边框按钮', variant: AppButtonVariant.outline, onPressed: () {})
AppButton(label: '删除', variant: AppButtonVariant.danger, onPressed: () {})
AppButton(label: '加载中', isLoading: true)
AppButton(label: '禁用', isDisabled: true)
AppButton(label: '带图标', icon: const Icon(Icons.add), onPressed: () {})

// 尺寸
AppButton(label: '小', size: AppButtonSize.small, onPressed: () {})
AppButton(label: '大', size: AppButtonSize.large, onPressed: () {})
```

### 输入框

```dart
AppTextField(
  label: '邮箱',
  hint: '请输入邮箱地址',
  controller: emailCtrl,
  prefixIcon: const Icon(Icons.email_outlined),
  onSubmitted: (v) => submit(v),
)
```

### 反馈

```dart
// SnackBar
AppSnackBar.show(context, message: '操作成功');
AppSnackBar.show(context, message: '网络错误', variant: AppSnackBarVariant.error);

// Dialog
await AppDialog.show(
  context,
  title: '确认删除',
  content: '删除后不可恢复，是否继续？',
  confirmLabel: '删除',
  confirmVariant: AppButtonVariant.danger,
);

// BottomSheet
await AppBottomSheet.show(context, child: const MySheetContent());
```

### 状态组件

```dart
const AppLoadingIndicator()                         // 加载指示器

AppErrorView(                                       // 错误视图
  message: '加载失败，请检查网络',
  onRetry: () => ref.invalidate(myProvider),
)

const AppSkeleton(width: 200, height: 20)           // 单行骨架屏
const AppSkeletonText(lines: 4)                     // 多行文字骨架屏

AppEmptyState(                                      // 空状态
  icon: const Icon(Icons.inbox_outlined),
  title: '暂无数据',
  subtitle: '下拉刷新重试',
)
```

### 列表 & 卡片

```dart
AppCard(
  onTap: () => navigate(),
  padding: const EdgeInsets.all(AppSpacing.space5),
  child: ...,
)

AppListTile(
  title: '设置项',
  subtitle: '副标题说明',
  leading: const Icon(Icons.settings_outlined),
  trailing: const Icon(Icons.chevron_right),
  onTap: () {},
)

const AppDivider()    // 分隔线
```

---

## 响应式布局

### 屏幕适配（750px 设计稿）

```dart
// 在根 Widget 的 build 中初始化一次
ScreenAdapter.init(context);

// 之后在任意 Widget 中使用扩展方法
Container(
  width:  375.w,       // 设计稿 375px → 实际宽度
  height:  60.h,       // 设计稿 60px  → 实际高度
  padding: EdgeInsets.all(16.r),  // 圆角/间距自适应
  child: Text('标题', style: TextStyle(fontSize: 18.sp)),
)
```

### 多端布局

```dart
ResponsiveLayout(
  mobile:  const MobileHomeLayout(),
  tablet:  const TabletHomeLayout(),
  desktop: const DesktopHomeLayout(),
)

// 或者用断点判断
if (AppBreakpoints.isMobile(context))  { ... }
if (AppBreakpoints.isTablet(context))  { ... }
if (AppBreakpoints.isDesktop(context)) { ... }
```

---

## 依赖

```yaml
dependencies:
  flutter_framework_base:
    path: ../flutter_framework_base
  flutter_framework_core:
    path: ../flutter_framework_core
  flutter_riverpod: ^2.x
```
