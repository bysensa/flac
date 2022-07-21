import 'dart:developer';

import 'package:flate/flate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should render', (tester) async {
    final counter = Counter('invocation', 'counts invocations by TestIntent');
    final widget = TestWidget(counter: counter);
    await tester.pumpWidget(MaterialApp(
      home: widget,
      color: const Color.fromRGBO(0, 0, 0, 0),
    ));
    await tester.pumpAndSettle();
    expect(find.text('hello'), findsOneWidget);
    expect(counter.value, 0);
  });

  testWidgets('should emit intent', (tester) async {
    final counter = Counter('invocation', 'counts invocations by TestIntent');
    final widget = TestWidget(counter: counter);
    await tester.pumpWidget(MaterialApp(
      home: widget,
      color: const Color.fromRGBO(0, 0, 0, 0),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(counter.value, 1);
  });

  testWidgets('should emit intent', (tester) async {
    final counter = Counter('invocation', 'counts invocations by TestIntent');
    final widget = TestWidget(counter: counter);
    await tester.pumpWidget(MaterialApp(
      home: widget,
      color: const Color.fromRGBO(0, 0, 0, 0),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(counter.value, 1);
  });
}

class TestWidget extends StatefulWidget {
  final Counter counter;

  const TestWidget({Key? key, required this.counter}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class TestIntent extends Intent {}

class _TestWidgetState extends FlateComponent<TestWidget> {
  late ComponentAction _actionTestIntent;

  @override
  void initState() {
    super.initState();
    _actionTestIntent = action<TestIntent>(_onTestIntent);
    assert(_actionTestIntent.intentType == TestIntent);
    removeAction(_actionTestIntent);
    addAction(_actionTestIntent);
  }

  void _onTestIntent(TestIntent intent, [BuildContext? context]) {
    widget.counter.value += 1;
    _actionTestIntent.disable();
  }

  @override
  Widget build(BuildContext context) {
    return FlateComponentActions(
      component: this,
      child: Column(
        children: [
          const Text('hello'),
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: context.handler(TestIntent()),
                child: const Text('tap'),
              );
            },
          )
        ],
      ),
    );
  }
}
