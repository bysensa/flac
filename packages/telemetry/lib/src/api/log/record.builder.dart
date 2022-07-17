part of '../log.dart';

class LogRecordBuilder {
  int? _timestamp;
  int? _observedTimeStamp;
  TraceId? _traceId;
  SpanId? _spanId;
  int? _traceFlags;
  LogLevel? _logLevel;
  String _body = '';
  Map<String, dynamic> _attributes = {};

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

  set body(List<dynamic> value) {
    final bodyParts = [];
    for (final part in value) {
      if (part is Exception || part is Error) {
        _attributes['exception.type'] = part.runtimeType.toString();
        _attributes['exception.message'] = part.toString();
      } else if (part is StackTrace) {
        _attributes['exception.stacktrace'] =
            Chain.forTrace(trace).terse.toString();
      } else {
        bodyParts.add(part);
      }
    }
    _body = (StringBuffer()..writeAll(bodyParts, ' ')).toString();
  }

  set attributes(Map<String, dynamic> value) {
    _attributes.addAll(value.flatten());
  }

  // LogRecord build() {
  //   assert(body != null, 'body must be provided to builder');
  //   if (body == null) {
  //     return InvalidLogRecord();
  //   }
  //   return LogRecord(
  //     body: body!,
  //     timestamp: timestamp,
  //     attributes: attributes,
  //     instrumentationScope: instrumentationScope,
  //     observedTimeStamp: observedTimeStamp,
  //     resource: resource,
  //     severityNumber: severityNumber,
  //     severityText: severityText,
  //     spanId: spanId,
  //     traceFlags: traceFlags,
  //     traceId: traceId,
  //   );
  // }
}
