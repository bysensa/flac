part of '../core.dart';

enum FlateStoreLifecycle {
  /// [FlateStore] is not initialized
  uninitialized,

  /// [FlateStore] perform initialization. All the resources necessary for the work
  /// should be allocated at this stage
  initialization,

  /// [FlateStore] is initialized and ready. The store is ready for the work ,
  /// all resources must be allocated
  ready,

  /// [FlateStore] perform disposing. All allocated resources should be free
  /// at the end
  disposing,
}

/// The class is designed to store the entire shared state of the application.
///
/// The shared state of the application is implemented through [FlateFragment] and [FlatePart].
/// In addition to the state, the storage allows you to register and use in fragments the logic
/// of interaction with external systems through [FlateService].
class FlateStore extends ChangeNotifier
    with
        _FragmentsRegistry,
        _PartsRegistry,
        _ServicesRegistry,
        _ConfigurationRegistry,
        _AppObserversRegistryMixin,
        WidgetsBindingObserver,
        _WidgetsBindingObserverOverride {
  FlateStoreLifecycle _lifecycle = FlateStoreLifecycle.uninitialized;

  @mustCallSuper
  FlateStore({
    FlateContext? context,
    Iterable<FlateFragment> fragments = const [],
    Iterable<FlatePart> parts = const [],
    Iterable<FlateService> services = const [],
  }) {
    _resolveAndRegisterContext(context);
    _registerServices(services);
    _registerSharedParts(parts);
    _registerFragments(fragments);
  }

  /// Return this store lifecycle
  FlateStoreLifecycle get lifecycle => _lifecycle;

  /// Register provided or default [FlateContext] and if context implement [AppObserverMixin]
  /// then register such context as app observer
  void _resolveAndRegisterContext(FlateContext? context) {
    final resolvedContext = context ?? DefaultContext();
    _registerContext(resolvedContext);
    _maybeRegisterAppObserver(resolvedContext);
  }

  /// This method register all [FlatePart] provided by [sharedParts] in this [FlateStore]
  ///
  /// During the execution of this method, the [Type] with which this
  /// [FlatePart] can be registered are calculated for each part in provided [sharedParts] collection.
  /// After that, one or more entries for each [FlatePart] are added to the internal [Map].
  /// The number of entries is equal to the number of calculated [Type] for part.
  void _registerSharedParts(Iterable<FlatePart> sharedParts) {
    for (final part in sharedParts) {
      _registerPart(part);
      part._mount(this);
      _maybeRegisterAppObserver(part);
    }
  }

  /// This method register all [FlateFragment] provided by [fragments] in this [FlateStore]
  ///
  /// During the execution of this method, the [Type] with which this
  /// [FlateFragment] can be registered are calculated for each fragment in provided [fragments] collection.
  /// After that, one or more entries for each [FlateFragment] are added to the internal [Map].
  /// The number of entries is equal to the number of calculated [Type] for fragment.
  void _registerFragments(Iterable<FlateFragment> fragments) {
    for (final fragment in fragments) {
      _registerFragment(fragment);
      fragment._mount(this);
      _maybeRegisterAppObserver(fragment);
    }
  }

  /// This method register all [FlateService] provided by [services] in this [FlateStore]
  ///
  /// During the execution of this method, the [Type] with which this
  /// [FlateService] can be registered are calculated for each service in provided [services] collection.
  /// After that, one or more entries for each [FlateService] are added to the internal [Map].
  /// The number of entries is equal to the number of calculated [Type] for service.
  void _registerServices(Iterable<FlateService> services) {
    for (final service in services) {
      _registerService(service);
      service._mount(this);
      _maybeRegisterAppObserver(service);
    }
  }

  /// This method initialize current store and all [FlateFragment], [FlatePart], [FlateService] registered in this store.
  ///
  /// Storage initialization is performed in the following order:
  /// - The storage lifecycle is changed to initialization.
  /// - Registered [FlateService] are initialized
  /// - The registered [FlatePart] are initialized
  /// - The registered [FlateFragment] are initialized
  /// - The storage lifecycle changes to [FlateStoreLifecycle.ready]
  ///
  /// If an exception occurs during the initialization of registered components,
  /// it is intercepted then wrapped in [InitializationException] and
  /// passed up for processing using [Zone.current]
  FutureOr<void> activate() async {
    if (_lifecycle != FlateStoreLifecycle.uninitialized) {
      return;
    }

    _lifecycle = FlateStoreLifecycle.initialization;
    notifyListeners();
    await _activateContext();
    await _activateServices();
    await _activateParts();
    await _activateFragments();
    WidgetsBinding.instance?.addObserver(this);
    _lifecycle = FlateStoreLifecycle.ready;
    notifyListeners();
  }

  /// Free all resources used by this [FlateStore]
  ///
  /// This method perform clean only if store lifecycle equals [FlateStoreLifecycle.ready].
  /// In the process of freeing resources, the [FlateStore] first frees
  /// the resources allocated in [FlateFragment] then the resources allocated in [FlatePart]
  /// and at the end the resources allocated by [FlateService] are released.
  FutureOr<void> deactivate() async {
    if (_lifecycle != FlateStoreLifecycle.ready) {
      return;
    }
    _lifecycle = FlateStoreLifecycle.disposing;
    notifyListeners();
    try {
      WidgetsBinding.instance?.removeObserver(this);
      await _deactivateFragments();
      await _deactivateParts();
      await _deactivateServices();
      await _deactivateContext();
    } finally {
      _lifecycle = FlateStoreLifecycle.uninitialized;
      notifyListeners();
    }
  }
}

mixin _WidgetsBindingObserverOverride
    on WidgetsBindingObserver, _AppObserversRegistryMixin {
  @override
  void didHaveMemoryPressure() {
    handleMemoryPressure();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    handleAppLifecycleStateChange(state);
  }
}
