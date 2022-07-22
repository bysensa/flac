import 'package:flutter/foundation.dart';

import '../core.dart';

@visibleForTesting
class TestElementProvider with FlateElementProvider {
  final Map<Type, FlateElementMixin> _elements = {};

  void registerAs<T>(FlateElementMixin element) {
    assert(
      element is T,
      'Provided instance of type ${element.runtimeType} does not conform to type $T',
    );
    assert(
      !_elements.containsKey(T),
      'Instance for type $T already registered',
    );
    _elements[T] = element;
  }

  void register(FlateElementMixin element) {
    final registration = Registration(instance: element);
    element.register(registration);
    for (final type in registration.types) {
      assert(
        !_elements.containsKey(type),
        'Instance for type $type already registered',
      );
      _elements[type] = element;
    }
  }

  bool isRegistered(Type type) => _elements.containsKey(type);

  @override
  T call<T>() {
    assert(_elements.containsKey(T), 'Element of type $T is not registered');
    final targetElement = _elements[T];
    assert(
      targetElement is T,
      'Registered instance of type ${targetElement.runtimeType} does not conforms to type $T',
    );

    return targetElement as T;
  }
}
