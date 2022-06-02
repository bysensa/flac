abstract class Instrument {
  InstrumentName get name;
  InstrumentKind get kind;
  InstrumentUnit get unit;
  InstrumentDescription get description;
}

abstract class InstrumentName {}

enum InstrumentKind {
  counter,
  counterAsync,
  counterUpDown,
  counterUpDownAsync,
  histogram,
  gaugeAsync,
}

abstract class InstrumentUnit {}

abstract class InstrumentDescription {}
