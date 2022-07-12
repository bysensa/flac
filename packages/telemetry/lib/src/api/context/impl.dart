part of '../context.dart';

class _ContextImpl implements Context {
  final Map<ContextKey, Object> _values = {};

  @override
  Context _setValue(ContextKey key, Object? value) {
    final newContext = _ContextImpl();
    newContext._values.addAll(_values);
    if (value == null) {
      newContext._values.remove(key);
    } else {
      newContext._values[key] = value;
    }
    return newContext;
  }

  @override
  Object? _value(ContextKey key) {
    return _values[key];
  }
}
