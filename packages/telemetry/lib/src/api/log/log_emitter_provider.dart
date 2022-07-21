part of '../log.dart';

mixin LogEmitterProvider {
  EventSink<RawSignal> get sink;

  LogEmitter _logEmitter({required String name}) {
    return LogEmitter._(
      name: name,
      signalsSink: sink,
    );
  }

  Logger logger({required String withName, required LogLevel withLevel}) {
    return Logger.create(
      withName: withName,
      withLevel: withLevel,
      emitterProvider: this,
    );
  }
}
