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
  void register(Registration registration) {}

  /// This method perform instance initialization
  ///
  /// This method called during [FlateStore] initialization.
  /// Override this method to declare custom initialization logic
  /// or allocate some resources. Parameter [provider] used to retrieve registered
  /// instance of [FlateElementMixin].
  @mustCallSuper
  FutureOr<void> prepare(covariant FlateElementProvider provider) {}

  /// This method perform instance dispose
  ///
  /// This method called during [FlateStore] dispose.
  /// Override this method to declare custom clean logic
  /// or free some allocated resources
  @mustCallSuper
  FutureOr<void> release() {}
}

/// Mixin used to implement [FlateService] class
///
/// Custom service type can be implemented by mixing [FlateElementMixin] and [FlateServiceMixin]
mixin FlateServiceMixin on FlateElementMixin {}

/// Mixin used to implement [FlatePart] class
///
/// Custom part type can be implemented by mixing [FlateElementMixin] and [FlatePartMixin]
mixin FlatePartMixin on FlateElementMixin {}

/// Mixin used to implement [FlateFragment] class
///
/// Custom part type can be implemented by mixing [FlateElementMixin] and [FlateFragmentMixin]
mixin FlateFragmentMixin on FlateElementMixin {}

/// The class is used to store, initialize and dispose information about current Environment
///
/// Potentially, this class can contain information about the current configuration of the application,
/// instances of global services necessary for the operation of services and other entities necessary
/// for the correct operation of the application.
abstract class FlateContext with FlateElementMixin {}

/// Mixin to implement callable class which provide instance of [FlateElementMixin]
mixin FlateElementProvider {
  /// Returns instance of [FlateElementMixin] which conforms to type [T]
  ///
  /// Throws [StateError] in case when type [T] is not registered
  T call<T>();
}
