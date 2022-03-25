import 'package:mobx/mobx.dart' as mobx;

class Observable<T> implements mobx.Observable<T> {
  final mobx.Observable<T> _internal;

  Observable(
    T initialValue, {
    mobx.ReactiveContext? context,
    String? name,
    mobx.EqualityComparer<T>? equals,
  }) : _internal = mobx.Observable(
          initialValue,
          name: name,
          equals: equals,
          context: context,
        );

  @override
  T get value => _internal.value;

  @override
  String get name => _internal.name;

  @override
  mobx.ReactiveContext get context => _internal.context;

  @override
  mobx.EqualityComparer<T>? get equals => _internal.equals;

  @override
  bool get hasObservers => _internal.hasObservers;

  @override
  set value(T newValue) => _internal.value = newValue;

  @override
  mobx.Dispose intercept(mobx.Interceptor<T> interceptor) =>
      _internal.intercept(interceptor);

  @override
  mobx.Dispose observe(
    mobx.Listener<mobx.ChangeNotification<T>> listener, {
    bool fireImmediately = false,
  }) =>
      _internal.observe(listener, fireImmediately: fireImmediately);

  @override
  void Function() onBecomeObserved(void Function() fn) =>
      _internal.onBecomeObserved(fn);

  @override
  void Function() onBecomeUnobserved(void Function() fn) =>
      _internal.onBecomeUnobserved(fn);

  @override
  void reportChanged() => _internal.reportChanged();

  @override
  void reportObserved() => _internal.reportObserved();

  void call(T newValue) => _internal.value = newValue;
}
