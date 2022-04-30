import 'package:flate/flate.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('stateless widget should rebuild every time', (tester) async {});
}

class StatelessTestWidget extends StatelessWidget with ReduceRebuildMixin {
  final int value;

  const StatelessTestWidget({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
