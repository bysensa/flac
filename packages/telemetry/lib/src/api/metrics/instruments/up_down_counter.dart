import 'package:telemetry/src/api/common.dart';
import '../../context.dart';

import 'instrument.dart';

class UpDownCounter<T extends num> extends Instrument {
  /// Records a value with a set of attributes.
  ///
  /// [value] is the increment amount. May be positive, negative or zero.
  /// [attributes] is a set of attributes to associate with the count.
  /// [context] is the explicit context to associate with this measurement.
  void add(T value, {Attributes attributes = const {}, Context? context}) {}

  @override
  // TODO: implement description
  InstrumentDescription get description => throw UnimplementedError();

  @override
  // TODO: implement kind
  InstrumentKind get kind => throw UnimplementedError();

  @override
  // TODO: implement name
  InstrumentName get name => throw UnimplementedError();

  @override
  // TODO: implement unit
  InstrumentUnit get unit => throw UnimplementedError();
}
