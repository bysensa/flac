part of '../log.dart';

class LogEmitter {
  final String _name;
  final EventSink<RawSignal> _signalsSink;

  LogEmitter._({
    required String name,
    required EventSink<RawSignal> signalsSink,
  })  : _name = name,
        _signalsSink = signalsSink;

  void _emitLog(RawLogRecord record) {
    _signalsSink.add(record);
  }

  void _emitError(Object error, StackTrace trace) {
    _signalsSink.addError(error, trace);
  }
}
