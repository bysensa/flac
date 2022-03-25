part of '../core.dart';

typedef ComponentActionCallback<T extends FlateIntent> = Object? Function(
  T intent, [
  BuildContext? context,
]);

mixin IntentRegistrationProvider on ContextAction<FlateIntent> {
  void registerIntents(IntentRegistration registration) {}
}

class IntentRegistration extends UnmodifiableMapBase<Type, Action<Intent>> {
  final FlateComponentModel _componentModel;
  final Map<Type, Action<Intent>> _actions = {};

  IntentRegistration({
    required FlateComponentModel componentModel,
  }) : _componentModel = componentModel;

  @override
  Iterable<Type> get keys => _actions.keys;

  void prepare() {
    _componentModel.registerIntents(this);
  }

  void register<T extends FlateIntent>() {
    _actions[T] = _ComponentActionWrapper<T>(componentModel: _componentModel);
  }

  void registerWithCallback<T extends FlateIntent>(
    ComponentActionCallback<T> callback,
  ) {
    _actions[T] = _ComponentActionWrapper<T>(
      componentModel: _componentModel,
      callback: callback,
    );
  }

  @override
  Action<Intent>? operator [](Object? key) => _actions[key];
}

class _ComponentActionWrapper<T extends FlateIntent> extends ContextAction<T> {
  final FlateComponentModel _componentModel;
  final ComponentActionCallback<T>? _callback;

  _ComponentActionWrapper({
    required FlateComponentModel componentModel,
    ComponentActionCallback<T>? callback,
  })  : _componentModel = componentModel,
        _callback = callback;

  @override
  bool get isActionEnabled => _componentModel.isActionEnabled;

  @override
  Type get intentType => T;

  @override
  Object? invoke(T intent, [BuildContext? context]) {
    return _callback == null
        ? _componentModel.invoke(intent, context)
        : _callback!(intent, context);
  }

  @override
  void removeActionListener(ActionListenerCallback listener) {
    _componentModel.removeActionListener(listener);
    super.removeActionListener(listener);
  }

  @override
  void addActionListener(ActionListenerCallback listener) {
    super.addActionListener(listener);
    _componentModel.addActionListener(listener);
  }

  @override
  bool consumesKey(T intent) => _componentModel.consumesKey(intent);

  @override
  bool isEnabled(T intent) => _componentModel.isEnabled(intent);
}
