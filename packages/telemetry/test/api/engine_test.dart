import 'dart:async';

import 'package:telemetry/src/api/engine.dart';
import 'package:test/test.dart';

void main() {
  test('should create TelemetryEngine', () async {
    final controller = StreamController();
    final engine = await TelemetryEngine.create(controller.sink);
    engine.send('hello');
    engine.send('world');
    expect(
      controller.stream,
      emitsInOrder([
        'Receive: hello',
        'Receive: world',
      ]),
    );
  });
}
