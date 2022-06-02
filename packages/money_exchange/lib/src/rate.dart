import 'package:money_exchange/src/currency.dart';

class CurrencyRate implements MapEntry<CurrencyCode, num> {
  final CurrencyCode baseCurrency;
  final CurrencyCode currency;
  final num rate;

  const CurrencyRate({
    required this.baseCurrency,
    required this.currency,
    required this.rate,
  });

  @override
  CurrencyCode get key => currency;

  @override
  num get value => rate;
}

extension CurrencyRateMapEntry on MapEntry<CurrencyCode, num> {
  CurrencyCode get currency => key;
  num get rate => value;
  CurrencyCode? get maybeBaseCurrency =>
      this is CurrencyRate ? (this as CurrencyRate).baseCurrency : null;
}
