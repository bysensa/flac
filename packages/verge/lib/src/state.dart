import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import 'commit_context.dart';

part 'mutation_context.dart';

// -----------------------------------------------------------------------------
// Typedefs
// -----------------------------------------------------------------------------

typedef VoidCallback = void Function();

// -----------------------------------------------------------------------------
// Symbol Extension
// -----------------------------------------------------------------------------
final symbolNameRegExp = RegExp(r'Symbol\("([a-zA-Z0-9_$]*)[=]?"\)');

extension SymbolExt on Symbol {
  String? get name {
    final symbolAsString = toString();

    return symbolNameRegExp.firstMatch(symbolAsString)?[1];
  }
}

// -----------------------------------------------------------------------------
// Verge Error
// -----------------------------------------------------------------------------

class VergeError extends StateError {
  VergeError(String message) : super(message);
}

// -----------------------------------------------------------------------------
// State
// -----------------------------------------------------------------------------
class State {
  bool _initialized = false;
  Map<String, dynamic> _readState = {};

  MutationContext get _newMutationContext => MutationContext.fromState(this);
  @override
  int get hashCode => const DeepCollectionEquality().hash(_readState);
  State get newState;

  // -----------------------------------------------------------------------------
  // Equality
  // -----------------------------------------------------------------------------
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! State && runtimeType != other.runtimeType) {
      return false;
    }
    const equality = DeepCollectionEquality();

    return equality.equals(_readState, (other as State)._readState);
  }

  dynamic operator [](String field) => _readState[field];

  dynamic _getValue(String field) {
    final commitContext = Zone.current[CommitContext];
    if (commitContext is CommitContext) {
      var mutationContext = _mutationContextFromCommit(commitContext);

      return mutationContext[field];
    } else {
      return _readState[field];
    }
  }

  void initialize(VoidCallback initialize) {
    if (_initialized) {
      return;
    }
    final commitContext = CommitContext.forState(this);
    try {
      runZoned(
        () {
          initialize();
        },
        zoneValues: {
          CommitContext: commitContext,
        },
      );
    } on Exception catch (err, trace) {
      Zone.current.handleUncaughtError(err, trace);
    } finally {
      final writeState = commitContext.mutationContextFor(this)?._changes;
      if (writeState != null) {
        _readState = writeState;
      }
      _initialized = true;
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (!invocation.isAccessor) {
      return;
    }
    final field = invocation.memberName.name!;
    if (invocation.isSetter) {
      final value = invocation.positionalArguments.first;
      _setValue(field, value);
    } else {
      return _getValue(field);
    }
  }

  MutationContext _mutationContextFromCommit(CommitContext commitContext) {
    var mutationContext = commitContext.mutationContextFor(this);
    if (mutationContext == null) {
      mutationContext = _newMutationContext;
      commitContext.addMutationContext(mutationContext);
    }

    return mutationContext;
  }

  void _setValue(String field, dynamic value) {
    final commitContext = Zone.current[CommitContext];
    if (commitContext == null) {
      throw VergeError(
        'Change in state should be performed in context of commit',
      );
    }
    final mutationContext = _mutationContextFromCommit(commitContext);
    mutationContext[field] = value;
  }

  // -----------------------------------------------------------------------------
  // String representation
  // -----------------------------------------------------------------------------
  @override
  String toString() => '$_readState';
}

// -----------------------------------------------------------------------------
// State Merge
// -----------------------------------------------------------------------------

/// This class perform deep merge for changes in state.
/// For merge this class use Copy-On-Write behaviour.
/// This mean that collection or state will be copied if it contains changes
class DeepStateMerge {
  final CommitContext _commitContext;

  const DeepStateMerge(this._commitContext);

  dynamic merge(dynamic instance) {
    if (instance == null) return instance;
    if (instance is State) return _mergeState(instance);
    if (instance is List) return _mergeList(instance);
    if (instance is Set) return _mergeSet(instance);
    if (instance is Map) return _mergeMap(instance);
    return instance;
  }

  State _mergeState<T extends State>(T instance) {
    final mutationContext = _commitContext.mutationContextFor(instance);
    if (mutationContext == null) {
      return instance;
    }
    return mutationContext.mergeChanges(_commitContext);
  }

  Map<K, V> _mergeMap<K, V>(Map<K, V> instance) {
    Map<K, V>? modifications;
    for (final entry in instance.entries) {
      final maybeNew = merge(entry.value);
      if (maybeNew != entry.value) {
        modifications ??= {};
        modifications[entry.key] = maybeNew;
      }
    }
    if (modifications == null) {
      return instance;
    }
    return {...instance, ...modifications};
  }

  Set<V> _mergeSet<V>(Set<V> instance) {
    Set<V>? modifications;
    for (final entry in instance) {
      final maybeNew = merge(entry);
      if (maybeNew != entry) {
        modifications ??= {...instance};
        modifications.remove(entry);
        modifications.add(maybeNew);
      }
    }
    if (modifications == null) {
      return instance;
    }
    return modifications;
  }

  List<V> _mergeList<V>(List<V> instance) {
    List<V>? modifications;
    for (final entry in instance.asMap().entries) {
      final maybeNew = merge(entry.value);
      if (maybeNew != entry.value) {
        modifications ??= [...instance];
        modifications[entry.key] = maybeNew;
      }
    }
    if (modifications == null) {
      return instance;
    }
    return modifications;
  }
}

// -----------------------------------------------------------------------------
// Commit
// -----------------------------------------------------------------------------
typedef StateMutation<S extends State> = S Function(S);

@visibleForTesting
S testCommit<S extends State>(S state, StateMutation<S> mutation) {
  var currentState = state;
  final commitContext = CommitContext.forState(currentState);
  runZoned(
    () {
      try {
        mutation(currentState);
        currentState = commitContext.mergeChanges();
      } catch (err, trace) {
        Zone.current.handleUncaughtError(err, trace);
      }
    },
    zoneValues: {
      CommitContext: commitContext,
    },
  );

  return currentState;
}

// -----------------------------------------------------------------------------
// Commit Context
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Mutation Context
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Store
// -----------------------------------------------------------------------------

abstract class Activity {}

abstract class Store<T extends State> extends BlocBase<T> {
  final _activityController = StreamController<Activity>.broadcast();
  final Lock _storeLock = Lock();

  Store(T initialState) : super(initialState);

  Stream<Activity> get activity => _activityController.stream;

  @override
  Future<void> close() async {
    await _storeLock.synchronized(() async {
      await _activityController.close();
      await super.close();
    });
  }

  /// Perform synchronized state mutation and return mutated state.
  /// This method should guarantee that commits apply sequentially
  Future<T> commit(T Function(T) mutation) {
    return _storeLock.synchronized(() async {
      var currentState = state;
      final commitContext = CommitContext.forState(currentState);

      return runZoned(
        () {
          try {
            final mutatedState = mutation(currentState);
            final nextState = DeepStateMerge(commitContext).merge(mutatedState);
            emit(nextState);

            return nextState;
          } catch (err, trace) {
            addError(err, trace);
            rethrow;
          }
        },
        zoneValues: {
          CommitContext: commitContext,
        },
      );
    });
  }

  /// send subclass of the activity through the activity stream
  void send(covariant Activity activity) {
    _activityController.add(activity);
  }
}
