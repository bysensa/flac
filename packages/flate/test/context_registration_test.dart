import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should register with only self type', () {
    final context = TestContext();
    final store = FlateStore(context: context);
    expect(store.isContextRegistered<TestContext>(), isTrue);
    expect(store.isContextRegistered<AdditionalContextInterface>(), isFalse);
    expect(store.isContextRegistered<AdditionalContextMixin>(), isFalse);
    expect(
      () => store.useContext<AdditionalContextInterface>(),
      throwsStateError,
    );
    expect(
      () => store.useContext<AdditionalContextMixin>(),
      throwsStateError,
    );
    expect(store.useContext<TestContext>(), context);
  });

  test('should register with multiple types', () {
    final context = TestContext(onlySelfType: false);
    final store = FlateStore(context: context);
    expect(store.isContextRegistered<TestContext>(), isTrue);
    expect(store.isContextRegistered<AdditionalContextInterface>(), isTrue);
    expect(store.isContextRegistered<AdditionalContextMixin>(), isTrue);

    expect(store.useContext<TestContext>(), context);
    expect(store.useContext<AdditionalContextInterface>(), context);
    expect(store.useContext<AdditionalContextMixin>(), context);
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
