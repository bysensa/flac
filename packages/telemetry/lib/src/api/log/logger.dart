part of '../log.dart';

class Logger {
  static void emit({
    required body,
    required Map<String, dynamic> attributes,
    required DateTime timestamp,
    required DateTime observedTimestamp,
    required LogLevel level,
    required Frame frame,
  }) {
    final composedAttributes = Map.from(attributes)
      ..addAll({
        'call.isCore': frame.isCore,
        'call.package': frame.package,
        'call.location': frame.location,
        'call.library': frame.library,
        'call.member': frame.member,
        'call.line': frame.line,
        'call.column': frame.column,
      });
    print(
        '$timestamp [${level.name.toUpperCase()}]: $body \n$composedAttributes');
  }
}
