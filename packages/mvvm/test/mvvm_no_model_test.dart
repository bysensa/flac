import 'package:flac_mvvm/flac_mvvm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class SmallComponent extends FlacComponent {
  const SmallComponent({Key? key}) : super(key: key);

  @override
  FlacView<FlacViewModel<FlacComponent, ComponentModel>> createView() =>
      SmallView();

  @override
  FlacViewModel<FlacComponent, ComponentModel> createViewModel() =>
      SmallViewModel();

  @override
  ComponentModel createModel() => const NoComponentModel();
}

class SmallViewModel with FlacViewModel<SmallComponent, NoComponentModel> {
  @override
  void initModel() {
    super.initModel();
    expect(model, isA<NoComponentModel>());
  }
}

class SmallView with FlacView<SmallViewModel> {
  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: Scaffold(
          body: Text('small'),
        ),
      );
}

void main() {
  testWidgets('should render SmallComponent', (tester) async {
    await tester.pumpWidget(const SmallComponent());
    await tester.pumpAndSettle();
    expect(find.text('small'), findsOneWidget);
  });
}
