part of '../core.dart';

/// [FlateElementMixin] is main primitive in Flate architecture
mixin FlateElementMixin {
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
  FutureOr<void> prepare(covariant ProviderForElement provider) {}

  /// This method perform instance dispose
  ///
  /// This method called during [FlateStore] dispose.
  /// Override this method to declare custom clean logic
  /// or free some allocated resources
  @mustCallSuper
  @protected
  FutureOr<void> release() {}
}

/// Mixin used to implement [FlateService] class
///
/// Custom service type can be implemented by mixing [FlateElementMixin] and [FlateServiceMixin]
mixin FlateServiceMixin on FlateElementMixin {
  @override
  FutureOr<void> prepare(ProviderForService provider) {
    super.prepare(provider);
  }
}

/// Mixin used to implement [FlatePart] class
///
/// Custom part type can be implemented by mixing [FlateElementMixin] and [FlatePartMixin]
mixin FlatePartMixin on FlateElementMixin {
  @override
  FutureOr<void> prepare(ProviderForPart provider) {
    super.prepare(provider);
  }
}

/// Mixin used to implement [FlateFragment] class
///
/// Custom part type can be implemented by mixing [FlateElementMixin] and [FlateFragmentMixin]
mixin FlateFragmentMixin on FlateElementMixin {
  @override
  FutureOr<void> prepare(ProviderForFragment provider) {
    super.prepare(provider);
  }
}

/// The class is used to store, initialize and dispose information about current Environment
///
/// Potentially, this class can contain information about the current configuration of the application,
/// instances of global services necessary for the operation of services and other entities necessary
/// for the correct operation of the application.
abstract class FlateContext with FlateElementMixin {}

mixin ProviderForElement {}

mixin ProviderForService implements ProviderForElement {
  /// Provide instance of [FlateContext] by type [C]
  C useContext<C>();
}

mixin ProviderForPart implements ProviderForElement {
  /// Provide instance of [FlateContext] by type [C]
  C useContext<C>();

  /// Provide instance of [FlateService] by type [S]
  S useService<S>();
}

mixin ProviderForFragment implements ProviderForElement {
  /// Provide instance of [FlateContext] by type [C]
  C useContext<C>();

  /// Provide instance of [FlateService] by type [S]
  S useService<S>();

  /// Provide instance of [FlatePart] by type [P]
  P usePart<P>();
}
