import 'package:flate/flate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FirstIntent extends Intent {}

class SecondIntent extends Intent {}

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> with FlateComponentMixin {
  var processedIntentCount = 0;
  var firstIntentHandled = false;
  var secondIntentHandled = false;

  late ComponentAction<FirstIntent> _actionFirstIntent;
  late ComponentAction<SecondIntent> _actionSecondIntent;

  @override
  void initState() {
    super.initState();
    _actionFirstIntent = action(onFirstIntent, isEnabledPredicate: (_) {
      return firstIntentHandled = true;
    });
    _actionSecondIntent = action(onSecondIntent, isEnabledPredicate: (_) {
      return secondIntentHandled = true;
    });
  }

  void onSecondIntent(SecondIntent intent, [BuildContext? context]) {
    processedIntentCount += 1;
  }

  void onFirstIntent(FirstIntent intent, [BuildContext? context]) {
    processedIntentCount += 1;
  }

  @override
  Widget build(BuildContext context) {
    return FlateComponentActions(
      reduceRebuilds: true,
      component: this,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    context.maybeInvoke(FirstIntent());
                    context.maybeInvoke(SecondIntent());
                  },
                  child: const Text('tap'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('should build', (tester) async {
    await tester.pumpWidget(const TestWidget());
    await tester.pumpAndSettle();
  });

  testWidgets('should handle intents', (tester) async {
    await tester.pumpWidget(const TestWidget());
    await tester.pumpAndSettle();
    final btn = find.byType(ElevatedButton);
    await tester.tap(btn);
    await tester.pumpAndSettle();
    final state = tester.state(find.byType(TestWidget));
    expect((state as _TestWidgetState).processedIntentCount, 2);
    expect((state).firstIntentHandled, isTrue);
    expect((state).secondIntentHandled, isTrue);
  });
}
