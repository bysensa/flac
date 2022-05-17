part of '../core.dart';

/// Mixin used to mark class as AppObserver. Classes marked with this mixin can handle
/// memory pressure events or app lifecycle state change
mixin AppObserverMixin {
  /// Called when the system is running low on memory.
  void handleMemoryPressure() {}

  /// Called when the system puts the app in the background or returns
  /// the app to the foreground.
  void handleAppLifecycleStateChange(AppLifecycleState state) {}
}

mixin _AppObserversRegistryMixin {
  final HashedObserverList<AppObserverMixin> _observers = HashedObserverList();

  /// Register [FlateElementMixin] as observer if element conforms to type [AppObserverMixin]
  void _maybeRegisterAppObserver(FlateElementMixin element) {
    if (element is AppObserverMixin) {
      _observers.add(element as AppObserverMixin);
    }
  }

  void _releaseAppObservers() {
    final observersCopy = List.of(_observers);
    for (final observer in observersCopy) {
      _observers.remove(observer);
    }
  }

  void handleMemoryPressure() {
    for (var observer in _observers) {
      runZonedGuarded(
        observer.handleMemoryPressure,
        Zone.current.handleUncaughtError,
      );
    }
  }

  void handleAppLifecycleStateChange(AppLifecycleState state) {
    for (var observer in _observers) {
      runZonedGuarded(
        () => observer.handleAppLifecycleStateChange(state),
        Zone.current.handleUncaughtError,
      );
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
