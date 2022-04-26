part of '../core.dart';

mixin FlateElementMixin {
  static final _storeMount = Expando<FlateStore>('storeMount');

  FlateStore? get _store => _storeMount[this];

  @visibleForTesting
  @protected
  bool get isMounted => _store != null;

  /// This method used during registration to define set of [Type] with which this [FlateElementMixin] will be registered
  ///
  /// By default this method provide type from [runtimeType] getter. This method can be overridden
  /// if an instance needs to be registered with multiple types that it implements.
  /// If you try to specify a type that this instance does not implement, an exception will be thrown
  ///
  /// ```dart
  ///
  ///   @override
  ///   void register(Registration registration) {
  ///     super.register(registration);
  ///     registration.registerAs<SomeModel>();
  ///   }
  /// ```
  @mustCallSuper
  void register(Registration registration) {
    registration.types.add(runtimeType);
  }

  /// This method perform instance initialization
  ///
  /// This method called during [FlateStore] initialization.
  /// Override this method to declare custom initialization logic
  /// or allocate some resources
  @mustCallSuper
  @protected
  FutureOr<void> activate() {}

  /// This method perform instance dispose
  ///
  /// This method called during [FlateStore] dispose.
  /// Override this method to declare custom clean logic
  /// or free some allocated resources
  @mustCallSuper
  @protected
  FutureOr<void> deactivate() {}

  /// Mount provided [store] in this [FlateElementMixin]
  void _mount(FlateStore store) {
    _storeMount[this] = store;
  }

  /// Provide instance of [FlateContext] by type [C]
  ///
  /// If instance for type [C] is not registered then [StateError] will be thrown.
  /// If element is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  C _useContext<C>() {
    if (isMounted) {
      return _store!.useContext<C>();
    }
    throw StateError('Element of type $runtimeType is not mounted');
  }

  /// Provide instance of [FlatePart] by type [P]
  ///
  /// If instance for type [P] is not registered then [StateError] will be thrown.
  /// If element is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  P _usePart<P>() {
    if (isMounted) {
      return _store!._usePart<P>();
    }
    throw StateError('Element is not mounted');
  }

  /// Provide instance of [FlateService] by type [S]
  ///
  /// If instance for type [S] is not registered then [StateError] will be thrown.
  /// If element is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  S _useService<S>() {
    if (isMounted) {
      return _store!._useService<S>();
    }
    throw StateError('Element of type $runtimeType is not mounted');
  }
}

/// Mixin used to implement [FlateService] class
///
/// Custom service type can be implemented by mixing [FlateElementMixin] and [FlateServiceMixin]
mixin FlateServiceMixin on FlateElementMixin {
  /// Provide instance of [FlateContext] by type [C]
  @protected
  C useContext<C>() => _useContext<C>();
}

/// Mixin used to implement [FlatePart] class
///
/// Custom part type can be implemented by mixing [FlateElementMixin] and [FlatePartMixin]
mixin FlatePartMixin on FlateElementMixin {
  /// Provide instance of [FlateContext] by type [C]
  @protected
  C useContext<C>() => _useContext<C>();

  /// Provide instance of [FlateService] by type [S]
  @protected
  S useService<S>() => _useService<S>();
}

/// Mixin used to implement [FlateFragment] class
///
/// Custom part type can be implemented by mixing [FlateElementMixin] and [FlateFragmentMixin]
mixin FlateFragmentMixin on FlateElementMixin {
  /// Provide instance of [FlateContext] by type [C]
  @protected
  C useContext<C>() => _useContext<C>();

  /// Provide instance of [FlateService] by type [S]
  @protected
  S useService<S>() => _useService<S>();

  /// Provide instance of [FlatePart] by type [P]
  @protected
  P usePart<P>() => _usePart<P>();
}
