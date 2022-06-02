import 'dart:collection';

import 'package:money_exchange/src/currency.dart';

import 'rate.dart';

class CurrencyRates extends UnmodifiableMapBase<CurrencyCode, num> {
  final CurrencyCode baseCurrency;
  final Map<CurrencyCode, num> _rates;

  CurrencyRates._fromIterable({
    required this.baseCurrency,
    required Iterable<CurrencyRate> rates,
  }) : _rates = Map.fromEntries(rates);

  factory CurrencyRates.fromIterable({
    required CurrencyCode baseCurrency,
    required Iterable<CurrencyRate> rates,
  }) {
    if (rates.any((element) => element.baseCurrency != baseCurrency)) {
      return CurrencyRates._fromIterable(
        baseCurrency: baseCurrency,
        rates: [],
      );
    }
    return CurrencyRates._fromIterable(
      baseCurrency: baseCurrency,
      rates: rates,
    );
  }

  @override
  num? operator [](Object? key) {
    return _rates[key];
  }

  @override
  Iterable<CurrencyCode> get keys => _rates.keys;
}
