import 'package:flate/flate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should render', (tester) async {
    const widget = TestWidget();
    await tester.pumpWidget(const MaterialApp(
      home: widget,
      color: Color.fromRGBO(0, 0, 0, 0),
    ));
    await tester.pumpAndSettle();
    expect(find.text('hello'), findsOneWidget);
  });
}

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends FlateComponent<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return const Text('hello');
  }
}
