mixin Context {
  ContextKey createKey(String? name);
  ContextValue getValue(ContextKey key);
  Context setValue(ContextKey key, ContextValue value);

  operator [](ContextKey key);
  operator []=(ContextKey key, ContextValue value);
}

mixin ContextKey {
  String get name;
}

mixin ContextValue {
  dynamic get value;
}
