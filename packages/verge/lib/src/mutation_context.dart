part of 'state.dart';

typedef VisitedPath = String;
typedef FieldKey = String;
typedef FieldValue = dynamic;

class MutationContext {
  final State state;
  final Set<VisitedPath> _visitedPaths = {};
  Map<FieldKey, FieldValue>? _changes;

  MutationContext._(this.state);

  MutationContext.fromState(
    this.state,
  );

  /// returns all visited paths during read or write operations
  Set<VisitedPath> get visitedPaths => Set.unmodifiable(_visitedPaths);

  dynamic operator [](FieldKey field) {
    _visitedPaths.add(field);

    return _changes != null ? _changes![field] : state[field];
  }

  void operator []=(FieldKey field, FieldValue value) {
    // TODO(s-a-sen): maybe we should not check equality because value can be mutable or value has uncommon equality evaluation
    // we should get current value for equality check
    final currentValue = _changes != null ? _changes![field] : state[field];

    if (currentValue == value) {
      return;
    }

    _visitedPaths.add(field);
    _changes ??= {...state._readState};
    _changes![field] = value;
  }

  State mergeChanges(CommitContext commitContext) {
    if (_visitedPaths.isEmpty && _changes == null) {
      return state;
    }
    final internalState = _changes ?? state._readState;

    final stateMerge = DeepStateMerge(commitContext);
    Map<FieldKey, FieldValue>? mutations;
    for (final path in _visitedPaths) {
      final value = internalState[path];
      final newValue = stateMerge.merge(value);
      mutations ??= {};
      mutations[path] = newValue;
      // TODO: fix problem here
      // if (newValue != _state._readState[path]) {
      //   mutations ??= {};
      //   mutations[path] = newValue;
      // }
    }
    if (mutations == null) {
      return state;
    }
    final newState = state.newState;
    newState._readState.addAll({...internalState, ...mutations});

    return newState;
  }
}
