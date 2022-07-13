import 'dart:async';

import 'context/execution_unit.dart';

part 'context/impl.dart';
part 'context/key.dart';
part 'context/token.dart';

final _contextBinding = Expando<Context>();
final _contextKey = Context.createKey(name: 'context');

/// A Context is a propagation mechanism which carries execution-scoped values across API
/// boundaries and between logically associated execution units.
/// Cross-cutting concerns access their data in-process using the same shared Context object.
///
/// details here: https://opentelemetry.io/docs/reference/specification/context/
abstract class Context {
  static final _root = Context._();

  factory Context._() {
    final context = _ContextImpl();
    final currentExecutionUnit = ExecutionUnit.current();
    _contextBinding[currentExecutionUnit] = context;
    return context;
  }

  /// Returns an opaque object representing the newly created key.
  ///
  /// details here: https://opentelemetry.io/docs/reference/specification/context/#create-a-key
  static ContextKey createKey({String? name}) => ContextKey._(name: name);

  /// Returns the value in the provided [Context] for the specified [ContextKey].
  static dynamic value(Context context, ContextKey key) {
    return context._value(key);
  }

  /// Return a new [Context] containing all values from provided [context] with
  /// the new [value] associated with provided [ContextKey].
  static Context setValue(Context context, ContextKey key, Object? value) {
    return context._setValue(key, value);
  }

  /// Return [Context] instance attached to current [ExecutionUnit]
  ///
  /// The new [Context] instance will be created and binded to current [ExecutionUnit]
  /// if this has not been done before.
  /// details here: https://opentelemetry.io/docs/reference/specification/context/#get-current-context
  static Context current() {
    final currentContext =
        Zone.current[_contextKey] ?? _contextBinding[ExecutionUnit.current()];
    return currentContext ?? _root;
  }

  /// Associates a Context with the caller’s current execution unit.
  ///
  /// details here: https://opentelemetry.io/docs/reference/specification/context/#attach-context
  static ContextToken attach(Context context) {
    final currentExecutionUnit = ExecutionUnit.current();
    final currentContext = current();
    final token = ContextToken._(
      previousContext: currentContext,
      executionUnit: currentExecutionUnit,
    );
    _contextBinding[currentExecutionUnit] = context;
    return token;
  }

  /// Resets the Context associated with the caller’s current execution unit to
  /// the value it had before attaching a specified Context.
  ///
  /// details here: https://opentelemetry.io/docs/reference/specification/context/#detach-context
  static void detach(ContextToken token) {
    final previousExecutionUnit = token._executionUnit;
    final previousContext = token._previousContext;
    _contextBinding[previousExecutionUnit] = previousContext;
  }

  static R wrap<R>(Context context, R Function() callback) {
    return context._wrap(callback);
  }

  /// Returns the value in the Context for the specified [ContextKey].
  Object? _value(ContextKey key);

  /// Return a new [Context] containing the new value associated with provided [ContextKey].
  Context _setValue(ContextKey key, Object? value);

  ///
  R _wrap<R>(R Function() callback);
}
