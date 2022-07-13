part of '../log.dart';

class LogRecord {
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
  final Object body;

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
  final List<String>? instrumentationScope;

  /// Additional information about the specific event occurrence.
  ///
  /// Unlike the Resource field, which is fixed for a particular source,
  /// Attributes can vary for each occurrence of the event coming from the same source.
  /// Can contain information about the request context (other than TraceId/SpanId).
  /// SHOULD follow OpenTelemetry semantic conventions for Log Attributes or
  /// semantic conventions for Span Attributes. This field is optional.
  final Map<String, Object>? attributes;

  const LogRecord({
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
}

class InvalidLogRecord extends LogRecord {
  InvalidLogRecord() : super(body: '');
}
