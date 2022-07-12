import 'types.dart';
import 'instruments.dart';

class Meter {
  final MeterName name;
  final MeterVersion version;
  final MeterSchemaUrl schemaUrl;

  const Meter({
    required this.name,
    required this.version,
    required this.schemaUrl,
  });

  Counter createCounter() => Counter();
  AsyncCounter createAsyncCounter() => AsyncCounter();
  Histogram createHistogram() => Histogram();
  AsyncGauge createAsyncGauge() => AsyncGauge();
  UpDownCounter createUpDownCounter() => UpDownCounter();
  AsyncUpDownCounter createAsyncUpDownCounter() => AsyncUpDownCounter();
}
