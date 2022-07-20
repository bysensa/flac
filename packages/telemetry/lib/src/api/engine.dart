import 'dart:async';
import 'dart:isolate';

import 'package:telemetry/api.dart';

import 'common.dart';

class TelemetryEngine {
  static Future<TelemetryEngine> create(
    StreamSink<Signal> processedMessagesSink,
    Stream<RawSignal> signalsStream,
  ) async {
    final completer = Completer<SendPort>();
    ReceivePort isolateMessagesReceivePort = ReceivePort();

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
    );

    final messagesProcessorPort = await completer.future;

    return TelemetryEngine._(
      processorIsolate: messagesProcessorIsolate,
      processorInboundPort: messagesProcessorPort,
      processorMessagesSubscription: processorMessagesSubscription,
      processedMessagesSink: processedMessagesSink,
      rawSignalsStream: signalsStream,
    );
  }

  final Isolate _processorIsolate;
  final SendPort _processorInboundPort;
  final StreamSubscription _processorMessagesSubscription;
  final StreamSink<Signal> _processedMessagesSink;
  final Stream<RawSignal> _rawSignalsStream;
  late StreamSubscription<RawSignal> _rawSignalsSubscription;

  TelemetryEngine._({
    required Isolate processorIsolate,
    required SendPort processorInboundPort,
    required StreamSubscription processorMessagesSubscription,
    required StreamSink<Signal> processedMessagesSink,
    required Stream<RawSignal> rawSignalsStream,
  })  : _processorIsolate = processorIsolate,
        _processorInboundPort = processorInboundPort,
        _processorMessagesSubscription = processorMessagesSubscription,
        _processedMessagesSink = processedMessagesSink,
        _rawSignalsStream = rawSignalsStream {
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

  void stop() {
    _rawSignalsSubscription.cancel();
    _processorMessagesSubscription.cancel();
    _processorIsolate.kill();
  }
}

Future<void> _messagesProcessor(SendPort enginePort) async {
  ReceivePort receiver = ReceivePort();
  enginePort.send(receiver.sendPort);

  final messagesIterator = StreamIterator(
    receiver.handleError(enginePort.send),
  );
  while (await messagesIterator.moveNext()) {
    final message = messagesIterator.current;
    if (message is RawLogRecord) {
      _onRawLogSignal(message);
    } else {
      enginePort.send(UnprocessableMessageException(message));
      continue;
    }
  }
}

class UnprocessableMessageException implements Exception {
  final dynamic message;

  UnprocessableMessageException(this.message);

  @override
  String toString() {
    return 'UnprocessableMessageException: cant process message of type ${message.runtimeType}';
  }
}

void _onRawLogSignal(RawLogRecord signal) {}
