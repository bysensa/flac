import 'meter.dart';

abstract class MeterProvider {
  Meter meter(
    MeterName name, {
    MeterVersion? version,
    MeterSchemaUrl? schemaUrl,
  });
}
