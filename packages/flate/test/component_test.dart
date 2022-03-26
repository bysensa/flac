import 'dart:async';

import 'package:flate/flate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide Observable;

void main() {
  testWidgets('should render component', (tester) async {
    mainContext.config = ReactiveConfig.main.clone(
      writePolicy: ReactiveWritePolicy.never,
    );
    final store = TestStore();
    final streamController = StreamController<int>();
    await tester.pumpWidget(
      MaterialApp(
        home: Flate(
          fragments: [TestFragment()],
          loading: const SizedBox.shrink(),
          ready: StreamBuilder<int>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('snapshot=${snapshot.data}');
                return TestComponent(snapshot.data!);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    streamController.add(1);
    await tester.pumpAndSettle();
    streamController.add(2);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
  });
}

class TestStore extends FlateStore {
  TestStore() : super(fragments: [TestFragment()]);
}

class TestComponent extends FlateComponent {
  final int value;

  const TestComponent(this.value, {Key? key}) : super(key: key);

  @override
  TestComponentModel createModel() => TestComponentModel();
}

class TestComponentModel extends FlateComponentModel<TestComponent> {
  late final TestFragment fragment;
  final Observable<String> text = Observable('');

  @override
  void registerIntents(IntentRegistration registration) {
    registration.register<ValueChangeIntent>();
    registration.registerWithCallback(_invokeOnValueChanged);
  }

  @override
  void initModel() {
    super.initModel();
    fragment = useFragment();
    text.value = widget.value.toString();
  }

  @override
  void didUpdateWidget(covariant TestComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    text.value = '${widget.value}';
  }

  void _invokeOnValueChanged(
    ValueChangeIntentForCallback intent, [
    BuildContext? context,
  ]) {
    print(intent);
  }

  @override
  Object? invoke(FlateIntent intent, [BuildContext? context]) {
    print(intent);
    return null;
  }

  @override
  bool onNotification(FlateNotification notification) {
    print(notification);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      print('text=${text.value}');
      return ElevatedButton(
        onPressed: () {
          context.invoke(ValueChangeIntent(value: 1));
          context.invoke(ValueChangeIntentForCallback(value: 1));
          context.dispatch(ValueChangeNotification(value: 1));
        },
        child: Text(text.value),
      );
    });
  }
}

class TestFragment extends FlateFragment {}

class ValueChangeIntent extends FlateIntent {
  final int value;

  ValueChangeIntent({
    required this.value,
  });
}

class ValueChangeIntentForCallback extends FlateIntent {
  final int value;

  ValueChangeIntentForCallback({
    required this.value,
  });
}

class ValueChangeNotification extends FlateNotification {
  final int value;

  ValueChangeNotification({
    required this.value,
  });
}
