part of '../core.dart';

mixin _ServicesRegistry {
  final Map<Type, FlateService> _registeredServices = {};

  /// Returns all registered services
  ///
  /// Returned map may contains multiple entries for single instance of [FlateService].
  Map<Type, FlateService> get _services {
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
  void _registerService(FlateService service) {
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
          InitializationException(exception: err, trace: trace),
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
          DisposeException(exception: err, trace: trace),
          trace,
        );
      }
    }
    _registeredServices.clear();
  }
}
