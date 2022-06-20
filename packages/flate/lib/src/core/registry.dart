part of '../core.dart';

mixin _ElementsRegistry {
  final Map<ElementKey, FlateElementMixin> _elements = {};

  /// Returns instance of [FlateFragment] by [Type] provided in generic parameter [F]
  ///
  /// If instance of [FlateFragment] is not registered by type [F] then [StateError] throws.
  F useFragment<F>() {
    final lookupKey = ElementKey.fragment(F);
    if (!_elements.containsKey(lookupKey)) {
      throw StateError('Fragment of type $F not registered for $runtimeType');
    }

    return _elements[lookupKey] as F;
  }

  /// Returns instance of [FlatePart] by [Type] provided in generic parameter [P]
  ///
  /// If instance of [FlatePart] is not registered by type [P] then [StateError] throws.
  P _usePart<P>() {
    final lookupKey = ElementKey.part(P);
    if (!_elements.containsKey(lookupKey)) {
      throw StateError('Part of type $P not registered in $runtimeType');
    }

    return _elements[lookupKey] as P;
  }

  /// Returns instance of [FlateService] by [Type] provided in generic parameter [S]
  ///
  /// If instance of [FlateService] is not registered by type [S] then [StateError] throws.
  S _useService<S>() {
    final lookupKey = ElementKey.service(S);
    if (!_elements.containsKey(lookupKey)) {
      throw StateError('Service of type $S not registered in $runtimeType');
    }

    return _elements[lookupKey] as S;
  }

  /// Returns instance of [FlateContext] by [Type] provided in generic parameter [C]
  ///
  /// If instance of [FlateContext] is not registered by type [C] then [StateError] throws.
  C _useContext<C>() {
    final lookupKey = ElementKey.context(C);
    if (!_elements.containsKey(lookupKey)) {
      throw StateError('Context of type $C not registered for $runtimeType');
    }

    return _elements[lookupKey] as C;
  }

  /// Register [element] instance with one or more types
  void _registerElement(
    FlateElementMixin element,
    Type baseType, {
    void Function(FlateElementMixin)? afterRegistration,
  }) {
    final registration = Registration(instance: element);
    element.register(registration);
    for (final type in registration.types) {
      final lookupKey = ElementKey._(baseType, type);
      if (_elements.containsKey(lookupKey)) {
        throw StateError(
          '${element.runtimeType} already registered with type $type',
        );
      }
      _elements[lookupKey] = element;
    }
    afterRegistration?.call(element);
  }

  /// Perform activation of elements provided in [elementsCollection]
  ///
  /// The [FlateElementMixin.prepare] will be called during invocation of this method.
  Future<void> _activateElement(FlateElementMixin element) async {
    try {
      await element.prepare();
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

class ElementKey implements Comparable<ElementKey> {
  static const Map<Type, int> _baseTypePriority = {
    FlateContext: 0,
    FlateService: 1,
    FlatePart: 2,
    FlateFragment: 3
  };

  final Type _baseType;
  final Type _concreteType;

  ElementKey._(this._baseType, this._concreteType);

  ElementKey.context(this._concreteType) : _baseType = FlateContext;

  ElementKey.service(this._concreteType) : _baseType = FlateService;

  ElementKey.part(this._concreteType) : _baseType = FlatePart;

  ElementKey.fragment(this._concreteType) : _baseType = FlateFragment;

  @override
  bool operator ==(Object other) =>
      other is ElementKey &&
      runtimeType == other.runtimeType &&
      _baseType == other._baseType &&
      _concreteType == other._concreteType;

  @override
  int get hashCode => _baseType.hashCode ^ _concreteType.hashCode;

  int get priorityByBaseType => _baseTypePriority[_baseType] ?? 0;

  @override
  int compareTo(ElementKey other) {
    if (other == this) {
      return 0;
    }
    return priorityByBaseType - other.priorityByBaseType;
  }
}
