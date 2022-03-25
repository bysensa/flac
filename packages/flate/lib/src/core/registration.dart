part of '../core.dart';

/// The class is used in the process of registering a component in the [FlateStore]
/// to get a set of [Type] with which this component can be registered
class Registration {
  final Set<Type> types = {};
  final dynamic _instance;

  Registration({
    required Object instance,
  }) : _instance = instance;

  /// Method store [Type] provided by generic parameter [T] in [types]
  ///
  /// The [Type] can be added to [types] only if [_instance] conforms to [T].
  /// If [_instance] is not conform to [T] then [StateError] throws
  void registerAs<T>() {
    if (_instance is T) {
      types.add(T);
    } else {
      throw StateError('Type ${_instance.runtimeType} is not conform to $T');
    }
  }
}
