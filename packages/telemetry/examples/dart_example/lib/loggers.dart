import 'package:telemetry/telemetry.dart';

final dynamic trace = Logger.create(
  withName: 'example',
  withLevel: LogLevel.trace,
  emitterProvider: Telemetry(),
);
final dynamic debug = Logger.create(
  withName: 'example',
  withLevel: LogLevel.debug,
  emitterProvider: Telemetry(),
);
final dynamic info = Logger.create(
  withName: 'example',
  withLevel: LogLevel.info,
  emitterProvider: Telemetry(),
);
final dynamic warn = Logger.create(
  withName: 'example',
  withLevel: LogLevel.warn,
  emitterProvider: Telemetry(),
);
final dynamic error = Logger.create(
  withName: 'example',
  withLevel: LogLevel.error,
  emitterProvider: Telemetry(),
);
final dynamic fatal = Logger.create(
  withName: 'example',
  withLevel: LogLevel.fatal,
  emitterProvider: Telemetry(),
);
