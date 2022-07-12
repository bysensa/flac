import 'dart:collection';

import 'package:telemetry/telemetry.dart';

part 'baggage/impl.dart';

typedef BaggageValueName = String;

/// this key used to extract [Baggage] from [Context]
final _baggageKey = Context.createKey(name: 'baggage-key');

extension BaggageContextApi on Context {
  /// Extract the [Baggage] from a [Context] instance
  ///
  /// Details here: https://opentelemetry.io/docs/reference/specification/baggage/api/#context-interaction
  Baggage? get baggage {
    final maybeBaggage = Context.value(this, _baggageKey);
    if (maybeBaggage is Baggage) {
      return maybeBaggage;
    }
    return null;
  }

  /// Insert the [Baggage] to a [Context] instance
  ///
  /// Details here: https://opentelemetry.io/docs/reference/specification/baggage/api/#context-interaction
  Context insertBaggage(Baggage baggage) {
    return Context.setValue(this, _baggageKey, baggage);
  }

  /// Returns a new [Context] with no [Baggage] associated.
  ///
  /// Details here: https://opentelemetry.io/docs/reference/specification/baggage/api/#clear-baggage-in-the-context
  Context clearBaggage() {
    return Context.setValue(this, _baggageKey, null);
  }
}

/// Baggage is used to annotate telemetry, adding context and information to metrics, traces, and logs.
/// It is a set of name/value pairs describing user-defined properties. Each name in Baggage MUST be associated with exactly one value.
///
/// Details here: https://opentelemetry.io/docs/reference/specification/baggage/api/
abstract class Baggage {
  factory Baggage.empty() => _BaggageImpl();

  factory Baggage.fromMap(
    Map<BaggageValueName, Object> map,
  ) =>
      _BaggageImpl.fromMap(map);

  factory Baggage.fromEntries(
    Iterable<MapEntry<BaggageValueName, Object>> entries,
  ) =>
      _BaggageImpl.fromEntries(entries);

  /// Set the currently active [Baggage] to the implicit [Context].
  ///
  /// Details here: https://opentelemetry.io/docs/reference/specification/baggage/api/#context-interaction
  static Context makeActive(Baggage baggage) {
    final currentContext = Context.current();
    return currentContext.insertBaggage(baggage);
  }

  /// Get the currently active [Baggage] from the implicit [Context].
  ///
  /// Details here: https://opentelemetry.io/docs/reference/specification/baggage/api/#context-interaction
  static Baggage? active() {
    final currentContext = Context.current();
    return currentContext.baggage;
  }

  /// Returns a value associated with the given [name], or null if the given [name] is not present.
  ///
  /// details here: https://opentelemetry.io/docs/reference/specification/baggage/api/
  Object? value(BaggageValueName name);

  /// Returns the name/value pairs in the [Baggage].
  ///
  /// Details here: https://opentelemetry.io/docs/reference/specification/baggage/api/#get-all-values
  Iterable<MapEntry<BaggageValueName, Object>> values();

  /// Returns a new [Baggage] that contains previous name/value pairs with the new [name]/[value] pair.
  ///
  /// Optional [metadata] associated with the name-value pair. This should be an opaque wrapper
  /// for a string with no semantic meaning. Left opaque to allow for future functionality.
  /// Details here: https://opentelemetry.io/docs/reference/specification/baggage/api/#set-value
  Baggage setValue(BaggageValueName name, Object value, {String? metadata});

  /// Returns a new Baggage which no longer contains the selected [name].
  ///
  /// Details here: https://opentelemetry.io/docs/reference/specification/baggage/api/#remove-value
  Baggage removeValue(BaggageValueName name);
}
