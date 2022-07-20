part of '../log.dart';

class RawLogRecord extends RawSignal {
  final DateTime timestamp;
  final Frame callFrame;
  final Context context;
  final LogLevel level;
  final String instrumentationScope;
  final List<dynamic> body;
  final Map<dynamic, dynamic> attributes;

  RawLogRecord({
    required this.timestamp,
    required this.callFrame,
    required this.context,
    required this.level,
    required this.instrumentationScope,
    required this.body,
    required this.attributes,
  });
}

class LogRecord {
  static Map<String, dynamic> _frameToAttributes(Frame frame) {
    return {
      'invocation.isCore': frame.isCore,
      'invocation.library': frame.library,
      'invocation.package': frame.package,
      'invocation.location': frame.location,
      'invocation.member': frame.member,
      'invocation.line': frame.line,
      'invocation.column': frame.column,
    };
  }

  static String _processBody(
    List<dynamic> body,
    Map<String, dynamic> attributes,
  ) {
    final bodyParts = [];
    for (final part in body) {
      if (part is Exception || part is Error) {
        attributes['exception.type'] = part.runtimeType.toString();
        attributes['exception.message'] = part.toString();
      } else if (part is StackTrace) {
        attributes['exception.stacktrace'] =
            Chain.forTrace(part).terse.toString();
      } else {
        bodyParts.add(part);
      }
    }
    return (StringBuffer()..writeAll(bodyParts, ' ')).toString();
  }

  const LogRecord._({
    required this.body,
    this.timestamp,
    this.observedTimeStamp,
    this.traceId,
    this.spanId,
    this.traceFlags,
    this.severityText,
    this.severityNumber,
    this.resource,
    this.instrumentationScope,
    this.attributes,
  });

  factory LogRecord.create({
    required Frame callFrame,
    required DateTime timestamp,
    required LogLevel level,
    required Context context,
    required String instrumentationScope,
    required List<dynamic> body,
    required Map<String, dynamic> resource,
    required Map<dynamic, dynamic> attributes,
  }) {
    final timestampNanoseconds = timestamp.microsecondsSinceEpoch * 1000;
    final observedTimestampNanoseconds = timestampNanoseconds;
    final severityText = level.severityText;
    final severityNumber = level.severityNumber;
    final traceId = null; //TODO(bysensa): set real values
    final spanId = null; //TODO(bysensa): set real values
    final traceFlags = null; //TODO(bysensa): set real values

    final attributesMap = attributes.flatten();
    attributesMap.addAll(_frameToAttributes(callFrame));

    final bodyContent = _processBody(body, attributesMap);

    return LogRecord._(
      body: bodyContent,
      attributes: attributesMap,
      instrumentationScope: instrumentationScope,
      observedTimeStamp: observedTimestampNanoseconds,
      resource: resource,
      severityNumber: severityNumber,
      severityText: severityText,
      spanId: spanId,
      timestamp: timestampNanoseconds,
      traceFlags: traceFlags,
      traceId: traceId,
    );
  }

  /// Time when the event occurred measured by the origin clock, i.e.
  /// the time at the source.
  ///
  /// This field is optional, it may be missing if the source timestamp is unknown.
  final int? timestamp;

  /// Time when the event was observed by the collection system.
  ///
  /// For events that originate in OpenTelemetry (e.g. using OpenTelemetry Logging SDK) this timestamp
  /// is typically set at the generation time and is equal to Timestamp.
  /// For events originating externally and collected by OpenTelemetry (e.g. using Collector)
  /// this is the time when OpenTelemetry’s code observed the event measured by the clock of the OpenTelemetry code.
  final int? observedTimeStamp;

  /// Request trace id as defined in W3C Trace Context.
  ///
  /// Can be set for logs that are part of request processing and have
  /// an assigned trace id. This field is optional.
  final TraceId? traceId;

  /// Span id.
  ///
  /// Can be set for logs that are part of a particular processing span.
  /// If SpanId is present TraceId SHOULD be also present. This field is optional.
  final SpanId? spanId;

  /// Trace flag as defined in W3C Trace Context specification.
  ///
  /// At the time of writing the specification defines one flag - the SAMPLED flag. This field is optional.
  final int? traceFlags;

  /// This is the original string representation of the severity as it is known at the source.
  ///
  /// If this field is missing and SeverityNumber is present then the short name
  /// that corresponds to the SeverityNumber may be used as a substitution. This field is optional.
  final String? severityText;

  /// Numerical value of the severity, normalized to values described in this document.
  ///
  /// This field is optional.
  final int? severityNumber;

  /// A value containing the body of the log record (see the description of any type above).
  ///
  /// Can be for example a human-readable string message (including multi-line)
  /// describing the event in a free form or it can be a structured data composed
  /// of arrays and maps of other values. First-party Applications SHOULD use a string message.
  /// However, a structured body may be necessary to preserve the semantics of some existing log formats.
  /// Can vary for each occurrence of the event coming from the same source. This field is optional.
  final String body;

  /// Describes the source of the log, aka resource.
  ///
  /// Multiple occurrences of events coming from the same event source can happen
  /// across time and they all have the same value of Resource. Can contain for example
  /// information about the application that emits the record or
  /// about the infrastructure where the application runs. Data formats that represent this data model
  /// may be designed in a manner that allows the Resource field to be recorded only once per batch
  /// of log records that come from the same source. SHOULD follow OpenTelemetry semantic conventions for Resources.
  /// This field is optional.
  final Map<String, dynamic>? resource;

  /// The instrumentation scope.
  ///
  /// Multiple occurrences of events coming from the same scope can happen across time
  /// and they all have the same value of InstrumentationScope. For log sources which define
  /// a logger name (e.g. Java Logger Name) the Logger Name SHOULD be recorded as the Instrumentation Scope name.
  final String? instrumentationScope;

  /// Additional information about the specific event occurrence.
  ///
  /// Unlike the Resource field, which is fixed for a particular source,
  /// Attributes can vary for each occurrence of the event coming from the same source.
  /// Can contain information about the request context (other than TraceId/SpanId).
  /// SHOULD follow OpenTelemetry semantic conventions for Log Attributes or
  /// semantic conventions for Span Attributes. This field is optional.
  final Map<String, dynamic>? attributes;
}
