import 'package:flutter/widgets.dart';

/// 表单校验器工厂集合。
///
/// 每个静态方法返回一个 [FormFieldValidator]（即 `String? Function(String?)`），
/// 与 Flutter 原生 [Form] / [TextFormField] / [AppFormField] 的 `validator` 参数直接兼容。
///
/// 使用示例：
/// ```dart
/// AppFormField(
///   label: '手机号',
///   validator: AppValidators.compose([
///     AppValidators.required(),
///     AppValidators.pattern(RegExp(r'^1[3-9]\d{9}$'), message: '请输入有效手机号'),
///   ]),
/// )
/// ```
abstract final class AppValidators {
  /// 必填校验：值为 null 或纯空白时返回错误信息。
  static FormFieldValidator<String> required({String? message}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? '此项不能为空';
      }
      return null;
    };
  }

  /// 最小长度校验：去除首尾空白后长度小于 [n] 时返回错误信息。
  static FormFieldValidator<String> minLength(int n, {String? message}) {
    return (value) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.length < n) {
        return message ?? '长度不能少于 $n 个字符';
      }
      return null;
    };
  }

  /// 最大长度校验：去除首尾空白后长度大于 [n] 时返回错误信息。
  static FormFieldValidator<String> maxLength(int n, {String? message}) {
    return (value) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.length > n) {
        return message ?? '长度不能超过 $n 个字符';
      }
      return null;
    };
  }

  /// 正则匹配校验：值不匹配 [regex] 时返回错误信息。
  ///
  /// 空值视为通过（配合 [required] 使用）。
  static FormFieldValidator<String> pattern(RegExp regex, {String? message}) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!regex.hasMatch(value)) {
        return message ?? '格式不正确';
      }
      return null;
    };
  }

  /// 数值范围校验：将值解析为 double，不在 [[min], [max]] 区间或无法解析时返回错误信息。
  ///
  /// 空值视为通过（配合 [required] 使用）。
  static FormFieldValidator<String> range(
    double min,
    double max, {
    String? message,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) return null;
      final parsed = double.tryParse(value.trim());
      if (parsed == null || parsed < min || parsed > max) {
        return message ?? '请输入 $min 到 $max 之间的数值';
      }
      return null;
    };
  }

  /// 组合校验：按顺序执行 [validators]，返回第一个非 null 的错误信息。
  ///
  /// 所有校验通过时返回 null。
  static FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
