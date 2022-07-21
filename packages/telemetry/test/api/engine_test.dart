import 'dart:async';

import 'package:telemetry/src/api/common.dart';
import 'package:telemetry/src/api/engine.dart';
import 'package:test/test.dart';

void main() {
  test('should create TelemetryEngine', () async {
    final outputStreamController = StreamController<Signal>();
    final inputStreamController = StreamController<RawSignal>();
    final engine = await TelemetryEngine.create(
      outputStreamController.sink,
      inputStreamController.stream,
    );
    inputStreamController.add(TestRawSignal());
    inputStreamController.add(TestRawSignal());
    expect(
      outputStreamController.stream,
      emitsInOrder([
        'Receive: hello',
        'Receive: world',
      ]),
    );
  });
}

class TestRawSignal extends RawSignal {}
