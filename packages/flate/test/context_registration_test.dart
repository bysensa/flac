import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should register with only self type', () {
    final context = TestContext();
    final store = FlateStore(context: context);
    expect(store.isRegistered<TestContext>(), isTrue);
    expect(store.isRegistered<AdditionalContextInterface>(), isFalse);
    expect(store.isRegistered<AdditionalContextMixin>(), isFalse);
    expect(
      () => store<AdditionalContextInterface>(),
      throwsAssertionError,
    );
    expect(
      () => store<AdditionalContextMixin>(),
      throwsAssertionError,
    );
    expect(store<TestContext>(), context);
  });

  test('should register with multiple types', () {
    final context = TestContext(onlySelfType: false);
    final store = FlateStore(context: context);
    expect(store.isRegistered<TestContext>(), isTrue);
    expect(store.isRegistered<AdditionalContextInterface>(), isTrue);
    expect(store.isRegistered<AdditionalContextMixin>(), isTrue);

    expect(store<TestContext>(), context);
    expect(store<AdditionalContextInterface>(), context);
    expect(store<AdditionalContextMixin>(), context);
  });
}

class TestContext extends FlateContext
    with AdditionalContextMixin
    implements AdditionalContextInterface {
  final bool onlySelfType;

  TestContext({
    this.onlySelfType = true,
  });

  @override
  void register(Registration registration) {
    super.register(registration);
    if (!onlySelfType) {
      registration.registerAs<AdditionalContextInterface>();
      registration.registerAs<AdditionalContextMixin>();
    }
  }
}

abstract class AdditionalContextInterface {}

mixin AdditionalContextMixin on FlateContext {}
