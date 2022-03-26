part of '../core.dart';

/// Type definition of intent handling function used in [ContextAction] for specific [FlateIntent] type
typedef ComponentActionCallback<T extends FlateIntent> = Object? Function(
  T intent, [
  BuildContext? context,
]);

/// Mixin which perform [FlateIntent] registration via [IntentRegistrator]
///
/// __This class is internal and should not be used directly__
@internal
mixin IntentRegistrationProvider on ContextAction<FlateIntent> {
  /// Extend this method to define which types of [FlateIntent] can be handled
  ///
  /// Intent types can be register with or without [ComponentActionCallback]. If
  /// callback not provided then default [invoke] method will be called. In [FlateComponentModel]
  /// this method called once before [FlateComponentModel.initModel] invocation.
  ///
  ///
  /// Example:
  /// ```dart
  /// class SomeComponentModel extends FlateComponentModel<SomeComponent> {
  ///
  ///   /// All types of intent registered here
  ///   @override
  ///   void registerIntents(IntentRegistration registration) {
  ///     registration.register<SomeIntent>();
  ///     /// Type of intent inferred from provided callback
  ///     registration.registerWithCallback(_invokeOnValueChanged);
  ///   }
  ///
  ///   /// This method will handle only [IntentWithRegisteredCallback] intents
  ///   void _invokeOnValueChanged(
  ///     IntentWithRegisteredCallback intent, [
  ///     BuildContext? context,
  ///   ]) {
  ///     assert(intent is IntentWithRegisteredCallback);
  ///   }
  ///
  ///   /// Default intent handler
  ///   @override
  ///   Object? invoke(FlateIntent intent, [BuildContext? context]) {
  ///     assert(intent is SomeIntent);
  ///     return null;
  ///   }
  ///
  /// }
  /// ```
  void registerIntents(IntentRegistration registration) {}
}

mixin IntentRegistration {
  /// Register [_ComponentActionWrapper] for provided [FlateIntent] type [T].
  ///
  /// This method use [ContextAction.invoke] as default callback for [T]. Use
  /// [registerWithCallback] if you want provide custom callback for intent of type [T].
  void register<T extends FlateIntent>();

  /// Register [_ComponentActionWrapper] for provided [FlateIntent] type [T] with callback
  ///
  /// Provided callback will be called for each instance of type [T].
  ///
  /// Example:
  ///
  /// registration.registerWithCallback(someCallback);
  ///
  /// registration.registerWithCallback<SomeIntent>(someCallback);
  ///
  void registerWithCallback<T extends FlateIntent>(
    ComponentActionCallback<T> callback,
  );
}

/// Class used to create and collect [_ComponentActionWrapper] for types of [FlateIntent]
/// provided during [prepare] invocation via [register] or [registerWithCallback]
/// methods.
///
/// After invocation of prepare the internal map of actions and their associated intent types
/// can be accessed through [Map] interface implemented for this class. If [prepare] method
/// is not called then internal map of actions will be empty.
///
/// ** This class is internal and should not be used directly**
@internal
class IntentRegistrator extends UnmodifiableMapBase<Type, Action<Intent>>
    with IntentRegistration {
  final IntentRegistrationProvider _registrationProvider;
  final Map<Type, Action<Intent>> _actions = {};

  IntentRegistrator({
    required IntentRegistrationProvider componentModel,
  }) : _registrationProvider = componentModel;

  /// Return all registered [FlateIntent] types.
  ///
  /// Before [prepare] method call this getter will return empty iterator.
  @override
  Iterable<Type> get keys => _actions.keys;

  /// Used to initialize internal [Map] of actions with their associated types.
  ///
  /// This method should be called before any operations with internal actions map.
  void prepare() {
    _registrationProvider.registerIntents(this);
  }

  @override
  void register<T extends FlateIntent>() {
    _actions[T] =
        _ComponentActionWrapper<T>(componentModel: _registrationProvider);
  }

  @override
  void registerWithCallback<T extends FlateIntent>(
    ComponentActionCallback<T> callback,
  ) {
    _actions[T] = _ComponentActionWrapper<T>(
      componentModel: _registrationProvider,
      callback: callback,
    );
  }

  /// Returns [Action] for [FlateIntent] type provided as key
  ///
  /// If [_ComponentActionWrapper] for [Type] of [FlateIntent] is not registered
  /// then null will be returned.
  @override
  Action<Intent>? operator [](Object? key) => _actions[key];
}

/// Class used as proxy for [ContextAction] invocation.
///
/// There are two cases which this class used to solve. If [FlateIntent] type
/// registered without associated callback then this class delegate invocation
/// to default callback.
/// Else if [FlateIntent] type registered with associated callback then intent
/// provided via invocation will be handled by associated callback. Also this class
/// delegate some methods and getter calls to provided [_registrationProvider].
class _ComponentActionWrapper<T extends FlateIntent> extends ContextAction<T> {
  final IntentRegistrationProvider _registrationProvider;
  final ComponentActionCallback<T>? _callback;

  _ComponentActionWrapper({
    required IntentRegistrationProvider componentModel,
    ComponentActionCallback<T>? callback,
  })  : _registrationProvider = componentModel,
        _callback = callback;

  @override
  bool get isActionEnabled => _registrationProvider.isActionEnabled;

  @override
  Type get intentType => T;

  @override
  Object? invoke(T intent, [BuildContext? context]) {
    return _callback == null
        ? _registrationProvider.invoke(intent, context)
        : _callback!(intent, context);
  }

  @override
  void removeActionListener(ActionListenerCallback listener) {
    _registrationProvider.removeActionListener(listener);
    super.removeActionListener(listener);
  }

  @override
  void addActionListener(ActionListenerCallback listener) {
    super.addActionListener(listener);
    _registrationProvider.addActionListener(listener);
  }

  @override
  bool consumesKey(T intent) => _registrationProvider.consumesKey(intent);

  @override
  bool isEnabled(T intent) => _registrationProvider.isEnabled(intent);
}
