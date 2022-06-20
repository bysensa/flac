import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should resolve part and service', () {
    final store = TestStore();

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
  late TestPart testPart = usePart();
  late PartMixin partMixin = usePart();

  TestService get testService => useService();
  ServiceMixin get serviceMixin => useService();
}

mixin PartMixin {}

mixin ServiceMixin {}
