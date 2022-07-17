part of '../log.dart';

class Logger {
  final LogEmitter _logEmitter;
  final String _instrumentationScope;
  final LogLevel _level;

  const Logger._({
    required String instrumentationScope,
    required LogLevel level,
    required LogEmitter logEmitter,
  })  : _instrumentationScope = instrumentationScope,
        _level = level;

  void call(List<dynamic> body, Map<String, dynamic> arguments) {
    final callFrame = Trace.current(1).frames.first;
    _createLog(callFrame, body, arguments);
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
    _createLog(callFrame, positionalArguments, namedArguments);
  }

  void _createLog(
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
    final timestamp = DateTime.now();
    final attributes = args.map(
      (key, value) => MapEntry(AttributeName.fromDynamic(key).name, value),
    );
  }
}
