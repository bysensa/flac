import 'package:stack_trace/stack_trace.dart';
import 'package:telemetry/src/api/common.dart';

part 'log/impl.dart';
part 'log/level.dart';
part 'log/logger.dart';

final dynamic trace = _Log.trace();
final dynamic debug = _Log.debug();
final dynamic info = _Log.info();
final dynamic warn = _Log.warn();
final dynamic error = _Log.error();
final dynamic fatal = _Log.fatal();
