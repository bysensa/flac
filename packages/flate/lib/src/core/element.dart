part of '../core.dart';

abstract class FlateElement {
  static final _storeMount = Expando<FlateStore>('storeMount');

  FlateStore? get _store => _storeMount[this];

  @visibleForTesting
  @protected
  bool get isMounted => _store != null;

  /// This method used during registration to define set of [Type] with which this [FlateElement] will be registered
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

  /// Mount provided [store] in this [FlateElement]
  void _mount(FlateStore store) {
    _storeMount[this] = store;
  }
}
