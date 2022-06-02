import 'dart:collection';

mixin Baggage {
  UnmodifiableMapBase<String, BaggageValue> get getValues;

  BaggageValue? getValue(String name);
  Baggage setValue(String name, BaggageValue value);
  Baggage removeValue(String name);
}

mixin BaggageValue {
  dynamic get value;
}
