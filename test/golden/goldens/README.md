# Golden Test Baselines

此目录存放 UI 组件的 Golden Screenshot 基线文件（`.png`）。

## 使用方法

### 生成 / 更新基线

首次建立或修改 UI 组件后，运行以下命令生成新的基线图片：

```bash
cd flutter_framework_ui
flutter test --update-goldens test/golden/
```

生成的 `.png` 文件需要提交到版本控制，作为后续对比的基准。

### 验证（CI / 日常开发）

```bash
cd flutter_framework_ui
flutter test test/golden/
```

若输出与基线不符，测试失败，并在 `test/golden/failures/` 目录生成差异图片。

## 覆盖范围

| 测试文件 | 组件 | 场景 |
|----------|------|------|
| `core_components_golden_test.dart` | AppButton | primary / outline / disabled |
| `core_components_golden_test.dart` | AppStepper | default / at min |
| `core_components_golden_test.dart` | AppCard | default |
| `core_components_golden_test.dart` | AppEmptyState | basic |

## 注意事项

- 基线在 **Linux + 特定 Flutter 版本** 下生成。不同平台的字体渲染可能不同，建议在 CI（ubuntu-latest）统一生成基线。
- `--update-goldens` 只应在有意修改 UI 时使用，不要在修复 bug 时随意更新基线。
