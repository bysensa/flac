part of '../core.dart';

abstract class _ElementsRegistry with FlateElementProvider {
  final Map<Type, FlateElementMixin> _elements = {};

  /// Returns instance of [FlateFragment] by [Type] provided in generic parameter [F]
  ///
  /// If instance of [FlateFragment] is not registered by type [F] then [StateError] throws.
  F useFragment<F extends FlateFragmentMixin>() {
    assert(
      isRegistered<F>(),
      'Fragment of type $F not registered in $runtimeType',
    );
    final targetElement = _elements[F];
    assert(
      targetElement is FlateFragmentMixin,
      'There are no registered FlateFragment conformed to type $F. Only instance of type ${targetElement.runtimeType} conforms to $F',
    );
    return _elements[F] as F;
  }

  @override
  T call<T>() {
    assert(
      isRegistered<T>(),
      'Element of type $T not registered in $runtimeType',
    );
    final targetElement = _elements[T];
    assert(
      targetElement is! FlateFragmentMixin,
      'Instance of FlateFragment cant be returned by this method. '
      'Use method useFragment to retrieve registered instance of FlateFragment conformed to type $T. '
      'If you try to get instance of FlateFragment during preparation of FlateElement when this is impossible '
      'because according to current architecture you can retrieve FlateFragment after preparation of all elements.',
    );
    return _elements[T] as T;
  }

  /// Return true if instance of type [T] registered in store else result is false
  bool isRegistered<T>() => _elements.containsKey(T);

  /// Register [element] instance with one or more types
  void _registerElement(
    FlateElementMixin element, {
    void Function(FlateElementMixin)? afterRegistration,
  }) {
    final registration = Registration(instance: element);
    element.register(registration);
    for (final type in registration.types) {
      assert(
        !_elements.containsKey(type),
        '${element.runtimeType} already registered with type $type',
      );
      _elements[type] = element;
    }
    afterRegistration?.call(element);
  }

  /// Perform activation of elements provided in [elementsCollection]
  ///
  /// The [FlateElementMixin.prepare] will be called during invocation of this method.
  Future<void> _activateElement(FlateElementMixin element) async {
    try {
      await element.prepare(this);
    } catch (err, trace) {
      Zone.current.handleUncaughtError(
        ActivationException(exception: err, trace: trace),
        trace,
      );
    }
  }

  /// Perform deactivation of elements in provided [elementsCollection]
  ///
  /// The [FlateElementMixin.release] will be called during invocation of this method.
  Future<void> _deactivateElement(FlateElementMixin element) async {
    try {
      await element.release();
    } catch (err, trace) {
      Zone.current.handleUncaughtError(
        DeactivationException(exception: err, trace: trace),
        trace,
      );
    }
  }
}
