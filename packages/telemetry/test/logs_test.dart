import 'package:telemetry/src/api/attributes.dart';
import 'package:telemetry/src/api/logs/level.dart';
import 'package:test/test.dart';

final dynamic trace = Log.trace();
final dynamic debug = Log.debug();
final dynamic info = Log.info();
final dynamic warn = Log.warn();
final dynamic error = Log.error();
final dynamic fatal = Log.fatal();

class Log {
  final LogLevel level;

  Log.trace() : level = LogLevel.trace;
  Log.debug() : level = LogLevel.debug;
  Log.info() : level = LogLevel.info;
  Log.warn() : level = LogLevel.warn;
  Log.error() : level = LogLevel.error;
  Log.fatal() : level = LogLevel.fatal;

  void call(LogLevel level, dynamic body, Attributes attributes) {}

  @override
  void noSuchMethod(Invocation invocation) {
    print(level);
    print(invocation.isMethod);
    print(invocation.memberName);
    print(invocation.positionalArguments);
    print(invocation.namedArguments);
  }
}

void main() {
  test('description', () {
    trace('hello world',
        one: 1,
        two: 2,
        three: 3,
        four: 4,
        five: 5,
        six: 6,
        seven: 7,
        eight: 8,
        nine: 9);
    debug('hello world', one: 1, two: 2, three: 3);
    info('hello world', one: 1, two: 2);
    warn('hello world', one: 1, two: 2);
    error('hello world', one: 1, two: 2);
    fatal('hello world', one: 1, two: 2);

    trace('hello world', 1.attr('one'), 2.attr('two'));
    debug('hello world', one: 1, two: 2);
    info('hello world', one: 1, two: 2);
    warn('hello world', one: 1, two: 2);
    error('hello world', one: 1, two: 2);
    fatal('hello world', one: 1, two: 2);
  });
}
