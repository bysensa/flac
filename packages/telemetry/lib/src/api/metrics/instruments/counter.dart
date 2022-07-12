import 'package:telemetry/src/api/common.dart';
import '../../context.dart';

import 'instrument.dart';

abstract class Counter<T extends num> extends Instrument {
  /// Records a value with a set of attributes.
  ///
  /// [value] is the increment amount. MUST be non-negative.
  /// [attributes] is a set of attributes to associate with the count.
  /// [context] is the explicit context to associate with this measurement.
  void add(T value, {Attributes attributes = const {}, Context? context});
}
