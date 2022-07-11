import 'dart:isolate';

typedef ExecutionUnit = Isolate;

ExecutionUnit currentExecutionUnit() => Isolate.current;
