import 'package:flac_mvvm/flac_mvvm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestModel with ComponentModel {
  final int count = 1;
}

class TestComponent extends FlacComponent {
  final int count;

  const TestComponent({
    required this.count,
    Key? key,
  }) : super(key: key);

  @override
  FlacView createView() => TestView();

  @override
  FlacViewModel createViewModel() => TestViewModel();

  @override
  ComponentModel createModel() => TestModel();
}

class TestViewModel with FlacViewModel<TestComponent, TestModel> {
  int get count => model.count + 1;
}

class TestView with FlacView<TestViewModel> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Text('MVVM${viewModel.count}'),
      );
}

void main() {
  testWidgets('should render component', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TestComponent(
          count: 1,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('MVVM2'), findsOneWidget);
  });
}
