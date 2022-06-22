import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TestElementProvider provider;

  setUp(() {
    provider = TestElementProvider();
  });

  test('can register instance', () {
    final element = TestElement();
    provider.register(element);

    expect(provider.isRegistered(TestElement), isTrue);
    expect(provider.isRegistered(SomeAdditionalType), isTrue);
    expect(provider.isRegistered(NotImplementedType), isFalse);
  });

  test('can register instance by types', () {
    final element = TestElement();
    provider.registerAs<SomeAdditionalType>(element);
    provider.registerAs<TestElement>(element);
    expect(
      () => provider.registerAs<TestElement>(element),
      throwsAssertionError,
    );
    expect(
      () => provider.registerAs<NotImplementedType>(element),
      throwsAssertionError,
    );
    expect(provider.isRegistered(TestElement), isTrue);
    expect(provider.isRegistered(SomeAdditionalType), isTrue);
    expect(provider.isRegistered(NotImplementedType), isFalse);
  });

  test('should return registered instance', () {
    final element = TestElement();
    provider.register(element);

    expect(provider<TestElement>(), element);
    expect(provider<SomeAdditionalType>(), element);
  });

  test('should assert if already registered', () {
    final element = TestElement();
    provider.register(element);
    expect(() => provider.register(element), throwsAssertionError);
  });
}

mixin SomeAdditionalType {}

mixin NotImplementedType {}

class TestElement extends FlateFragment with SomeAdditionalType {
  @override
  void register(Registration registration) {
    super.register(registration);
    registration.registerAs<SomeAdditionalType>();
  }
}
