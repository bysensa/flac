import 'package:telemetry/src/api/common.dart';
import 'package:test/test.dart';

main() {
  test('should correctly create name from symbol', () {
    expect(AttributeName.fromSymbol(#foo).name, 'foo');
  });
}
