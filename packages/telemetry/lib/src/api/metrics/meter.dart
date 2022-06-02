import 'instruments.dart';

abstract class Meter {
  MeterName get name;
  MeterVersion get version;
  MeterSchemaUrl get schemaUrl;

  Counter createCounter();
  AsyncCounter createAsyncCounter();
  Histogram createHistogram();
  AsyncGauge createAsyncGauge();
  UpDownCounter createUpDownCounter();
  AsyncUpDownCounter createAsyncUpDownCounter();
}

class MeterName {}

class MeterVersion {}

class MeterSchemaUrl {}
