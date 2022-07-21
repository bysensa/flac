import 'dart:async';

import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('should resolve part and service', () async {
    final store = TestStore();
    await store.prepare();

    final fragment = store.useFragment<TestFragment>();
    expect(fragment.serviceMixin, fragment.testService);
    expect(fragment.serviceMixin, isNotNull);
  });
}

class TestStore extends FlateStore {
  TestStore()
      : super(
          fragments: [TestFragment()],
          services: [TestService()],
        );
}

class TestService extends FlateService with ServiceMixin {
  @override
  void register(Registration registration) {
    super.register(registration);
    registration.registerAs<ServiceMixin>();
  }
}

class TestFragment extends FlateFragment {
  late TestService testService;
  late ServiceMixin serviceMixin;

  @override
  FutureOr<void> prepare(FlateElementProvider provider) {
    super.prepare(provider);
    testService = provider();
    serviceMixin = provider();
  }
}

mixin ServiceMixin {}
