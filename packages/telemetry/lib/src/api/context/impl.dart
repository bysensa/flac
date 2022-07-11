part of '../context.dart';

class _ContextImpl implements Context {
  final Map<ContextKey, dynamic> _values = {};

  @override
  Context _setValue(ContextKey key, dynamic value) {
    final newContext = _ContextImpl();
    newContext._values.addAll(_values);
    newContext._values[key] = value;
    return newContext;
  }

  @override
  dynamic _value(ContextKey key) {
    return _values[key];
  }
}
