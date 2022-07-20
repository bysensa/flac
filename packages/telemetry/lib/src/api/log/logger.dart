part of '../log.dart';

class Logger {
  final LogEmitter _logEmitter;
  final String _instrumentationScope;
  final LogLevel _level;

  const Logger._(
      {required String instrumentationScope,
      required LogLevel level,
      required LogEmitter logEmitter,
      s})
      : _instrumentationScope = instrumentationScope,
        _level = level,
        _logEmitter = logEmitter;

  void log(List<dynamic> body, {Map<String, dynamic> arguments = const {}}) {
    final callFrame = Trace.current(1).frames.first;
    _emitLog(callFrame, body, arguments);
  }

  @override
  void noSuchMethod(Invocation invocation) {
    if (!invocation.isMethod) {
      assert(
        invocation.isMethod,
        'Logger should be called using call method or like a function',
      );
      return;
    }
    final callFrame = Trace.current(1).frames.first;
    final positionalArguments = invocation.positionalArguments;
    final namedArguments = invocation.namedArguments;
    _emitLog(callFrame, positionalArguments, namedArguments);
  }

  void _emitLog(
    Frame callFrame,
    List<dynamic> body,
    Map<dynamic, dynamic> args,
  ) {
    if (body.isEmpty) {
      assert(
        body.isEmpty,
        'Logger should be called with at least one positional arg',
      );
      return;
    }
    final context = Context.current();
    final timestamp = DateTime.now();
    final attributes = args.flatten();
    final record = RawLogRecord(
      callFrame: callFrame,
      timestamp: timestamp,
      level: _level,
      context: context,
      instrumentationScope: _instrumentationScope,
      body: body,
      attributes: attributes,
    );
    _logEmitter._emitLog(record);
  }
}
