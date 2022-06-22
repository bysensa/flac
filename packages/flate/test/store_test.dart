import 'dart:async';

import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('should resolve part and service', () async {
    final store = TestStore();
    await store.prepare();

    final fragment = store.useFragment<TestFragment>();
    expect(fragment.partMixin, fragment.testPart);
    expect(fragment.partMixin, isNotNull);
    expect(fragment.serviceMixin, fragment.testService);
    expect(fragment.serviceMixin, isNotNull);
  });
}

class TestStore extends FlateStore {
  TestStore()
      : super(
          fragments: [TestFragment()],
          parts: [TestPart()],
          services: [TestService()],
        );
}

class TestPart extends FlatePart with PartMixin {
  @override
  void register(Registration registration) {
    super.register(registration);
    registration.registerAs<PartMixin>();
  }
}

class TestService extends FlateService with ServiceMixin {
  @override
  void register(Registration registration) {
    super.register(registration);
    registration.registerAs<ServiceMixin>();
  }
}

class TestFragment extends FlateFragment {
  late TestPart testPart;
  late PartMixin partMixin;

  late TestService testService;
  late ServiceMixin serviceMixin;

  @override
  FutureOr<void> prepare(FlateElementProvider provider) {
    super.prepare(provider);
    testService = provider();
    serviceMixin = provider();
    testPart = provider();
    partMixin = provider();
  }
}

mixin PartMixin {}

mixin ServiceMixin {}
