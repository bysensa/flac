part of '../baggage.dart';

class _BaggageImpl implements Baggage {
  final Map<BaggageValueName, Object> _values;

  _BaggageImpl() : _values = {};

  _BaggageImpl.fromMap(
    Map<BaggageValueName, Object> map,
  ) : _values = Map.from(map);

  _BaggageImpl.fromEntries(
    Iterable<MapEntry<BaggageValueName, Object>> entries,
  ) : _values = Map.fromEntries(entries);

  _BaggageImpl _copy() {
    final newBaggage = _BaggageImpl();
    newBaggage._values.addAll(_values);
    return newBaggage;
  }

  @override
  Baggage removeValue(BaggageValueName name) {
    final baggageCopy = _copy();
    baggageCopy._values.remove(name);
    return baggageCopy;
  }

  @override
  Baggage setValue(BaggageValueName name, Object value, {String? metadata}) {
    final baggageCopy = _copy();
    baggageCopy._values[name] = value;
    return baggageCopy;
  }

  @override
  Object? value(BaggageValueName name) {
    return _values[name];
  }

  @override
  Iterable<MapEntry<BaggageValueName, Object>> values() {
    return _values.entries;
  }
}
