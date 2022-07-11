import 'package:telemetry/src/api/tracing/span_id.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('should create correct SpanId', () {
    final initialSpanId = SpanId.create();
    final spanIdFromHex = SpanId.fromHex(initialSpanId.hex);
    final spanIdFromBytes = SpanId.fromBytes(initialSpanId.bytes);

    expect(spanIdFromBytes, initialSpanId);
    expect(spanIdFromHex, initialSpanId);
  });
}
