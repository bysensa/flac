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
class FlateStore extends _ElementsRegistry
    with
        ChangeNotifier,
        _AppObserversRegistryMixin,
        WidgetsBindingObserver,
        _WidgetsBindingObserverOverride {
  FlateStoreLifecycle _lifecycle = FlateStoreLifecycle.unprepared;
  final FlateContext context;
  final Set<FlateFragmentMixin> fragments;
  final Set<FlatePartMixin> parts;
  final Set<FlateServiceMixin> services;
  final Set<FlateModule> modules;

  @mustCallSuper
  FlateStore({
    FlateContext? context,
    Iterable<FlateFragmentMixin> fragments = const [],
    Iterable<FlatePartMixin> parts = const [],
    Iterable<FlateServiceMixin> services = const [],
    Iterable<FlateModule> modules = const [],
  })  : context = context ?? DefaultFlateContext(),
        fragments = fragments.toSet(),
        parts = parts.toSet(),
        services = services.toSet(),
        modules = modules.toSet() {
    // iterate over previously collected elements and register them
    for (var element in _orderedElements) {
      _registerElement(element, afterRegistration: _afterElementRegistration);
    }
    for (var module in modules) {
      module._register(this);
      _elements.addAll(module._elements);
    }
  }

  // collect all elements in single iterable
  late final Iterable<FlateElementMixin> _orderedElements =
      CombinedIterableView([
    [context],
    services,
    parts,
    fragments
  ]);

  /// Return this store lifecycle
  FlateStoreLifecycle get lifecycle => _lifecycle;

  /// Mount this [FlateStore] in [FlateElementMixin] and maybe register it as app observer
  void _afterElementRegistration(FlateElementMixin element) {
    _maybeRegisterAppObserver(element);
  }

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
      for (var element in _orderedElements) {
        await _activateElement(element);
      }
      for (var module in modules) {
        await module._prepare();
      }
      WidgetsBinding.instance.addObserver(this);
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
        WidgetsBinding.instance.removeObserver(this);
        _releaseAppObservers();
        for (var module in modules) {
          await module._release();
        }
        for (var element in _orderedElements.toList().reversed) {
          await _deactivateElement(element);
        }
      } finally {
        _lifecycle = FlateStoreLifecycle.released;
        notifyListeners();
      }
    });
  }
}

abstract class FlateModule extends _ElementsRegistry {
  Iterable<FlateService> get services => {};
  Iterable<FlatePart> get parts => {};
  Iterable<FlateFragment> get fragments => {};

  // collect all elements in single iterable
  late final Iterable<FlateElementMixin> _orderedElements =
      CombinedIterableView([services, parts, fragments]);

  void _register(FlateStore store) {
    void _afterElementRegistration(FlateElementMixin element) {
      store._maybeRegisterAppObserver(element);
    }

    for (var element in _orderedElements) {
      _registerElement(element, afterRegistration: _afterElementRegistration);
    }
  }

  Future<void> _prepare() async {
    for (var element in _orderedElements) {
      await _activateElement(element);
    }
  }

  Future<void> _release() async {
    for (var element in _orderedElements.toList().reversed) {
      await _deactivateElement(element);
    }
  }
}
