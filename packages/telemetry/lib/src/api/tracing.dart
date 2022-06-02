mixin TraceTime {
  int get nanoseconds;
}

mixin TraceTimestamp {
  int get millisecondsSinceEpoch;
  int get nanosecondsSinceEpoch;
}

mixin TraceDuration {
  int get milliseconds;
  int get nanoseconds;
}

mixin TracerProvider {
  Tracer getTracer(String name, {String? version, String? schemaUrl});
}

mixin Tracer {
  Span createSpan();
}

mixin SpanContext {}

mixin Span {}

mixin SpanName {}

enum SpanKind { server, client, producer, consumer, internal }

mixin SpanLinks {}

mixin SpanLink {}
