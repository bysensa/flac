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
    final service = TestService();
    final fragment = TestFragment();
    final store = FlateStore(
      fragments: [fragment],
      services: [service],
    );
    expect(fragment.isInitialized, isFalse);
    await store.prepare();
    expect(fragment.isInitialized, isTrue);
  });

  test('fragment should be disposed on store dispose', () async {
    final service = TestService();
    final fragment = TestFragment();
    final store = FlateStore(
      fragments: [fragment],
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
    final service = TestService();
    final fragment = TestFragment();
    final store = FlateStore(
      fragments: [fragment],
      services: [service],
    );
    await store.prepare();
    expect(fragment.service, service);
  });
}

class TestFragment extends FlateFragment {
  bool isInitialized = false;
  bool isDisposed = false;

  late TestService service;

  @override
  FutureOr<void> prepare(FlateElementProvider provider) {
    super.prepare(provider);
    isInitialized = true;
    service = provider();
  }

  @override
  FutureOr<void> release() {
    isDisposed = true;
    super.release();
  }
}

class TestService extends FlateService {}
