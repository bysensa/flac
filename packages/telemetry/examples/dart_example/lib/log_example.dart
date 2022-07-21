import 'package:mobx/mobx.dart';
import 'package:telemetry/telemetry.dart';

import 'loggers.dart';

void main() {
  var nullable;
  try {
    trace('hello world', one: 1, two: 2, three: 3);
    debug('hello world', one: 1, two: 2, three: 3, someInstanceName: 'Hello');
    info('hello world', one: 1, two: 2);
    warn(1, one: 1, two: 2);
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

  print('done');
  Telemetry.closeInstance();
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
