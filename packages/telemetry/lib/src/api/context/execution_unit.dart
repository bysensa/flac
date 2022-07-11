import '_execution_unit_io.dart'
    if (dart.library.html) '_execution_unit_web.dart' as eu;

typedef CurrentExecutionUnit = eu.ExecutionUnit;

extension ExecutionUnit on dynamic {
  static CurrentExecutionUnit current() => eu.currentExecutionUnit();
}
