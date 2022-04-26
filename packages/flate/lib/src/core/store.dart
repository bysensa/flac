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
        _ContextRegistry,
        _AppObserversRegistryMixin,
        WidgetsBindingObserver,
        _WidgetsBindingObserverOverride {
  FlateStoreLifecycle _lifecycle = FlateStoreLifecycle.uninitialized;

  @mustCallSuper
  FlateStore({
    FlateContext? context,
    Iterable<FlateFragmentMixin> fragments = const [],
    Iterable<FlatePartMixin> parts = const [],
    Iterable<FlateServiceMixin> services = const [],
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
    resolvedContext._mount(this);
    _maybeRegisterAppObserver(resolvedContext);
  }

  /// This method register all [FlatePart] provided by [sharedParts] in this [FlateStore]
  ///
  /// During the execution of this method, the [Type] with which this
  /// [FlatePart] can be registered are calculated for each part in provided [sharedParts] collection.
  /// After that, one or more entries for each [FlatePart] are added to the internal [Map].
  /// The number of entries is equal to the number of calculated [Type] for part.
  void _registerSharedParts(Iterable<FlatePartMixin> sharedParts) {
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
  void _registerFragments(Iterable<FlateFragmentMixin> fragments) {
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
  void _registerServices(Iterable<FlateServiceMixin> services) {
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
  /// it is intercepted then wrapped in [ActivationException] and
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

mixin _ContextRegistry {
  final Map<Type, FlateContext> _contextTypes = {};

  /// Returns all registered parts
  ///
  /// Returned map may contains multiple entries for single instance of [FlateFragment].
  Map<Type, FlateContext> get _context {
    return _contextTypes;
  }

  /// Returns instance of [FlateContext] by [Type] provided in generic parameter [C]
  ///
  /// If instance of [FlateContext] is not registered by type [C] then [StateError] throws.
  C useContext<C>() {
    final types = _contextTypes;
    if (!types.containsKey(C)) {
      throw StateError('Context of type $C not registered for $runtimeType');
    }

    return types[C] as C;
  }

  /// Register [context] instance with one or n types
  void _registerContext(FlateContext context) {
    final registration = Registration(instance: context);
    context.register(registration);
    for (final type in registration.types) {
      if (_contextTypes.containsKey(type)) {
        throw StateError(
          'Context ${context.runtimeType} already registered with type $type',
        );
      }
      _contextTypes[type] = context;
    }
  }

  /// Perform activation of registered [FlateContext]
  ///
  /// The [FlateContext.activate] will be called during invocation of this method.
  Future<void> _activateContext() async {
    for (var context in _contextTypes.values.toSet()) {
      try {
        await context.activate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          ActivationException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }

  /// Perform deactivation of registered [FlateContext]
  ///
  /// The [FlateContext.deactivate] will be called during invocation of this method.
  Future<void> _deactivateContext() async {
    for (var context in _contextTypes.values.toSet()) {
      try {
        await context.deactivate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          DeactivationException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }
}

mixin _ServicesRegistry {
  final Map<Type, FlateServiceMixin> _registeredServices = {};

  /// Returns all registered services
  ///
  /// Returned map may contains multiple entries for single instance of [FlateService].
  Map<Type, FlateServiceMixin> get _services {
    return _registeredServices;
  }

  /// Returns instance of [FlateService] by [Type] provided in generic parameter [S]
  ///
  /// If instance of [FlateService] is not registered by type [S] then [StateError] throws.
  S _useService<S>() {
    final services = _services;
    if (!services.containsKey(S)) {
      throw StateError('Service of type $S not registered in $runtimeType');
    }

    return services[S] as S;
  }

  /// Register provided [service]
  void _registerService(FlateServiceMixin service) {
    final registration = Registration(instance: service);
    service.register(registration);
    for (final type in registration.types) {
      if (_registeredServices.containsKey(type)) {
        throw StateError(
          'Part ${service.runtimeType} already registered with type $type',
        );
      }
      _registeredServices[type] = service;
    }
  }

  Future<void> _activateServices() async {
    for (var service in _registeredServices.values.toSet()) {
      try {
        await service.activate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          ActivationException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }

  Future<void> _deactivateServices() async {
    for (var service in _registeredServices.values.toSet()) {
      try {
        await service.deactivate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          DeactivationException(exception: err, trace: trace),
          trace,
        );
      }
    }
    _registeredServices.clear();
  }
}

mixin _PartsRegistry {
  final Map<Type, FlatePartMixin> _registeredParts = {};

  /// Returns all registered parts
  ///
  /// Returned map may contains multiple entries for single instance of [FlatePart].
  Map<Type, FlatePartMixin> get _parts {
    return _registeredParts;
  }

  /// Returns instance of [FlatePart] by [Type] provided in generic parameter [P]
  ///
  /// If instance of [FlatePart] is not registered by type [P] then [StateError] throws.
  P _usePart<P>() {
    final parts = _parts;
    if (!parts.containsKey(P)) {
      throw StateError('Part of type $P not registered in $runtimeType');
    }

    return parts[P] as P;
  }

  /// Register provided [part]
  void _registerPart(FlatePartMixin part) {
    final registration = Registration(instance: part);
    part.register(registration);
    for (final type in registration.types) {
      if (_registeredParts.containsKey(type)) {
        throw StateError(
          'Part ${part.runtimeType} already registered with type $type',
        );
      }
      _registeredParts[type] = part;
    }
  }

  Future<void> _activateParts() async {
    for (var part in _parts.values.toSet()) {
      try {
        await part.activate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          ActivationException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }

  Future<void> _deactivateParts() async {
    for (var part in _parts.values.toSet()) {
      try {
        await part.deactivate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          DeactivationException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }
}

mixin _FragmentsRegistry {
  final Map<Type, FlateFragmentMixin> _storeFragments = {};

  /// Returns all registered parts
  ///
  /// Returned map may contains multiple entries for single instance of [FlateFragment].
  Map<Type, FlateFragmentMixin> get _fragments {
    return _storeFragments;
  }

  /// Returns instance of [FlateFragment] by [Type] provided in generic parameter [F]
  ///
  /// If instance of [FlateFragment] is not registered by type [F] then [StateError] throws.
  F useFragment<F>() {
    final fragments = _fragments;
    if (!fragments.containsKey(F)) {
      throw StateError('Fragment of type $F not registered for $runtimeType');
    }

    return fragments[F] as F;
  }

  /// Register [fragment] instance
  void _registerFragment(FlateFragmentMixin fragment) {
    final registration = Registration(instance: fragment);
    fragment.register(registration);
    for (final type in registration.types) {
      if (_storeFragments.containsKey(type)) {
        throw StateError(
          'Fragment ${fragment.runtimeType} already registered with type $type',
        );
      }
      _storeFragments[type] = fragment;
    }
  }

  Future<void> _activateFragments() async {
    for (var fragment in _storeFragments.values.toSet()) {
      try {
        await fragment.activate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          ActivationException(exception: err, trace: trace),
          trace,
        );
      }
    }
  }

  Future<void> _deactivateFragments() async {
    for (var fragment in _storeFragments.values.toSet()) {
      try {
        await fragment.deactivate();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(
          DeactivationException(exception: err, trace: trace),
          trace,
        );
      }
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
