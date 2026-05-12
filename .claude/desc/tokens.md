# flutter_framework_ui — 设计 Token 与主题系统

> 基于 UPay Design System v1.0.5，2026-04 全量重写。

---

## 颜色系统

### 两层结构

| 层 | 类 | 作用 |
|----|-----|------|
| 原始色板 | `UPayColors` | 所有原始 HEX 常量，Light/Dark 各维护独立字段 |
| 语义 Token | `AppColorTokens` (ThemeExtension) | 结构化命名空间，注入 ThemeData，运行时跟随主题 |

### UPayColors — 原始色板（可直接复用）

```dart
// 品牌色
UPayColors.brandPrimary       // #00BD8D — 主色
UPayColors.brandPrimaryHover  // #00A87D
UPayColors.brandPrimaryCta    // #00BD8D — 按钮背景
UPayColors.brandSecondaryLight / brandSecondaryDark

// 状态色（Light 和 Dark 各一套 Soft 变体）
UPayColors.statusSuccess / statusSuccessSoftLight / statusSuccessSoftDark
UPayColors.statusWarning / statusWarningSoftLight / statusWarningSoftDark
UPayColors.statusError   / statusErrorSoftLight   / statusErrorSoftDark

// 金融语义色
UPayColors.financeIncome   // #00BD8D
UPayColors.financeExpense  // #DE4B4B
UPayColors.financePending  // #FF9500
UPayColors.financeRefund   // #3B82F6

// 文字色
UPayColors.textPrimaryLight / textPrimaryDark
UPayColors.textSecondaryLight / textSecondaryDark
UPayColors.textTertiaryLight / textTertiaryDark
UPayColors.textDisabledLight / textDisabledDark
UPayColors.textOnPrimaryCta  // #FFFFFF（按钮内文字，不分亮暗）

// 背景色
UPayColors.bgPageLight / bgPageDark
UPayColors.bgBaseLight / bgBaseDark
UPayColors.bgSubtleLight / bgSubtleDark
UPayColors.bgElevatedLight / bgElevatedDark  // 卡片背景

// 边框色
UPayColors.borderDefaultLight / borderDefaultDark
UPayColors.borderDividerLight / borderDividerDark
UPayColors.borderFocus        // #00BD8D（不分亮暗）
```

**外部复用**：`UPayColors` 已从 barrel 导出，直接 `import 'package:flutter_framework_ui/flutter_framework_ui.dart'` 即可使用。

---

### AppColorTokens — 语义 ThemeExtension

六个命名空间，均为 `@immutable` 数据类，支持 `copyWith` 和 `lerp`：

```dart
final t = Theme.of(context).extension<AppColorTokens>()!;

t.brand.primary       // 品牌主色
t.brand.primaryCta    // CTA 按钮背景
t.brand.primarySoft   // 浅色背景 badge

t.status.success / successSoft
t.status.warning / warningSoft
t.status.error   / errorSoft

t.finance.income  // 收入绿
t.finance.expense // 支出红
t.finance.pending // 待处理橙

t.text.title      // 一级标题
t.text.body       // 正文
t.text.primary    // AI 写代码时首选（= title = body）
t.text.secondary  // 次级文字
t.text.muted      // 辅助说明
t.text.disabled
t.text.onPrimaryCta  // CTA 按钮内文字

t.bg.page         // 页面背景（最底层）
t.bg.base         // 基础面板背景
t.bg.subtle       // 轻度填充（输入框）
t.bg.elevated     // 卡片背景（最上层）
t.bg.overlay      // 浮层蒙版

t.border.defaultColor  // 普通边框
t.border.divider       // 分隔线
t.border.focus         // 聚焦边框（= brandPrimary）

t.shimmerBase      // 骨架屏基色 (= bg.subtle)
t.shimmerHighlight // 骨架屏高光 (= bg.base)
```

**注意**：`text.primary` 是 AI 写代码时的默认锚点，与 `text.title`/`text.body` 值相同，这是有意为之，避免 AI 在不确定语义时猜测错误。

---

## 字体系统（AppTextStyles）

字体族：Roboto → Source Han Sans SC → Noto Sans SC → PingFang SC → system-ui

**Token 层存储设计稿 pt 值（不做运行时换算）**，调用方按需适配：

```dart
// 直接使用（固定 pt 值）
AppTextStyles.body

// ScreenAdapter 适配
AppTextStyles.body.copyWith(fontSize: 14.sp)
```

### 通用字阶

| Token | size/行高 | weight | 用途 |
|-------|-----------|--------|------|
| `display` | 32/1.0 | 700 | 大数字、强调展示 |
| `title1` | 18/1.0 | 600 | 一级标题 |
| `title2` | 16/1.0 | 600 | 页面主标题 |
| `title3` | 14/1.0 | 600 | 导航/模块标题 |
| `headline` | 14/1.0 | 600 | 列表标题 |
| `body` | 14/1.43 | 400 | 正文 |
| `subhead` | 12/1.33 | 400 | 次级说明 |
| `footnote` | 12/1.33 | 400 | 表单辅助说明 |
| `footnote2` | 10/1.2 | 400 | 数字角标 |
| `caption1` | 12/1.33 | 400+0.1 | 标签/时间戳 |
| `caption2` | 10/1.2 | 400+0.1 | 紧凑按钮 |

### 金额特规（固定 Roboto 字体）

| Token | size | weight | 用途 |
|-------|------|--------|------|
| `amountComplete` | 32 | 700 | 支付成功主金额 |
| `amountBalance` | 28 | 600 | 首页余额 |
| `amountConfirm` | 24 | 600 | 转账确认 |
| `amountInput` | 32 | 600 | 金额输入框 |
| `amountList` | 14 | 600 | 列表金额 |
| `amountSmall` | 12 | 500 | 小金额 |
| `amountRate` | 10 | 500 | 费率 |

---

## 间距系统（AppSpacing）

4pt 基础，12 档：

| Token | pt | Token | pt |
|-------|-----|-------|-----|
| space1 | 2 | space7 | 24 |
| space2 | 4 | space8 | 32 |
| space3 | 8 | space9 | 40 |
| space4 | 12 | space10 | 48 |
| space5 | 16 | space11 | 60 |
| space6 | 20 | space12 | 80 |

常用场景：`space5`(16) = 页面左右边距、卡片内边距；`space4`(12) = 卡片间距；`space7`(24) = 区块间距。

---

## 圆角系统（AppRadius）

8 档，同时提供 `BorderRadius` 和 `Radius` 两种常量：

| Token | pt | 用途 |
|-------|-----|------|
| xs | 2 | 细小标签 |
| s | 4 | 小按钮 |
| sm | 8 | 按钮/输入框/Toast |
| md | 12 | 卡片/列表项 |
| lg | 16 | 大卡片 |
| xl | 20 | Alert |
| r2xl | 24 | Bottom Sheet |
| full | 9999 | 胶囊/头像/圆形图标 |

```dart
// BorderRadius（用于 decoration）
AppRadius.sm   // BorderRadius.all(Radius.circular(8))

// Radius（用于 ClipRRect 等）
AppRadius.radiusSm  // Radius.circular(8)
```

---

## 阴影系统（AppShadow）

6 组，每组 Light 为 BoxShadow 列表，Dark 为空列表（= CSS none）：

```dart
// 静态访问
AppShadow.smLight    // 卡片默认阴影（2层）
AppShadow.mdLight    // 悬浮卡片
AppShadow.lgLight    // 弹层
AppShadow.xlLight    // 模态框
AppShadow.brandLight // 主按钮悬浮
AppShadow.successLight // 支付成功

// 主题感知（推荐）
BoxDecoration(boxShadow: AppShadow.sm(context))
BoxDecoration(boxShadow: AppShadow.brand(context))
```

---

## 主题系统（AppTheme）

```dart
MaterialApp(
  theme:     AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: themeMode.toFlutterThemeMode(),
)
```

Dark 模式特性：所有 `elevation = 0`，无阴影，通过背景色层级（`bg.page` → `bg.base` → `bg.elevated`）区分视觉层次。

---

## Breaking Changes（v1.0.5 迁移）

| 旧字段 | 新字段 | 说明 |
|--------|--------|------|
| `AppColorTokens.cardBackground` | `t.bg.elevated` | 卡片背景 |
| `AppColorTokens.divider` | `t.border.divider` | 分隔线 |
| `AppColorTokens.inputBorder` | `t.border.defaultColor` | 输入框边框 |
| `AppColorTokens.inputFill` | `t.bg.subtle` | 输入框填充 |
| `AppColors.*` | `UPayColors.*` | 原始色板已迁移到 UPayColors |
| `AppSpacing.xs/sm/md/lg/xl/xxl` | `space2~space10` | 间距数字命名 |
| `AppRadius.md/lg/xl` | 值有变化，含义不变 | 8→12/12→16/16→20 |

旧字段保留 `@Deprecated` 注解，不会立即编译失败，但应尽快迁移。
