import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should store type as registration type', () {
    final registration = Registration(instance: TestType());
    registration.registerAs<TestType>();
    expect(registration.types, {TestType});
  });

  test('should throw if instance not conform to type', () {
    final registration = Registration(instance: TestType());
    expect(
      () => registration.registerAs<NotImplementedType>(),
      throwsStateError,
    );
  });
}

class TestType {}

mixin NotImplementedType {}
