import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('CountdownView', () {
    testWidgets('displays HH:MM:SS format when no days', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountdownView(
              remainingMs: 3661000, // 1h 1m 1s
              style: const TextStyle(),
            ),
          ),
        ),
      );

      expect(find.text('01 : 01 : 01'), findsOneWidget);
    });

    testWidgets('displays days when >= 1 day remaining', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountdownView(
              remainingMs: 90061000, // 1d 1h 1m 1s
              style: const TextStyle(),
            ),
          ),
        ),
      );

      expect(find.textContaining('天'), findsOneWidget);
    });

    testWidgets('calls onFinished when countdown reaches zero', (tester) async {
      bool finished = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountdownView(
              remainingMs: 1000,
              style: const TextStyle(),
              onFinished: () => finished = true,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));
      expect(finished, isTrue);
    });
  });

  group('DashedLine', () {
    testWidgets('renders horizontal dashed line', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              child: DashedLine(),
            ),
          ),
        ),
      );

      expect(find.byType(DashedLine), findsOneWidget);
    });

    testWidgets('renders vertical dashed line', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: DashedLine(axis: Axis.vertical),
            ),
          ),
        ),
      );

      expect(find.byType(DashedLine), findsOneWidget);
    });
  });

  group('KeepAliveWrapper', () {
    testWidgets('wraps child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KeepAliveWrapper(
              child: Text('keep alive'),
            ),
          ),
        ),
      );

      expect(find.text('keep alive'), findsOneWidget);
    });
  });

  group('MarqueeText', () {
    testWidgets('renders text without scroll when short', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: MarqueeText(text: 'Short'),
            ),
          ),
        ),
      );

      expect(find.text('Short'), findsOneWidget);
    });
  });

  group('SwiperDotIndicator', () {
    testWidgets('renders correct number of dots', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SwiperDotIndicator(count: 3, currentIndex: 0),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(3));
    });
  });

  group('SwiperCircleIndicator', () {
    testWidgets('renders correct number of circles', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SwiperCircleIndicator(count: 4, currentIndex: 1),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(4));
    });
  });

  group('SwiperRectangleIndicator', () {
    testWidgets('renders correct number of rectangles', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SwiperRectangleIndicator(count: 5, currentIndex: 2),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(5));
    });
  });

  group('SliverHeaderDelegate', () {
    testWidgets('fixed height renders child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: SliverHeaderDelegate.fixedHeight(
                    height: 60,
                    child: const Text('header'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('header'), findsOneWidget);
    });
  });
}
