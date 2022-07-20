library api;

import 'dart:async';

import 'package:async/async.dart';
import 'package:telemetry/src/api/common.dart';
import 'package:telemetry/src/api/engine.dart';

import 'api.dart';

export 'src/api/context.dart';
export 'src/api/log.dart';

class Telemetry {
  static Telemetry? _instance;

  final ResultFuture<TelemetryEngine> _engine;
  final StreamController<RawSignal> _rawSignalsStreamController;
  final StreamController<Signal> _signalsStreamController;

  Telemetry._(
    this._engine,
    this._rawSignalsStreamController,
    this._signalsStreamController,
  );

  factory Telemetry() {
    if (_instance != null) {
      return _instance!;
    }
    final rawSignalsStreamController = StreamController<RawSignal>();
    final signalsStreamController = StreamController<Signal>();
    final engineFuture = TelemetryEngine.create(
      signalsStreamController.sink,
      rawSignalsStreamController.stream,
    );
    return _instance ??= Telemetry._(
      ResultFuture(engineFuture),
      rawSignalsStreamController,
      signalsStreamController,
    );
  }

  Sink<RawSignal> get sink {
    return _rawSignalsStreamController.sink;
  }

  Future<void> close() async {
    _instance = null;
    if (!_engine.isComplete) {
      await _engine;
    }
    final maybeEngine = _engine.result!;
    if (maybeEngine.isError) {
      Zone.current.handleUncaughtError(
        maybeEngine.asError!.error,
        maybeEngine.asError!.stackTrace,
      );
    } else {
      final engine = maybeEngine.asValue!.value;
      engine.stop();
    }
    _rawSignalsStreamController.close();
    _signalsStreamController.close();
  }

  static Future<void> closeInstance() async {
    if (_instance == null) {
      return;
    }
    await _instance!.close();
  }
}
