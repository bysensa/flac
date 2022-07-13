part of '../log.dart';

class LogRecordBuilder {
  int? _timestamp;
  int? _observedTimeStamp;
  TraceId? _traceId;
  SpanId? _spanId;
  int? _traceFlags;
  LogLevel? _logLevel;

  set timestamp(DateTime value) {
    _timestamp = value.microsecondsSinceEpoch * 1000;
  }

  set observedTimeStamp(DateTime value) {
    _observedTimeStamp = value.microsecondsSinceEpoch * 1000;
  }

  set traceId(TraceId value) {
    _traceId = value;
  }

  set spanId(SpanId value) {
    _spanId = value;
  }

  set traceFlags(int value) {
    _traceFlags = value;
  }

  set logLevel(LogLevel value) {
    _logLevel = value;
  }

  LogRecord build() {
    assert(body != null, 'body must be provided to builder');
    if (body == null) {
      return InvalidLogRecord();
    }
    return LogRecord(
      body: body!,
      timestamp: timestamp,
      attributes: attributes,
      instrumentationScope: instrumentationScope,
      observedTimeStamp: observedTimeStamp,
      resource: resource,
      severityNumber: severityNumber,
      severityText: severityText,
      spanId: spanId,
      traceFlags: traceFlags,
      traceId: traceId,
    );
  }
}
