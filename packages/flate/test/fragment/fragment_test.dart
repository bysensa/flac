import 'dart:async';

import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
    await store.activate();
    expect(fragment.isInitialized, isTrue);
  });

  test('fragment should be disposed on store dispose', () async {
    final fragment = TestFragment();
    final store = FlateStore(fragments: [fragment]);
    expect(fragment.isInitialized, isFalse);
    await store.activate();
    expect(fragment.isInitialized, isTrue);
    expect(fragment.isDisposed, isFalse);
    await store.deactivate();
    expect(fragment.isDisposed, isTrue);
  });

  test('fragment can commit in nested order', () async {
    final StringBuffer output = StringBuffer();
    final store = TestFragment();
    await store.commit(() async {
      output.write('u1');
      store.commit(() async {
        output.write('n1');
      });
      output.write('u2');
      store.commit(() async {
        output.write('n2');
        store.commit(() async {
          output.write('in1');
        });
        output.write('n3');
      });
      output.write('u3');
    });
    expect(output.toString(), 'u1n1u2n2in1n3u3');
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
    await store.activate();
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
  FutureOr<void> activate() {
    super.activate();
    isInitialized = true;
  }

  @override
  FutureOr<void> deactivate() {
    isDisposed = true;
    super.deactivate();
  }
}

class TestPart extends FlatePart {}

class TestService extends FlateService {}

class FirstActivity with FlateActivity {}

class SecondActivity with FlateActivity {}
