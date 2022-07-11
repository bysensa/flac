import 'package:telemetry/src/api/tracing/trace_id.dart';
import 'package:test/test.dart';

void main() {
  test('should create correct TraceId', () {
    final initialTraceId = TraceId.create();
    final traceIdFromHex = TraceId.fromHex(initialTraceId.hex);
    final traceIdFromBytes = TraceId.fromBytes(initialTraceId.bytes);

    expect(traceIdFromBytes, initialTraceId);
    expect(traceIdFromHex, initialTraceId);
  });
}
