import 'dart:async';

import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('fragment by default should register with self type', () {
    final fragment = TestFragment();
    final store = FlateStore(fragments: [fragment]);
    expect(store.useFragment<TestFragment>(), fragment);
  });

  test('fragment should be initialized on store initialize', () async {
    final part = TestPart();
    final service = TestService();
    final fragment = TestFragment();
    final store = FlateStore(
      fragments: [fragment],
      parts: [part],
      services: [service],
    );
    expect(fragment.isInitialized, isFalse);
    await store.prepare();
    expect(fragment.isInitialized, isTrue);
  });

  test('fragment should be disposed on store dispose', () async {
    final part = TestPart();
    final service = TestService();
    final fragment = TestFragment();
    final store = FlateStore(
      fragments: [fragment],
      parts: [part],
      services: [service],
    );
    expect(fragment.isInitialized, isFalse);
    await store.prepare();
    expect(fragment.isInitialized, isTrue);
    expect(fragment.isDisposed, isFalse);
    await store.release();
    expect(fragment.isDisposed, isTrue);
  });

  test('fragment should provide part', () async {
    final part = TestPart();
    final service = TestService();
    final fragment = TestFragment();
    final store = FlateStore(
      fragments: [fragment],
      parts: [part],
      services: [service],
    );
    await store.prepare();
    expect(fragment.part, part);
    expect(fragment.service, service);
  });
}

class TestFragment extends FlateFragment {
  bool isInitialized = false;
  bool isDisposed = false;

  late TestPart part;
  late TestService service;

  @override
  FutureOr<void> prepare(FlateElementProvider provider) {
    super.prepare(provider);
    isInitialized = true;
    part = provider();
    service = provider();
  }

  @override
  FutureOr<void> release() {
    isDisposed = true;
    super.release();
  }
}

class TestPart extends FlatePart {}

class TestService extends FlateService {}
