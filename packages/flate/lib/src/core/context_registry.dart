part of '../core.dart';

mixin _ConfigurationRegistry {
  final Map<Type, FlateContext> _contextTypes = {};

  /// Returns all registered parts
  ///
  /// Returned map may contains multiple entries for single instance of [FlateFragment].
  Map<Type, FlateContext> get _context {
    return _contextTypes;
  }

  /// Returns instance of [FlateContext] by [Type] provided in generic parameter [C]
  ///
  /// If instance of [FlateContext] is not registered by type [C] then [StateError] throws.
  C useContext<C>() {
    final types = _contextTypes;
    if (!types.containsKey(C)) {
      throw StateError('Context of type $C not registered for $runtimeType');
    }

    return types[C] as C;
  }

  /// Register [context] instance with one or n types
  void _registerContext(FlateContext context) {
    final registration = Registration(instance: context);
    context.register(registration);
    for (final type in registration.types) {
      if (_contextTypes.containsKey(type)) {
        throw StateError(
          'Context ${context.runtimeType} already registered with type $type',
        );
      }
      _contextTypes[type] = context;
    }
  }

  /// Perform activation of registered [FlateContext]
  ///
  /// The [FlateContext.activate] will be called during invocation of this method.
  Future<void> _activateContext() async {
    for (var context in _contextTypes.values.toSet()) {
      try {
        await context.activate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          InitializationException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }

  /// Perform deactivation of registered [FlateContext]
  ///
  /// The [FlateContext.deactivate] will be called during invocation of this method.
  Future<void> _deactivateContext() async {
    for (var context in _contextTypes.values.toSet()) {
      try {
        await context.deactivate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          DisposeException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }
}
