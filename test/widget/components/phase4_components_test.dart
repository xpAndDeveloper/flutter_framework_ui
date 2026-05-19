import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework_ui/flutter_framework_ui.dart';

void main() {
  group('AppImage', () {
    testWidgets('renders with asset path', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppImage(url: 'assets/test.png', width: 100, height: 100),
          ),
        ),
      );
      expect(find.byType(AppImage), findsOneWidget);
    });
  });

  group('Avatar', () {
    testWidgets('renders container with specified size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Avatar(width: 60)),
        ),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Avatar),
          matching: find.byType(Container),
        ),
      );
      expect((container.constraints?.maxWidth ?? 0), greaterThan(0));
    });
  });

  group('EmptyPlaceholder', () {
    testWidgets('shows custom message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyPlaceholder(message: 'Nothing here'),
          ),
        ),
      );
      expect(find.text('Nothing here'), findsOneWidget);
    });
  });

  group('ShimmerBox', () {
    testWidgets('shows child when not loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerBox(
              isLoading: false,
              child: Text('content'),
            ),
          ),
        ),
      );
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('shows shimmer effect when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShimmerBox(
              isLoading: true,
              child: Container(width: 100, height: 20, color: Colors.grey),
            ),
          ),
        ),
      );
      expect(find.byType(ShimmerBox), findsOneWidget);
    });
  });

  group('CipherText', () {
    testWidgets('shows mask when isCipherText is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CipherText(text: '1234 5678', isCipherText: true),
          ),
        ),
      );
      expect(find.text('****'), findsOneWidget);
      expect(find.text('1234 5678'), findsNothing);
    });

    testWidgets('shows text when isCipherText is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CipherText(text: '1234 5678', isCipherText: false),
          ),
        ),
      );
      expect(find.text('1234 5678'), findsOneWidget);
    });

    testWidgets('reacts to ValueNotifier changes', (tester) async {
      final notifier = ValueNotifier<bool>(true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CipherText(
              text: 'secret',
              cipherNotifier: notifier,
            ),
          ),
        ),
      );

      expect(find.text('****'), findsOneWidget);

      notifier.value = false;
      await tester.pump();

      expect(find.text('secret'), findsOneWidget);
    });
  });

  group('PatternLock', () {
    testWidgets('renders CustomPaint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: PatternLock(
                onInputComplete: (_) {},
                onInputStart: () {},
              ),
            ),
          ),
        ),
      );
      expect(find.byType(CustomPaint), findsOneWidget);
    });
  });

  group('NumKeyboard', () {
    testWidgets('tapping 1 updates controller', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumKeyboard(
              controller: controller,
              onTextChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('1'));
      await tester.pump();
      expect(controller.text, '1');
    });

    testWidgets('backspace removes last character', (tester) async {
      final controller = TextEditingController(text: '12');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumKeyboard(
              controller: controller,
              onTextChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pump();
      expect(controller.text, '1');
    });
  });
}
