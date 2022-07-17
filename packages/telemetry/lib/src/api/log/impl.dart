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

    print('MainIsolate hashCode: ${Isolate.current.hashCode}');
    final resArgs = Isolate.spawn(
      _logRecordFromArgs,
      positionalArguments,
    );
    final resNamedArgs = Isolate.spawn(
      _logRecordFromNamedArgs,
      invocation.namedArguments,
    );

    // if (positionalArguments.isEmpty) {
    //   return;
    // }
    // final timestamp = DateTime.now();
    // final observedTimestamp = timestamp;
    // final attributes = invocation.namedArguments.map(
    //   (key, value) => MapEntry(AttributeName.fromSymbol(key).name, value),
    // );
    // final body = invocation.positionalArguments;
    // final callFrame = Trace.current(1).frames.first;
    // Logger.emit(
    //   timestamp: timestamp,
    //   observedTimestamp: observedTimestamp,
    //   level: level,
    //   frame: callFrame,
    //   body: body,
    //   attributes: attributes,
    // );
  }
}

void _logRecordFromArgs(List<dynamic> args) {
  print(args);
  print('Isolate hashCode: ${Isolate.current.hashCode}');
  Isolate.exit();
}

void _logRecordFromNamedArgs(Map<Symbol, dynamic> args) {
  print(args);
  print('Isolate hashCode: ${Isolate.current.hashCode}');
  Isolate.exit();
}
