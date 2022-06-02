import 'package:money_exchange/money_exchange.dart';
import 'package:money_exchange/src/rate.dart';
import 'package:money_exchange/src/rates.dart';

import 'currency.dart';

class Exchange {
  final CurrencyRates rates;
  final CurrencyCode? from;
  final CurrencyCode? to;
  final num? amount;

  const Exchange({
    required this.rates,
    this.from,
    this.to,
    this.amount,
  });

  Exchange copyWith({
    CurrencyRates? rates,
    CurrencyCode? from,
    CurrencyCode? to,
    num? amount,
  }) {
    if ((rates == null || identical(rates, this.rates)) &&
        (from == null || identical(from, this.from)) &&
        (to == null || identical(to, this.to)) &&
        (amount == null || identical(amount, this.amount))) {
      return this;
    }

    return Exchange(
      rates: rates ?? this.rates,
      from: from ?? this.from,
      to: to ?? this.to,
      amount: amount ?? this.amount,
    );
  }

  num call() {
    if (amount == null || from == null || to == null) {
      throw StateError('Maybe amount, from or to parameter is null');
    }
    final base = rates[rates.baseCurrency] ?? 1;
    final fromValue = rates[from];
    final toValue = rates[to];
    if (fromValue == null || toValue == null) {
      throw StateError(
          'Rate for currency $from or currency $to not present in rates');
    }
    return convert(amount!, base, fromValue, toValue);
  }
}

extension ExchangeExtension on Exchange {
  Exchange from(CurrencyCode currency) => copyWith(from: currency);
  Exchange to(CurrencyCode currency) => copyWith(to: currency);
  Exchange amount(num value) => copyWith(amount: value);
}
