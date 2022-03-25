part of '../core.dart';

/// Class used to indicate in which context commit is performed.
///
/// If commit performed inside another commit then instance of this class will be
/// present in zone values.
class _CommitGuard {
  const _CommitGuard();
}

/// The class is a fragment of the application state.
///
/// In cases when some part of the application state is not shared, then it should be placed in a fragment.
/// The application can consist of one or more fragments. Each fragment in its implementation can use
/// all registered parts and services, but must not use other fragments. Parts and services can be obtained
/// in a fragment by calling methods [usePart] and [useService].
abstract class FlateFragment with FlateElement {
  final Lock _mutationLock = Lock(reentrant: false);

  /// Return instance of [FlatePart] registered with type [P]
  ///
  /// If instance for type [P] is not registered in [FlateStore] then [StateError] will be thrown.
  /// If [FlateFragment] is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  P usePart<P>() {
    if (isMounted) {
      return _store!._usePart<P>();
    }
    throw StateError('Fragment is not mounted');
  }

  /// Return instance of [FlateService] registered with type [S]
  ///
  /// If instance for type [S] is not registered in [FlateStore] then [StateError] will be thrown.
  /// If [FlateFragment] is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  S useService<S>() {
    if (isMounted) {
      return _store!._useService<S>();
    }
    throw StateError('Fragment of type $runtimeType is not mounted');
  }

  C useContext<C>() {
    if (isMounted) {
      return _store!.useContext<C>();
    }
    throw StateError('Fragment of type $runtimeType is not mounted');
  }

  /// Perform synchronous change of state.
  ///
  /// Use this method when changes in state should be synchronous and in strict order.
  /// It is valid to perform commits in nested order which mean next operation
  /// will not performed until nested done.
  ///
  /// Example:
  /// ```dart
  /// class SomeFragment extends Fragment {
  ///
  ///   Future<void> performWithNested() {
  ///     final StringBuffer output = StringBuffer();
  ///     await commit(() async {
  ///       output.write('u1');
  ///       commit(() async {
  ///         output.write('n1');
  ///       });
  ///       output.write('u2');
  ///       store.commit(() async {
  ///         output.write('n2');
  ///         store.commit(() async {
  ///           output.write('in1');
  ///         });
  ///         output.write('n3');
  ///       });
  ///       output.write('u3');
  ///     });
  ///     assert(output.toString() == 'u1n1u2n2in1n3u3');
  ///   }
  /// }
  /// ```
  @visibleForTesting
  @protected
  Future<void> commit(
    Mutation mutation, {
    String? debugName,
  }) async {
    final maybeGuard = Zone.current[_CommitGuard];
    if (maybeGuard != null) {
      await runMutation(mutation, debugName: debugName);
    } else {
      await runZoned(
        () async {
          return await _mutationLock.synchronized(() async {
            await runMutation(mutation, debugName: debugName);
          });
        },
        zoneValues: {
          _CommitGuard: const _CommitGuard(),
        },
      );
    }
  }

  /// This method execute provide [mutation]
  ///
  /// This method used in [commit] to execute provided callback. You can override this method
  /// to declare custom logic which for example can be evaluated before and after
  /// execution of [mutation]
  @mustCallSuper
  @protected
  FutureOr runMutation(
    Mutation mutation, {
    String? debugName,
  }) async {
    await mutation();
  }
}
