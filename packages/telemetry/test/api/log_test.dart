import 'package:telemetry/api.dart';
import 'package:test/test.dart';

final logger =
    LogEmitterProvider.logEmitter(name: 'test').logger(level: LogLevel.debug);
final dynamicLogger = LogEmitterProvider.logEmitter(name: 'test')
    .dynamicLogger(level: LogLevel.trace);

void main() {
  test('should emit log record', () async {
    logger.log(['hello']);
    dynamicLogger('hello');
    await Future.delayed(Duration(seconds: 1));
  });
}
