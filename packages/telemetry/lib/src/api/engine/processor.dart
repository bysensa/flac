part of '../engine.dart';

class _ExitSignal extends RawSignal {}

Future<void> _messagesProcessor(SendPort enginePort) async {
  ReceivePort receiver = ReceivePort();
  enginePort.send(receiver.sendPort);

  final messagesIterator = StreamIterator(
    receiver.handleError(enginePort.send),
  );

  while (await messagesIterator.moveNext()) {
    final message = messagesIterator.current;
    if (message is RawSignal) {
      print('receive exit signal');
      break;
    }
    if (message is RawLogRecord) {
      enginePort.send(LogRecord.fromRaw(message));
    } else {
      Zone.current.handleUncaughtError(
        UnprocessableMessageException(message),
        StackTrace.current,
      );
      continue;
    }
  }
  await messagesIterator.cancel();
  receiver.close();
  Isolate.exit();
}

class UnprocessableMessageException implements Exception {
  final dynamic message;

  UnprocessableMessageException(this.message);

  @override
  String toString() {
    return 'UnprocessableMessageException: cant process message of type ${message.runtimeType}';
  }
}
