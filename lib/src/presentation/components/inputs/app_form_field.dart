import 'package:flutter/material.dart';

import 'app_text_field.dart';
import 'app_validators.dart';

/// 与 Flutter [Form] 集成的表单字段，使用 [AppTextField] 视觉样式。
///
/// 将 [TextFormField] 的 [FormState] 校验能力与 [AppTextField] 的外观结合，
/// 支持 [AppValidators] 工厂方法或任意 [FormFieldValidator]。
///
/// 使用示例：
/// ```dart
/// final _formKey = GlobalKey<FormState>();
///
/// Form(
///   key: _formKey,
///   child: Column(
///     children: [
///       AppFormField(
///         label: '手机号',
///         keyboardType: TextInputType.phone,
///         validator: AppValidators.compose([
///           AppValidators.required(),
///           AppValidators.pattern(RegExp(r'^1[3-9]\d{9}$'), message: '请输入有效手机号'),
///         ]),
///       ),
///       AppButton(
///         label: '提交',
///         onPressed: () {
///           if (_formKey.currentState!.validate()) {
///             // 校验通过
///           }
///         },
///       ),
///     ],
///   ),
/// )
/// ```
class AppFormField extends FormField<String> {
  AppFormField({
    super.key,
    TextEditingController? controller,
    String? label,
    String? hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
    int maxLines = 1,
    bool autofocus = false,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    super.validator,
    super.autovalidateMode,
    super.initialValue,
    super.onSaved,
  }) : super(
          builder: (FormFieldState<String> state) {
            return AppTextField(
              controller: controller,
              label: label,
              hint: hintText,
              errorText: state.errorText,
              obscureText: obscureText,
              keyboardType: keyboardType,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              enabled: enabled,
              maxLines: maxLines,
              autofocus: autofocus,
              onChanged: (value) {
                state.didChange(value);
                onChanged?.call(value);
              },
              onSubmitted: onSubmitted,
            );
          },
        );
}
