import 'package:telemetry/api.dart';
import 'package:test/test.dart';

final dynamic debug = Logger.create(
  withLevel: LogLevel.debug,
  withName: 'test',
  emitterProvider: Telemetry(),
);
final dynamic info = Logger.create(
  withLevel: LogLevel.info,
  withName: 'test',
  emitterProvider: Telemetry(),
);
final dynamic warn = Logger.create(
  withLevel: LogLevel.warn,
  withName: 'test',
  emitterProvider: Telemetry(),
);
final dynamic error = Logger.create(
  withLevel: LogLevel.error,
  withName: 'test',
  emitterProvider: Telemetry(),
);
final dynamic fatal = Telemetry().logger(
  withLevel: LogLevel.fatal,
  withName: 'test',
);

void main() {
  test('should emit log record', () async {
    debug('hello');
    info('hello');
    warn('hello');
    error('hello');
    fatal('hello');
    await Future.delayed(Duration(seconds: 1));
  });
}
