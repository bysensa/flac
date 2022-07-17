import 'package:telemetry/api.dart';
import 'package:test/test.dart';
import 'package:stack_trace/stack_trace.dart';

void main() {
  test('symbols should be equal', () {
    expect(#call, Symbol('call'));
  });

  test('description', () {
    trace('hello world', one: 1, two: 2, three: 3);
    debug('hello world', one: 1, two: 2, three: 3, someInstanceName: 'Hello');
    info('hello world', one: 1, two: 2);
    warn('hello world', one: 1, two: 2);
    error('hello world', one: 1, two: 2);
    fatal('hello world', one: 1, two: 2);
    print(Chain.forTrace(StackTrace.current).terse.toString());
  });
}
