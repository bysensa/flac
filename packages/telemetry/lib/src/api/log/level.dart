part of '../log.dart';

enum LogLevel {
  trace,
  trace2,
  trace3,
  trace4,
  debug,
  debug2,
  debug3,
  debug4,
  info,
  info2,
  info3,
  info4,
  warn,
  warn2,
  warn3,
  warn4,
  error,
  error2,
  error3,
  error4,
  fatal,
  fatal2,
  fatal3,
  fatal4,
}

extension LogLevelUtils on LogLevel {
  String get severityText => name.toUpperCase();
  int get severityNumber => index + 1;
}
