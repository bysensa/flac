import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should delegate error to parent zone and continue execution', () {
    late dynamic handledError;
    runZonedGuarded(() {
      throw Exception();
    }, (err, trace) {
      handledError = err;
    });
    expect(handledError, isA<Exception>());
  });

  test('should handle error thrown from future inside guarded zone', () async {
    Future<void> asyncErrorFunction() async {
      await Future.error(Exception());
    }

    void syncFunction() {
      asyncErrorFunction();
    }

    late dynamic handledError;
    runZonedGuarded(() {
      syncFunction();
    }, (err, trace) {
      handledError = err;
    });
    await Future.delayed(const Duration(milliseconds: 1));
    expect(handledError, isA<Exception>());
  });
}
