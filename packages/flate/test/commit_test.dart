import 'package:flate/flate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should run nested commits in correct order', () async {
    final StringBuffer output = StringBuffer();
    await commit(() async {
      output.write('u1');
      commit(() async {
        output.write('n1');
      });
      output.write('u2');
      commit(() async {
        output.write('n2');
        commit(() async {
          output.write('in1');
        });
        output.write('n3');
      });
      output.write('u3');
    });
    expect(output.toString(), 'u1n1u2n2in1n3u3');
  });

  test('commit can return callback result', () async {
    bool callback() => true;
    expect(await commit(callback), isTrue);
  });

  test('callback can be sync', () async {
    void callback() {}
    await commit(callback);
  });

  test('callback can be async', () async {
    Future<void> callback() async {}
    await commit(callback);
  });
}
