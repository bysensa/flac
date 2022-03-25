part of '../core.dart';

mixin _PartsRegistry {
  final Map<Type, FlatePart> _registeredParts = {};

  /// Returns all registered parts
  ///
  /// Returned map may contains multiple entries for single instance of [FlatePart].
  Map<Type, FlatePart> get _parts {
    return _registeredParts;
  }

  /// Returns instance of [FlatePart] by [Type] provided in generic parameter [P]
  ///
  /// If instance of [FlatePart] is not registered by type [P] then [StateError] throws.
  P _usePart<P>() {
    final parts = _parts;
    if (!parts.containsKey(P)) {
      throw StateError('Part of type $P not registered in $runtimeType');
    }

    return parts[P] as P;
  }

  /// Register provided [part]
  void _registerPart(FlatePart part) {
    final registration = Registration(instance: part);
    part.register(registration);
    for (final type in registration.types) {
      if (_registeredParts.containsKey(type)) {
        throw StateError(
          'Part ${part.runtimeType} already registered with type $type',
        );
      }
      _registeredParts[type] = part;
    }
  }

  Future<void> _activateParts() async {
    for (var part in _parts.values.toSet()) {
      try {
        await part.activate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          InitializationException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }

  Future<void> _deactivateParts() async {
    for (var part in _parts.values.toSet()) {
      try {
        await part.deactivate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          DisposeException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }
}
