part of '../core.dart';

/// The class is used in the process of registering a component in the [FlateStore]
/// to get a set of [Type] with which this component can be registered
class Registration {
  final Set<Type> _types = {};
  final FlateElementMixin _instance;

  Registration({
    required FlateElementMixin instance,
  }) : _instance = instance;

  /// Returns the object for which this class was created
  FlateElementMixin get instance => _instance;

  /// Return iterable of types which implemented by [instance]
  ///
  /// Type from [instance.runtimeType] also included in returned iterable.
  Iterable<Type> get types => CombinedIterableView([
        {_instance.runtimeType},
        _types,
      ]);

  /// Method store [Type] provided by generic parameter [T] in [types]
  ///
  /// The [Type] can be added to [types] only if [_instance] conforms to [T].
  /// If [_instance] is not conform to [T] then [StateError] throws
  void registerAs<T>() {
    if (_instance is T) {
      _types.add(T);
    } else {
      throw StateError('Type ${_instance.runtimeType} is not conform to $T');
    }
  }
}
