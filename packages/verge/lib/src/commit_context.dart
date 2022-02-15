import 'state.dart';

class CommitContext<S extends State> {
  final S _state;
  final Expando<MutationContext> _stateMutation = Expando();

  CommitContext._(this._state);

  CommitContext.forState(S state) : _state = state;

  /// store [_MutationContext] for provided [State]
  void addMutationContext(MutationContext mutationContext) {
    _stateMutation[mutationContext.state] = mutationContext;
  }

  S mergeChanges() {
    final mutationContext = _stateMutation[_state];
    if (mutationContext == null) {
      return _state;
    }
    final newState = mutationContext.mergeChanges(this);

    return newState as S;
  }

  /// returns [_MutationContext] for provided [State]
  MutationContext? mutationContextFor(State state) {
    return _stateMutation[state];
  }
}
