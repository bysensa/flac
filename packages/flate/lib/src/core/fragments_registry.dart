part of '../core.dart';

mixin _FragmentsRegistry {
  final Map<Type, FlateFragment> _storeFragments = {};

  /// Returns all registered parts
  ///
  /// Returned map may contains multiple entries for single instance of [FlateFragment].
  Map<Type, FlateFragment> get _fragments {
    return _storeFragments;
  }

  /// Returns instance of [FlateFragment] by [Type] provided in generic parameter [F]
  ///
  /// If instance of [FlateFragment] is not registered by type [F] then [StateError] throws.
  F useFragment<F>() {
    final fragments = _fragments;
    if (!fragments.containsKey(F)) {
      throw StateError('Fragment of type $F not registered for $runtimeType');
    }

    return fragments[F] as F;
  }

  /// Register [fragment] instance
  void _registerFragment(FlateFragment fragment) {
    final registration = Registration(instance: fragment);
    fragment.register(registration);
    for (final type in registration.types) {
      if (_storeFragments.containsKey(type)) {
        throw StateError(
          'Fragment ${fragment.runtimeType} already registered with type $type',
        );
      }
      _storeFragments[type] = fragment;
    }
  }

  Future<void> _activateFragments() async {
    for (var fragment in _storeFragments.values.toSet()) {
      try {
        await fragment.activate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          InitializationException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }

  Future<void> _deactivateFragments() async {
    for (var fragment in _storeFragments.values.toSet()) {
      try {
        await fragment.deactivate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          DisposeException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }
}
