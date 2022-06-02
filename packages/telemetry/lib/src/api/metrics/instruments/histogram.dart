import 'package:telemetry/src/api/common.dart';

import 'instrument.dart';

abstract class Histogram<T extends num> extends Instrument {
  /// Records a value with a set of attributes.
  ///
  /// [value] The amount of the measurement.
  /// [attributes] A set of attributes to associate with the count.
  /// [context] The explicit context to associate with this measurement.
  void record(
    double value, {
    Attributes attributes = const {},
    Context? context,
  });
}
