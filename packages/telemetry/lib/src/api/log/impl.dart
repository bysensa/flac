part of '../log.dart';

class _Log {
  final _symbolToStringRegexp = RegExp(r'.*\((.*)\)');
  final LogLevel level;

  _Log.trace() : level = LogLevel.trace;
  _Log.debug() : level = LogLevel.debug;
  _Log.info() : level = LogLevel.info;
  _Log.warn() : level = LogLevel.warn;
  _Log.error() : level = LogLevel.error;
  _Log.fatal() : level = LogLevel.fatal;

  void call() {}

  @override
  void noSuchMethod(Invocation invocation) {
    if (!invocation.isMethod) {
      return;
    }
    final positionalArguments = invocation.positionalArguments;
    if (positionalArguments.isEmpty || positionalArguments.length > 1) {
      return;
    }
    final timestamp = DateTime.now();
    final observedTimestamp = timestamp;
    final attributes = invocation.namedArguments.map(
      (key, value) => MapEntry(AttributeName.fromSymbol(key).name, value),
    );
    final body = invocation.positionalArguments.first;
    final callFrame = Trace.current(1).frames.first;
    Logger.emit(
      timestamp: timestamp,
      observedTimestamp: observedTimestamp,
      level: level,
      frame: callFrame,
      body: body,
      attributes: attributes,
    );
  }
}
