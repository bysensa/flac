part of '../core.dart';

/// The class is a fragment of the application state.
///
/// In cases when some part of the application state is not shared, then it should be placed in a fragment.
/// The application can consist of one or more fragments. Each fragment in its implementation can use
/// all registered parts and services, but must not use other fragments. Parts and services can be obtained
/// in a fragment by calling methods [usePart] and [useService].
abstract class FlateFragment with FlateElement {
  /// Return instance of [FlatePart] registered with type [P]
  ///
  /// If instance for type [P] is not registered in [FlateStore] then [StateError] will be thrown.
  /// If [FlateFragment] is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  P usePart<P>() {
    if (isMounted) {
      return _store!._usePart<P>();
    }
    throw StateError('Fragment is not mounted');
  }

  /// Return instance of [FlateService] registered with type [S]
  ///
  /// If instance for type [S] is not registered in [FlateStore] then [StateError] will be thrown.
  /// If [FlateFragment] is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  S useService<S>() {
    if (isMounted) {
      return _store!._useService<S>();
    }
    throw StateError('Fragment of type $runtimeType is not mounted');
  }

  C useContext<C>() {
    if (isMounted) {
      return _store!.useContext<C>();
    }
    throw StateError('Fragment of type $runtimeType is not mounted');
  }
}
