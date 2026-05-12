import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('ResponsiveLayout', () {
    Widget buildUnderTest({
      required double width,
      required Widget mobile,
      Widget? tablet,
      Widget? desktop,
    }) {
      return MediaQuery(
        data: MediaQueryData(size: Size(width, 800)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ResponsiveLayout(
            mobile: mobile,
            tablet: tablet,
            desktop: desktop,
          ),
        ),
      );
    }

    testWidgets('width 400 (mobile) → shows mobile widget', (tester) async {
      await tester.pumpWidget(
        buildUnderTest(
          width: 400,
          mobile: const Text('mobile'),
          tablet: const Text('tablet'),
          desktop: const Text('desktop'),
        ),
      );
      expect(find.text('mobile'), findsOneWidget);
      expect(find.text('tablet'), findsNothing);
      expect(find.text('desktop'), findsNothing);
    });

    testWidgets('width 700 (tablet) → shows tablet widget', (tester) async {
      await tester.pumpWidget(
        buildUnderTest(
          width: 700,
          mobile: const Text('mobile'),
          tablet: const Text('tablet'),
          desktop: const Text('desktop'),
        ),
      );
      expect(find.text('tablet'), findsOneWidget);
      expect(find.text('mobile'), findsNothing);
      expect(find.text('desktop'), findsNothing);
    });

    testWidgets('width 700, no tablet → falls back to mobile widget',
        (tester) async {
      await tester.pumpWidget(
        buildUnderTest(
          width: 700,
          mobile: const Text('mobile'),
          desktop: const Text('desktop'),
        ),
      );
      expect(find.text('mobile'), findsOneWidget);
      expect(find.text('desktop'), findsNothing);
    });

    testWidgets('width 1400 (desktop) → shows desktop widget', (tester) async {
      await tester.pumpWidget(
        buildUnderTest(
          width: 1400,
          mobile: const Text('mobile'),
          tablet: const Text('tablet'),
          desktop: const Text('desktop'),
        ),
      );
      expect(find.text('desktop'), findsOneWidget);
      expect(find.text('mobile'), findsNothing);
      expect(find.text('tablet'), findsNothing);
    });
  });
}
