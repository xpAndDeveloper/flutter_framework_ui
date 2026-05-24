import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppValidators.required', () {
    final v = AppValidators.required();

    test('rejects null', () => expect(v(null), isNotNull));
    test('rejects empty string', () => expect(v(''), isNotNull));
    test('rejects whitespace only', () => expect(v('   '), isNotNull));
    test('accepts non-blank', () => expect(v('hello'), isNull));
    test('custom message', () {
      final msg = AppValidators.required(message: '必填')('');
      expect(msg, '必填');
    });
  });

  group('AppValidators.minLength', () {
    final v = AppValidators.minLength(6);

    test('rejects shorter than min', () => expect(v('abc'), isNotNull));
    test('accepts exact length', () => expect(v('abcdef'), isNull));
    test('accepts longer', () => expect(v('abcdefgh'), isNull));
    test('null treated as empty (length 0 < 6)', () => expect(v(null), isNotNull));
  });

  group('AppValidators.maxLength', () {
    final v = AppValidators.maxLength(10);

    test('rejects longer than max', () => expect(v('12345678901'), isNotNull));
    test('accepts exact length', () => expect(v('1234567890'), isNull));
    test('accepts shorter', () => expect(v('abc'), isNull));
  });

  group('AppValidators.pattern', () {
    final v = AppValidators.pattern(RegExp(r'^\d+$'));

    test('rejects non-matching', () => expect(v('abc'), isNotNull));
    test('accepts matching', () => expect(v('12345'), isNull));
    test('null passes (pair with required)', () => expect(v(null), isNull));
    test('empty passes (pair with required)', () => expect(v(''), isNull));
    test('custom message', () {
      final msg = AppValidators.pattern(RegExp(r'^\d+$'), message: '只能数字')('abc');
      expect(msg, '只能数字');
    });
  });

  group('AppValidators.range', () {
    final v = AppValidators.range(0, 100);

    test('rejects above max', () => expect(v('150'), isNotNull));
    test('rejects below min', () => expect(v('-1'), isNotNull));
    test('rejects non-numeric', () => expect(v('abc'), isNotNull));
    test('accepts min boundary', () => expect(v('0'), isNull));
    test('accepts max boundary', () => expect(v('100'), isNull));
    test('accepts mid value', () => expect(v('50'), isNull));
    test('null passes (pair with required)', () => expect(v(null), isNull));
    test('empty passes (pair with required)', () => expect(v(''), isNull));
  });

  group('AppValidators.compose', () {
    test('short-circuits on first error (required fails, minLength not reached)', () {
      final v = AppValidators.compose([
        AppValidators.required(message: 'req'),
        AppValidators.minLength(6, message: 'min'),
      ]);
      expect(v(''), 'req');
    });

    test('returns second error when first passes', () {
      final v = AppValidators.compose([
        AppValidators.required(message: 'req'),
        AppValidators.minLength(6, message: 'min'),
      ]);
      expect(v('abc'), 'min');
    });

    test('returns null when all validators pass', () {
      final v = AppValidators.compose([
        AppValidators.required(),
        AppValidators.minLength(3),
        AppValidators.maxLength(10),
      ]);
      expect(v('hello'), isNull);
    });

    test('empty validators list always passes', () {
      final v = AppValidators.compose([]);
      expect(v('anything'), isNull);
    });
  });
}
