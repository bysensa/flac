/// Base currency conversion function
num convert(num val, num base, num from, num to) {
  if (val == 0 || from == 0 || to == 0 || base == 0) {
    return 0;
  }

  return val * getRate(base, from, to);
}

/// Base rate calculation function
num getRate(num base, num from, num to) {
  if (from == 0 || to == 0 || base == 0) {
    return 0;
  }
  // If `from` == base, return the basic exchange rate for the `to` currency
  if (from == base) {
    return to;
  }
  // If `to` currency == base, return the basic inverse rate of the `from` currency
  if (to == base) {
    return 1 / from;
  }
  // Otherwise, return the `to` rate multipled by the inverse of the `from` rate to get the
  // relative exchange rate between the two currencies
  return to * (1 / from);
}
