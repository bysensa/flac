import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class Query<T> {
  FutureOr<T> call();
}

abstract class ReactiveQuery<T> extends Stream<T>
    implements ValueListenable<T>, Query<T> {
  late final _subject = BehaviorSubject<T>(
    onCancel: onCancel,
    onListen: onListen,
  );

  bool get isClosed => _subject.isClosed;

  void _add(T value) {
    _subject.add(value);
  }

  void _addError(Object error, [StackTrace? trace]) {
    _subject.addError(error, trace);
  }

  ReactiveQuerySink<T> get sink => ReactiveQuerySink(query: this);

  /// called when the first listener appear
  @protected
  @mustCallSuper
  void onListen() {}

  /// called when the last listener disappear
  @protected
  @mustCallSuper
  void onCancel() {}

  /// Stream API
  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _subject.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  // Listenable API
  final _listeners = <VoidCallback, StreamSubscription<T>>{};

  @override
  T get value => _subject.value;

  bool get hasListeners => _listeners.isNotEmpty;

  @override
  void addListener(VoidCallback listener) {
    _listeners.putIfAbsent(
      listener,
      () => _subject.listen((value) => listener()),
    );
  }

  @override
  void removeListener(VoidCallback listener) {
    final removedListenerSubscription = _listeners.remove(listener);
    removedListenerSubscription?.cancel();
  }

  @override
  FutureOr<T> call() async {
    try {
      final callResult = await onCall();
      _add(callResult);
      return callResult;
    } catch (err, trace) {
      _addError(err, trace);
      rethrow;
    }
  }

  FutureOr<T> onCall();
}

class ReactiveQuerySink<T> {
  final ReactiveQuery<T> _query;

  const ReactiveQuerySink({
    required ReactiveQuery<T> query,
  }) : _query = query;

  FutureOr<void> add(T value) {
    if (!_query.isClosed) {
      _query._add(value);
    }
  }

  void addError(Object error, [StackTrace? trace]) {
    if (!_query.isClosed) {
      _query._addError(error, trace);
    }
  }
}

mixin QueryParameters<T> {
  late T _parameters = initialParameters();

  T get parameters => _parameters;

  set parameters(T newParameters) {
    if (_parameters == newParameters) {
      return;
    }
    _parameters = newParameters;
    didUpdateParameters();
  }

  /// should return initial parameters
  T initialParameters();

  /// called after parameters change
  void didUpdateParameters();
}
