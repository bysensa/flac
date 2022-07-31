import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

mixin _Alias {}

class _Context = MockFlateContext with _Alias;
class _FirstService = MockFlateService with _Alias;
class _SecondService = MockFlateService with _Alias;
class _FirstFragment = MockFlateFragment with _Alias;
class _SecondFragment = MockFlateFragment with _Alias;

void main() {
  late _Context context;
  late _FirstService firstService;
  late _SecondService secondService;
  late _FirstFragment firstFragment;
  late _SecondFragment secondFragment;
  late List<FlateElementMixin> elements;

  setUp(() {
    context = _Context();
    firstService = _FirstService();
    secondService = _SecondService();
    firstFragment = _FirstFragment();
    secondFragment = _SecondFragment();
    elements = [
      context,
      firstService,
      secondService,
      firstFragment,
      secondFragment,
    ];
  });

  test('should register', () {
    final registry = FlateRegistry();
    final registration = Registration(instance: context);
    registry.applyRegistration(registration);
    expect(registry.isRegistered<_Context>(), isTrue);
  });

  test('should prepare in right order', () async {
    final registry = FlateRegistry();
    for (final element in elements) {
      final registration = Registration(instance: element);
      registry.applyRegistration(registration);
    }
    await registry.prepareElements();
    verifyInOrder([
      () => context.prepare(registry),
      () => firstService.prepare(registry),
      () => secondService.prepare(registry),
      () => firstFragment.prepare(registry),
      () => secondFragment.prepare(registry),
    ]);
  });

  test('should release in right order', () async {
    final registry = FlateRegistry();
    for (final element in elements) {
      final registration = Registration(instance: element);
      registry.applyRegistration(registration);
    }
    await registry.releaseElements();
    verifyInOrder([
      () => secondFragment.release(),
      () => firstFragment.release(),
      () => secondService.release(),
      () => firstService.release(),
      () => context.release(),
    ]);
  });

  test('should merge registry correctly', () {
    final rootRegistry = FlateRegistry();
    for (final element in <FlateElementMixin>[
      context,
      firstService,
    ]) {
      final registration = Registration(instance: element);
      rootRegistry.applyRegistration(registration);
    }
    expect(rootRegistry.isRegistered<_Context>(), isTrue);
    expect(rootRegistry.isRegistered<_FirstService>(), isTrue);
    expect(rootRegistry.isRegistered<_SecondService>(), isFalse);

    final childRegistry = FlateRegistry();
    for (final element in <FlateElementMixin>[
      secondService,
    ]) {
      final registration = Registration(instance: element);
      childRegistry.applyRegistration(registration);
    }
    expect(childRegistry.isRegistered<_Context>(), isFalse);
    expect(childRegistry.isRegistered<_FirstService>(), isFalse);
    expect(childRegistry.isRegistered<_SecondService>(), isTrue);

    rootRegistry.mergeRegistry(childRegistry);
    expect(rootRegistry.isRegistered<_Context>(), isTrue);
    expect(rootRegistry.isRegistered<_FirstService>(), isTrue);
    expect(rootRegistry.isRegistered<_SecondService>(), isTrue);
  });

  test('should prepare in right order after merge registry', () async {
    final rootRegistry = FlateRegistry();
    for (final element in <FlateElementMixin>[
      context,
      secondService,
    ]) {
      final registration = Registration(instance: element);
      rootRegistry.applyRegistration(registration);
    }

    final childRegistry = FlateRegistry();
    for (final element in <FlateElementMixin>[
      firstService,
    ]) {
      final registration = Registration(instance: element);
      childRegistry.applyRegistration(registration);
    }

    rootRegistry.mergeRegistry(childRegistry);

    await rootRegistry.prepareElements();
    verifyInOrder([
      () => context.prepare(rootRegistry),
      () => secondService.prepare(rootRegistry),
      () => firstService.prepare(rootRegistry),
    ]);
  });

  test('should release in right order after merge registry', () async {
    final rootRegistry = FlateRegistry();
    for (final element in <FlateElementMixin>[
      context,
      secondService,
    ]) {
      final registration = Registration(instance: element);
      rootRegistry.applyRegistration(registration);
    }

    final childRegistry = FlateRegistry();
    for (final element in <FlateElementMixin>[
      firstService,
    ]) {
      final registration = Registration(instance: element);
      childRegistry.applyRegistration(registration);
    }

    rootRegistry.mergeRegistry(childRegistry);

    await rootRegistry.releaseElements();
    verifyInOrder([
      () => firstService.release(),
      () => secondService.release(),
      () => context.release(),
    ]);
  });

  test('should return FlateFragment`s via useElement', () {
    final registry = FlateRegistry();
    final registration = Registration(instance: firstFragment);
    registry.applyRegistration(registration);
    expect(registry.isRegistered<_FirstFragment>(), isTrue);
    expect(registry.useElement<_FirstFragment>(), firstFragment);
  });
}
