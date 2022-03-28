part of '../core.dart';

mixin _ContextResolver on FlateElement {
  /// Provide instance of [FlateContext] by type [C]
  ///
  /// If instance for type [C] is not registered then [StateError] will be thrown.
  /// If element is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  C useContext<C>() {
    if (isMounted) {
      return _store!.useContext<C>();
    }
    throw StateError('Element of type $runtimeType is not mounted');
  }
}

mixin _PartResolver on FlateElement {
  /// Provide instance of [FlatePart] by type [P]
  ///
  /// If instance for type [P] is not registered then [StateError] will be thrown.
  /// If element is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  P usePart<P>() {
    if (isMounted) {
      return _store!._usePart<P>();
    }
    throw StateError('Element is not mounted');
  }
}

mixin _ServiceResolver on FlateElement {
  /// Provide instance of [FlateService] by type [S]
  ///
  /// If instance for type [S] is not registered then [StateError] will be thrown.
  /// If element is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  S useService<S>() {
    if (isMounted) {
      return _store!._useService<S>();
    }
    throw StateError('Element of type $runtimeType is not mounted');
  }
}
