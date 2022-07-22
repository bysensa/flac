part of '../core.dart';

enum FlateStoreLifecycle {
  /// [FlateStore] is not prepared
  unprepared,

  /// [FlateStore] perform preparing. All the resources necessary for the work
  /// should be allocated at this stage
  preparing,

  /// [FlateStore] is prepared and ready. The store is ready for the work,
  /// all resources must be allocated
  prepared,

  /// [FlateStore] perform release. All allocated resources should be free
  /// at the end
  releasing,

  /// [FlateStore] already released. All allocated resources should be free
  /// at this time
  released,
}

/// The class is designed to store the entire shared state of the application.
///
/// The shared state of the application is implemented through [FlateFragment] and [FlatePart].
/// In addition to the state, the storage allows you to register and use in fragments the logic
/// of interaction with external systems through [FlateService].
class FlateStore with ChangeNotifier {
  final FlateContext context;
  final Set<FlateFragmentMixin> fragments;
  final Set<FlateServiceMixin> services;
  final Set<FlateModule> modules;
  final FlateConfiguration _configuration;

  late FlateRegistry _registry;
  FlateStoreLifecycle _lifecycle = FlateStoreLifecycle.unprepared;

  // collect all elements in single iterable
  late final Iterable<FlateElementMixin> _orderedElements =
      CombinedIterableView([
    [context],
    services,
    fragments,
  ]);

  @mustCallSuper
  FlateStore({
    FlateConfiguration? configuration,
    FlateContext? context,
    Iterable<FlateFragmentMixin> fragments = const [],
    Iterable<FlateServiceMixin> services = const [],
    Iterable<FlateModule> modules = const [],
  })  : _configuration = configuration ?? const FlateConfiguration(),
        context = context ?? DefaultFlateContext(),
        fragments = fragments.toSet(),
        services = services.toSet(),
        modules = modules.toSet() {
    _registry = _configuration.registryBuilder();
    // iterate over previously collected elements and register them
    for (var element in _orderedElements) {
      final registration = Registration(instance: element);
      element.register(registration);
      _registry.applyRegistration(registration);
    }
    for (var module in modules) {
      module._register(_registry);
    }
  }

  /// Return this store lifecycle
  FlateStoreLifecycle get lifecycle => _lifecycle;

  F useFragment<F extends FlateFragmentMixin>() => _registry.useFragment<F>();

  /// This method initialize current store and all [FlateFragment], [FlatePart], [FlateService] registered in this store.
  ///
  /// Storage initialization is performed in the following order:
  /// - The storage lifecycle is changed to initialization.
  /// - Registered [FlateService] are initialized
  /// - The registered [FlatePart] are initialized
  /// - The registered [FlateFragment] are initialized
  /// - The storage lifecycle changes to [FlateStoreLifecycle.prepared]
  ///
  /// If an exception occurs during the initialization of registered components,
  /// it is intercepted then wrapped in [ActivationException] and
  /// passed up for processing using [Zone.current]
  FutureOr<void> prepare() async {
    await commit(() async {
      if (_lifecycle != FlateStoreLifecycle.unprepared) {
        return;
      }

      _lifecycle = FlateStoreLifecycle.preparing;
      notifyListeners();
      await _registry.prepareElements();
      _lifecycle = FlateStoreLifecycle.prepared;
      notifyListeners();
    });
  }

  /// Free all resources used by this [FlateStore]
  ///
  /// This method perform clean only if store lifecycle equals [FlateStoreLifecycle.prepared].
  /// In the process of freeing resources, the [FlateStore] first frees
  /// the resources allocated in [FlateFragment] then the resources allocated in [FlatePart]
  /// and at the end the resources allocated by [FlateService] are released.
  FutureOr<void> release() async {
    await commit(() async {
      if (_lifecycle != FlateStoreLifecycle.prepared) {
        return;
      }
      _lifecycle = FlateStoreLifecycle.releasing;
      notifyListeners();
      try {
        await _registry.releaseElements();
      } finally {
        _lifecycle = FlateStoreLifecycle.released;
        notifyListeners();
      }
    });
  }
}

abstract class FlateModule {
  // collect all elements in single iterable
  late final Iterable<FlateElementMixin> _orderedElements =
      CombinedIterableView([services, fragments]);

  Iterable<FlateService> get services => {};
  Iterable<FlateFragment> get fragments => {};

  void _register(FlateRegistry parentRegistry) {
    final registry = FlateRegistry();
    for (var element in _orderedElements) {
      final registration = Registration(instance: element);
      element.register(registration);
      registry.applyRegistration(registration);
    }
    parentRegistry.mergeRegistry(registry);
  }
}
