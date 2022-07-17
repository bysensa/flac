import 'dart:isolate';

import 'package:stack_trace/stack_trace.dart';
import 'package:telemetry/src/api/common.dart';
import 'package:telemetry/src/api/tracing.dart';
import 'package:telemetry/src/api/tracing/span_id.dart';
import 'package:telemetry/src/api/tracing/trace_id.dart';
import 'package:telemetry/src/api/utils/flatten.dart';

part 'log/impl.dart';
part 'log/level.dart';
part 'log/logger.dart';
part 'log/record.dart';
part 'log/record.builder.dart';
part 'log/log_emitter.dart';
part 'log/log_emitter_provider.dart';

final dynamic trace = _Log.trace();
final dynamic debug = _Log.debug();
final dynamic info = _Log.info();
final dynamic warn = _Log.warn();
final dynamic error = _Log.error();
final dynamic fatal = _Log.fatal();
