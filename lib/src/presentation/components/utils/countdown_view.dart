import 'dart:async';
import 'package:flutter/material.dart';

class CountdownView extends StatefulWidget {
  const CountdownView({
    super.key,
    this.duration,
    @Deprecated('Use duration instead') this.remainingMs,
    this.style,
    this.onFinished,
  }) : assert(
          duration != null || remainingMs != null,
          'Provide either duration or remainingMs',
        );

  /// 倒计时时长，推荐使用此参数。
  final Duration? duration;

  /// 剩余毫秒数，已废弃，请改用 [duration]。
  @Deprecated('Use duration instead')
  final int? remainingMs;

  /// 文字样式，null 时跟随主题 textTheme.bodyMedium。
  final TextStyle? style;
  final VoidCallback? onFinished;

  @override
  State<CountdownView> createState() => _CountdownViewState();
}

class _CountdownViewState extends State<CountdownView> {
  Timer? _timer;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _resolveMs();
    _startTimer();
  }

  int _resolveMs() {
    // ignore: deprecated_member_use_from_same_package
    return widget.duration?.inMilliseconds ?? widget.remainingMs ?? 0;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1000) {
        _remaining = 0;
        _timer?.cancel();
        widget.onFinished?.call();
      } else {
        _remaining -= 1000;
      }
      setState(() {});
    });
  }

  String _pad(int value) => value.toString().padLeft(2, '0');

  String? _getDays() {
    final days = _remaining ~/ 1000 ~/ 60 ~/ 60 ~/ 24;
    return days == 0 ? null : _pad(days);
  }

  String _getHours() => _pad(_remaining ~/ 1000 ~/ 60 ~/ 60 % 24);
  String _getMinutes() => _pad(_remaining ~/ 1000 ~/ 60 % 60);
  String _getSeconds() => _pad(_remaining ~/ 1000 % 60);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDays();
    final timeStr = days != null
        ? '$days天 ${_getHours()} : ${_getMinutes()} : ${_getSeconds()}'
        : '${_getHours()} : ${_getMinutes()} : ${_getSeconds()}';
    final effectiveStyle =
        widget.style ?? Theme.of(context).textTheme.bodyMedium;
    return Text(timeStr, style: effectiveStyle);
  }
}
