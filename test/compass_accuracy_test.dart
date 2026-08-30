import 'package:flutter_test/flutter_test.dart';
import 'package:simply_qibla/helpers/compass_accuracy.dart';

void main() {
  group('classifyAccuracy', () {
    test('null maps to unknown', () {
      expect(classifyAccuracy(null), CompassAccuracy.unknown);
    });

    test('negative values map to unknown', () {
      expect(classifyAccuracy(-1), CompassAccuracy.unknown);
      expect(classifyAccuracy(-99), CompassAccuracy.unknown);
    });

    test('Android HIGH (15) lands in good', () {
      expect(classifyAccuracy(15), CompassAccuracy.good);
    });

    test('values below 15 are good', () {
      expect(classifyAccuracy(0), CompassAccuracy.good);
      expect(classifyAccuracy(14.9), CompassAccuracy.good);
    });

    test('Android MEDIUM (30) lands in moderate', () {
      expect(classifyAccuracy(30), CompassAccuracy.moderate);
    });

    test('values in (15, 30] are moderate', () {
      expect(classifyAccuracy(15.1), CompassAccuracy.moderate);
      expect(classifyAccuracy(29.9), CompassAccuracy.moderate);
    });

    test('Android LOW (45) lands in poor', () {
      expect(classifyAccuracy(45), CompassAccuracy.poor);
    });

    test('values above 30 are poor', () {
      expect(classifyAccuracy(30.1), CompassAccuracy.poor);
      expect(classifyAccuracy(180), CompassAccuracy.poor);
    });
  });

  group('AccuracyHysteresis', () {
    test('reports initial state without any samples', () {
      final AccuracyHysteresis h = AccuracyHysteresis();
      expect(h.current, CompassAccuracy.unknown);
    });

    test('does not switch tier on a single divergent sample', () {
      final AccuracyHysteresis h =
          AccuracyHysteresis(initial: CompassAccuracy.good);
      expect(h.update(CompassAccuracy.poor), CompassAccuracy.good);
    });

    test('switches after three consecutive samples in the new tier', () {
      final AccuracyHysteresis h =
          AccuracyHysteresis(initial: CompassAccuracy.good);
      expect(h.update(CompassAccuracy.poor), CompassAccuracy.good);
      expect(h.update(CompassAccuracy.poor), CompassAccuracy.good);
      expect(h.update(CompassAccuracy.poor), CompassAccuracy.poor);
    });

    test('resets streak when candidate changes', () {
      final AccuracyHysteresis h =
          AccuracyHysteresis(initial: CompassAccuracy.good);
      h.update(CompassAccuracy.poor);
      h.update(CompassAccuracy.poor);
      // A different tier interrupts the streak; poor should NOT commit next.
      expect(h.update(CompassAccuracy.moderate), CompassAccuracy.good);
      expect(h.update(CompassAccuracy.poor), CompassAccuracy.good);
    });

    test('a sample matching current tier resets the pending streak', () {
      final AccuracyHysteresis h =
          AccuracyHysteresis(initial: CompassAccuracy.good);
      h.update(CompassAccuracy.poor);
      h.update(CompassAccuracy.poor);
      // Bouncing back to current wipes the pending switch.
      expect(h.update(CompassAccuracy.good), CompassAccuracy.good);
      expect(h.update(CompassAccuracy.poor), CompassAccuracy.good);
    });
  });
}
