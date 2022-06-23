import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Type definition of intent handling function used in [ContextAction] for specific [Intent] type
typedef ComponentActionCallback<T extends Intent> = Object? Function(
  T intent, [
  BuildContext? context,
]);

typedef IntentRegistrationFn = void Function(IntentRegistration);

/// Mixin which perform [Intent] registration via [IntentRegistrator]
///
/// __This class is internal and should not be used directly__
@internal
mixin IntentRegistrationProvider on ContextAction<Intent> {
  /// Extend this method to define which types of [Intent] can be handled
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
  ///   Object? invoke(Intent intent, [BuildContext? context]) {
  ///     assert(intent is SomeIntent);
  ///     return null;
  ///   }
  ///
  /// }
  /// ```
  void registerIntents(IntentRegistration registration) {}
}

mixin IntentRegistration {
  /// Register [_ComponentActionWrapper] for provided [Intent] type [T].
  ///
  /// This method use [ContextAction.invoke] as default callback for [T]. Use
  /// [registerWithCallback] if you want provide custom callback for intent of type [T].
  void register<T extends Intent>();

  /// Register [_ComponentActionWrapper] for provided [Intent] type [T] with callback
  ///
  /// Provided callback will be called for each instance of type [T].
  ///
  /// Example:
  ///
  /// registration.registerWithCallback(someCallback);
  ///
  /// registration.registerWithCallback<SomeIntent>(someCallback);
  ///
  void registerWithCallback<T extends Intent>(
    ComponentActionCallback<T> callback,
  );
}

/// Class used to create and collect [_ComponentActionWrapper] for types of [Intent]
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
  final IntentRegistrationFn _intentRegistrationFn;
  final Map<Type, Action<Intent>> _actions = {};
  final ContextAction<Intent> _delegatedAction;

  IntentRegistrator({
    required IntentRegistrationFn intentRegistrationFn,
    required ContextAction<Intent> delegatedAction,
  })  : _intentRegistrationFn = intentRegistrationFn,
        _delegatedAction = delegatedAction;

  /// Return all registered [Intent] types.
  ///
  /// Before [prepare] method call this getter will return empty iterator.
  @override
  Iterable<Type> get keys => _actions.keys;

  /// Used to initialize internal [Map] of actions with their associated types.
  ///
  /// This method should be called before any operations with internal actions map.
  void prepare() {
    _intentRegistrationFn(this);
  }

  @override
  void register<T extends Intent>() {
    _actions[T] = _ComponentActionWrapper<T>(delegatedAction: _delegatedAction);
  }

  @override
  void registerWithCallback<T extends Intent>(
    ComponentActionCallback<T> callback,
  ) {
    _actions[T] = _ComponentActionWrapper<T>(
      delegatedAction: _delegatedAction,
      callback: callback,
    );
  }

  /// Returns [Action] for [Intent] type provided as key
  ///
  /// If [_ComponentActionWrapper] for [Type] of [Intent] is not registered
  /// then null will be returned.
  @override
  Action<Intent>? operator [](Object? key) => _actions[key];
}

/// Class used as proxy for [ContextAction] invocation.
///
/// There are two cases which this class used to solve. If [Intent] type
/// registered without associated callback then this class delegate invocation
/// to default callback.
/// Else if [Intent] type registered with associated callback then intent
/// provided via invocation will be handled by associated callback. Also this class
/// delegate some methods and getter calls to provided [_registrationProvider].
class _ComponentActionWrapper<T extends Intent> extends ContextAction<T> {
  final ComponentActionCallback<T>? _callback;
  final ContextAction<Intent> _delegatedAction;

  _ComponentActionWrapper({
    required ContextAction<Intent> delegatedAction,
    ComponentActionCallback<T>? callback,
  })  : _callback = callback,
        _delegatedAction = delegatedAction;

  @override
  bool get isActionEnabled => _delegatedAction.isActionEnabled;

  @override
  Type get intentType => T;

  @override
  Object? invoke(T intent, [BuildContext? context]) {
    return _callback == null
        ? _delegatedAction.invoke(intent, context)
        : _callback!(intent, context);
  }

  @override
  void removeActionListener(ActionListenerCallback listener) {
    _delegatedAction.removeActionListener(listener);
    super.removeActionListener(listener);
  }

  @override
  void addActionListener(ActionListenerCallback listener) {
    super.addActionListener(listener);
    _delegatedAction.addActionListener(listener);
  }

  @override
  bool consumesKey(T intent) => _delegatedAction.consumesKey(intent);

  @override
  bool isEnabled(T intent) => _delegatedAction.isEnabled(intent);
}
