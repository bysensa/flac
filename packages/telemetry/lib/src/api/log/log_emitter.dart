part of '../log.dart';

class LogEmitter {
  final String _name;
  final Sink<RawSignal> _signalsSink;

  LogEmitter._({
    required String name,
    required Sink<RawSignal> signalsSink,
  })  : _name = name,
        _signalsSink = signalsSink;

  Logger logger({required LogLevel level}) {
    return Logger._(
      level: level,
      instrumentationScope: _name,
      logEmitter: this,
    );
  }

  dynamic dynamicLogger({required LogLevel level}) {
    return logger(level: level);
  }

  void _emitLog(RawLogRecord record) {
    _signalsSink.add(record);
  }
}
