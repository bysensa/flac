import 'dart:async';

import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('fragment should not be mounted until adding to store', () {
    final fragment = TestFragment();
    expect(fragment.isMounted, isFalse);
  });

  test('fragment should not be mounted until adding to store', () {
    final fragment = TestFragment();
    final store = FlateStore(fragments: [fragment]);
    expect(fragment.isMounted, isTrue);
  });

  test('fragment by default should register with self type', () {
    final fragment = TestFragment();
    final store = FlateStore(fragments: [fragment]);
    expect(store.useFragment<TestFragment>(), fragment);
  });

  test('fragment should be initialized on store initialize', () async {
    final fragment = TestFragment();
    final store = FlateStore(fragments: [fragment]);
    expect(fragment.isInitialized, isFalse);
    await store.prepare();
    expect(fragment.isInitialized, isTrue);
  });

  test('fragment should be disposed on store dispose', () async {
    final fragment = TestFragment();
    final store = FlateStore(fragments: [fragment]);
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

  TestPart get part => usePart();
  TestService get service => useService();

  @override
  FutureOr<void> prepare() {
    super.prepare();
    isInitialized = true;
  }

  @override
  FutureOr<void> release() {
    isDisposed = true;
    super.release();
  }
}

class TestPart extends FlatePart {}

class TestService extends FlateService {}
