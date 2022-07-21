import 'dart:async';
import 'dart:isolate';

import 'common.dart';
import 'log.dart';

part 'engine/processor.dart';

class TelemetryEngine {
  static Future<TelemetryEngine> create(
    StreamSink<Signal> processedMessagesSink,
    Stream<RawSignal> signalsStream,
  ) async {
    final completer = Completer<SendPort>();
    ReceivePort isolateMessagesReceivePort = ReceivePort();
    ReceivePort isolateErrorsReceivePort = ReceivePort();

    final processorMessagesSubscription = isolateMessagesReceivePort.listen(
      (data) {
        if (data is SendPort) {
          SendPort mainToIsolateStream = data;
          if (completer.isCompleted) {
            return;
          }
          completer.complete(mainToIsolateStream);
        } else {
          processedMessagesSink.add(data);
        }
      },
      onError: processedMessagesSink.addError,
      cancelOnError: false,
    );

    final messagesProcessorIsolate = await Isolate.spawn(
      _messagesProcessor,
      isolateMessagesReceivePort.sendPort,
      debugName: 'telemetry-engine-processor',
      errorsAreFatal: false,
      paused: false,
      onError: isolateErrorsReceivePort.sendPort,
    );

    final messagesProcessorPort = await completer.future;

    return TelemetryEngine._(
      processorIsolate: messagesProcessorIsolate,
      processorInboundPort: messagesProcessorPort,
      processorMessagesSubscription: processorMessagesSubscription,
      processedMessagesSink: processedMessagesSink,
      rawSignalsStream: signalsStream,
      isolateErrorsReceivePort: isolateErrorsReceivePort,
      isolateMessagesReceivePort: isolateMessagesReceivePort,
    );
  }

  final Isolate _processorIsolate;
  final SendPort _processorInboundPort;
  final StreamSubscription _processorMessagesSubscription;
  final StreamSink<Signal> _processedMessagesSink;
  final Stream<RawSignal> _rawSignalsStream;
  final ReceivePort _isolateMessagesReceivePort;
  final ReceivePort _isolateErrorsReceivePort;
  late StreamSubscription<RawSignal> _rawSignalsSubscription;

  TelemetryEngine._({
    required Isolate processorIsolate,
    required SendPort processorInboundPort,
    required StreamSubscription processorMessagesSubscription,
    required StreamSink<Signal> processedMessagesSink,
    required Stream<RawSignal> rawSignalsStream,
    required ReceivePort isolateMessagesReceivePort,
    required ReceivePort isolateErrorsReceivePort,
  })  : _processorIsolate = processorIsolate,
        _processorInboundPort = processorInboundPort,
        _processorMessagesSubscription = processorMessagesSubscription,
        _processedMessagesSink = processedMessagesSink,
        _rawSignalsStream = rawSignalsStream,
        _isolateMessagesReceivePort = isolateMessagesReceivePort,
        _isolateErrorsReceivePort = isolateErrorsReceivePort {
    _rawSignalsSubscription = _rawSignalsStream.listen(
      _send,
      onError: _processedMessagesSink.addError,
      cancelOnError: false,
    );
  }

  void _send(RawSignal data) {
    try {
      _processorInboundPort.send(data);
    } catch (err, trace) {
      print('$err \n $trace');
    }
  }

  Future<void> stop() async {
    _send(_ExitSignal());
    _isolateErrorsReceivePort.close();
    _isolateMessagesReceivePort.close();
    await _rawSignalsSubscription.cancel();
    await _processorMessagesSubscription.cancel();
    await _processedMessagesSink.close();
  }
}
