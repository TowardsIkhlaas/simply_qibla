import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_qibla/helpers/compass_accuracy.dart';
import 'package:simply_qibla/widgets/compass_accuracy_indicator.dart';

void main() {
  group('CompassAccuracyIndicator', () {
    Future<void> pumpIndicator(
      WidgetTester tester, {
      required CompassAccuracy accuracy,
      required VoidCallback onTap,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompassAccuracyIndicator(
              accuracy: accuracy,
              onTap: onTap,
              semanticLabel: 'test-label',
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('renders and invokes onTap', (WidgetTester tester) async {
      int taps = 0;
      await pumpIndicator(
        tester,
        accuracy: CompassAccuracy.good,
        onTap: () => taps++,
      );

      await tester.tap(find.byType(CompassAccuracyIndicator));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('exposes the semantic label to accessibility',
        (WidgetTester tester) async {
      await pumpIndicator(
        tester,
        accuracy: CompassAccuracy.moderate,
        onTap: () {},
      );

      expect(find.bySemanticsLabel('test-label'), findsOneWidget);
    });

    testWidgets('poor state animates without throwing',
        (WidgetTester tester) async {
      await pumpIndicator(
        tester,
        accuracy: CompassAccuracy.poor,
        onTap: () {},
      );

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(CompassAccuracyIndicator), findsOneWidget);
    });

    testWidgets('rebuild across tiers does not throw',
        (WidgetTester tester) async {
      await pumpIndicator(
        tester,
        accuracy: CompassAccuracy.good,
        onTap: () {},
      );

      await pumpIndicator(
        tester,
        accuracy: CompassAccuracy.poor,
        onTap: () {},
      );
      await pumpIndicator(
        tester,
        accuracy: CompassAccuracy.moderate,
        onTap: () {},
      );

      expect(find.byType(CompassAccuracyIndicator), findsOneWidget);
    });
  });
}
