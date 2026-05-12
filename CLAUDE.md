# flutter_framework_ui — 模块知识库

## 启动时必须执行

**进入此目录时，立即读取：**
1. `AGENTS.md` — 当前身份（UI 设计系统工程师）与工作边界
2. `.claude/desc/tokens.md` — 设计 Token 与主题系统
3. `.claude/desc/components.md` — 组件规范与响应式布局
4. `.claude/desc/structure.md` — 目录结构与依赖

---

## 模块职责

本模块是框架的**UI 设计系统层**，提供统一的视觉语言、可复用组件库和主题管理。

**职责范围：**
- 设计 Token（颜色、字体、间距、圆角、阴影）
- 主题系统（亮色/暗色/自定义主题）
- 通用组件库（按钮、输入框、对话框、列表等）
- 动画工具和过渡效果
- 响应式布局工具
- 可访问性支持

**依赖关系：**
```
flutter_framework_base
flutter_framework_core
flutter_framework_network  ←  flutter_framework_ui
flutter_framework_storage
```

**对外承诺：**
- 所有组件支持 `const` 构造函数
- 所有组件支持主题定制
- 所有组件满足 WCAG 2.1 AA 无障碍标准
- 不在组件内部直接调用网络/存储，通过回调/接口解耦

---

## 知识库索引

| 文档 | 内容 |
|------|------|
| [设计 Token 与主题](.claude/desc/tokens.md) | AppColors、AppSpacing、AppTextStyles、AppRadius、AppTheme、ThemeExtension |
| [组件规范与响应式布局](.claude/desc/components.md) | 组件开发模式、组件库清单、ResponsiveLayout、AppBreakpoints、适配编码规范 |
| [目录结构与依赖](.claude/desc/structure.md) | 目录结构、pubspec 依赖、设计决策记录 |
