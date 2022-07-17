import 'package:telemetry/telemetry.dart';

void main() {
  final someValue = 0;
  final anotherValue = 99;
  // create key for value
  final someKey = Context.createKey();
  // get context from current execution unit at this time it is isolate
  final currentContext = Context.current();
  // add value to context
  final modifiedContext = Context.setValue(currentContext, someKey, 0);
  // attach modified context to current execution unit (Isolate)
  final attachToken = Context.attach(modifiedContext);
  // get modified context from current execution unit(Isolate)
  final attachedContext = Context.current();
  final valueFromContext = Context.value(attachedContext, someKey);
  assert(someValue == valueFromContext);

  /// rollback to previous context
  Context.detach(attachToken);
  final contextAfterDetach = Context.current();
  final contextValueAfterDetach = Context.value(contextAfterDetach, someKey);
  assert(contextValueAfterDetach == null);

  final nextModifiedContext = Context.setValue(
    contextAfterDetach,
    someKey,
    anotherValue,
  );

  /// execute code with modified context using Zone API
  Context.wrap(nextModifiedContext, () {
    final valueFromContext = Context.value(Context.current(), someKey);
    assert(valueFromContext == anotherValue);
  });

  /// Ensure after run code in wrap the current context is equal to context before execution in wrap
  final contextValueAfterWrap = Context.value(Context.current(), someKey);
  assert(contextValueAfterWrap == null);
}
