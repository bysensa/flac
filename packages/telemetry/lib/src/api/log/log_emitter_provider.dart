part of '../log.dart';

class LogEmitterProvider {
  static LogEmitter logEmitter({required String name}) {
    return LogEmitter._(name: name);
  }
}
