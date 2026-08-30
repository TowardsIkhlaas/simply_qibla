/// Represents the current confidence in the device's compass heading.
enum CompassAccuracy { good, moderate, poor, unknown }

/// Classifies a raw accuracy reading from `flutter_compass` into a tier.
///
/// The plugin normalizes both platforms into a "degrees of deviation" value:
/// - iOS returns the platform-reported max deviation directly.
/// - Android maps SENSOR_STATUS_ACCURACY_HIGH/MEDIUM/LOW to 15/30/45 and
///   UNRELIABLE/UNKNOWN to -1 (surfaced as null in Dart).
///
/// Lower values are more accurate.
CompassAccuracy classifyAccuracy(double? raw) {
  if (raw == null || raw < 0) return CompassAccuracy.unknown;
  if (raw <= 15) return CompassAccuracy.good;
  if (raw <= 30) return CompassAccuracy.moderate;
  return CompassAccuracy.poor;
}

/// Debounces rapid tier changes from the compass stream.
///
/// A new tier must be observed [_requiredStreak] samples in a row before it
/// becomes the reported state. At ~10Hz that's roughly 300ms, which feels
/// responsive without strobing.
class AccuracyHysteresis {
  AccuracyHysteresis({CompassAccuracy initial = CompassAccuracy.unknown})
      : _current = initial,
        _candidate = initial;

  static const int _requiredStreak = 3;

  CompassAccuracy _current;
  CompassAccuracy _candidate;
  int _streak = 0;

  CompassAccuracy get current => _current;

  /// Feeds a new sample and returns the current tier after debouncing.
  CompassAccuracy update(CompassAccuracy sample) {
    if (sample == _current) {
      _candidate = _current;
      _streak = 0;
      return _current;
    }
    if (sample == _candidate) {
      _streak++;
    } else {
      _candidate = sample;
      _streak = 1;
    }
    if (_streak >= _requiredStreak) {
      _current = _candidate;
      _streak = 0;
    }
    return _current;
  }
}
