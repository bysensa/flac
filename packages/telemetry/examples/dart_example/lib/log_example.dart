import 'package:mobx/mobx.dart';
import 'package:telemetry/telemetry.dart';

Future<void> main() async {
  var nullable;
  final obs = Observable(0);
  try {
    trace('hello world', one: 1, two: 2, three: 3);
    debug('hello world', one: 1, two: 2, three: 3, someInstanceName: 'Hello');
    info('hello world', one: 1, two: 2);
    warn(obs, one: 1, two: 2);
    fatal(
      SomeMessage(msg: SomeInternalMessage(value: 'hello')),
      one: 1,
      two: 2,
    );
    final value = nullable!;
  } catch (err, trace) {
    error(err, trace, one: 1, two: 2);
    fatal(err, trace, one: 1, two: 2);
  }

  await Future.delayed(Duration(seconds: 10));
}

class SomeMessage {
  final SomeInternalMessage msg;

  const SomeMessage({
    required this.msg,
  });
}

class SomeInternalMessage {
  final String value;

  const SomeInternalMessage({
    required this.value,
  });
}
