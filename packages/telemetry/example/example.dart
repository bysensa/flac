import 'dart:isolate';

import 'package:telemetry/telemetry.dart';

void main() {
  final someValue = 0;
  final someKey = Context.createKey();
  final currentContext = Context.current();
  final modifiedContext = Context.setValue(currentContext, someKey, 0);
  final attachToken = Context.attach(modifiedContext);
  final attachedContext = Context.current();
  final valueFromContext = Context.value(attachedContext, someKey);
  assert(someValue == valueFromContext);
  Context.detach(attachToken);
  final contextAfterDetach = Context.current();
  final contextValueAfterDetach = Context.value(contextAfterDetach, someKey);
  assert(someValue != contextValueAfterDetach);
}
