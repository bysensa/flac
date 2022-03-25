import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test direct call', () {
    final tst = TestDirectCall();
    tst.create();
    tst.measure(10000000);
  });

  test('test expando call', () {
    final tst = TestExpandoCall();
    tst.create();
    tst.measure(10000000);
  });
}

class TestDirectCall {
  late Value val;

  void create() => val = Value();

  Value get value => val;

  void measure(int iterations) {
    final measures = <int>[];
    for (final idx in List.generate(iterations, (index) => index)) {
      final sw = Stopwatch()..start();
      value;
      sw.stop();
      measures.add(sw.elapsedMicroseconds);
    }
    final max_us = measures.reduce(max);
    final min_us = measures.reduce(min);
    final avg_us = measures.reduce((a, b) => a + b) / measures.length;
    final sum_us = measures.reduce((a, b) => a + b);
    final sum_ms = measures.reduce((a, b) => a + b) / 1000;
    print('direct: max = $max_us us');
    print('direct: min = $min_us us');
    print('direct: avg = $avg_us us');
    print('direct: sum = $sum_us us');
    print('direct: sum = $sum_ms ms');
  }
}

class TestExpandoCall {
  final expando = Expando<Value>();
  late Value val;
  final Key key = Key();

  void create() {
    val = Value();
    expando[key] = val;
  }

  Value get value => expando[key]!;

  void measure(int iterations) {
    final keys = <Key>[];
    for (var idx = 0; idx < iterations; idx++) {
      final key = Key();
      keys.add(key);
      expando[key] = Value();
    }
    final measures = <int>[];
    for (final idx in List.generate(iterations, (index) => index)) {
      final sw = Stopwatch()..start();
      value;
      sw.stop();
      measures.add(sw.elapsedMicroseconds);
    }
    final max_us = measures.reduce(max);
    final min_us = measures.reduce(min);
    final avg_us = measures.reduce((a, b) => a + b) / measures.length;
    final sum_us = measures.reduce((a, b) => a + b);
    final sum_ms = measures.reduce((a, b) => a + b) / 1000;
    print('expando: max = $max_us us');
    print('expando: min = $min_us us');
    print('expando: avg = $avg_us us');
    print('expando: sum = $sum_us us');
    print('expando: sum = $sum_ms ms');
  }
}

class Key {
  Key();
}

class Value {
  Value();
}
