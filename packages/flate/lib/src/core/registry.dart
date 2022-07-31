part of '../core.dart';

class FlateRegistry with FlateElementProvider {
  final Map<Type, FlateElementMixin> _elements = {};

  /// Return true if instance of type [T] registered in store else result is false
  bool isRegistered<T>() => _elements.containsKey(T);

  @override
  T call<T>() => useElement<T>();

  T useElement<T>() {
    assert(
      isRegistered<T>(),
      'Element of type $T not registered in $runtimeType',
    );
    final targetElement = _elements[T];
    assert(
      targetElement is T,
      'Instance of type ${targetElement.runtimeType} does not conform to type $T. '
      'This problems occur on framework level. Please contact with developer to fix this problem.',
    );

    return _elements[T] as T;
  }

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

  Future<void> prepareElements() async {
    final elements = LinkedHashSet.from(_elements.values);
    for (final element in elements) {
      try {
        await element.prepare(this);
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          ActivationException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }

  Future<void> releaseElements() async {
    final elements = LinkedHashSet.from(_elements.values.toList().reversed);
    for (final element in elements) {
      try {
        await element.release();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          DeactivationException(exception: err, trace: trace),
          trace,
        );
      }
    }
    _elements.clear();
  }

  void applyRegistration(Registration registration) {
    final element = registration.instance;
    for (final type in registration.types) {
      assert(
        !_elements.containsKey(type),
        '${element.runtimeType} already registered with type $type',
      );
      _elements[type] = element;
    }
  }

  void mergeRegistry(FlateRegistry registry) {
    final foreignElements = registry._elements;
    for (final foreignElement in foreignElements.entries) {
      assert(
        !_elements.containsKey(foreignElement.key),
        'Registry merge failed. Type ${foreignElement.key} already registered '
        'for element ${_elements[foreignElement.key].runtimeType}',
      );
      _elements[foreignElement.key] = foreignElement.value;
    }
  }
}
