part of '../log.dart';

class LogEmitter {
  final String name;

  const LogEmitter._({
    required this.name,
  });

  Logger logger({required LogLevel level}) {
    return Logger._(level: level, instrumentationScope: name);
  }
}
