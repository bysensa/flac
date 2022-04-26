part of '../core.dart';

typedef CommitCallback<T> = FutureOr<T> Function();
typedef CommitRunner<T> = FutureOr<T> Function(
  CommitCallback<T> callback, {
  String? debugName,
});

/// Mixin used to override some commit behaviour
mixin FlateCommitOverrides {
  static final Lock _commitLock = Lock(reentrant: false);
  static CommitRunner _commitRunner = runCommit;

  /// Change function used to execute callback provided in [commit] function
  ///
  /// Initially [commitRunner] value is [runCommit]
  static set commitRunner(CommitRunner newCommitRunner) {
    _commitRunner = newCommitRunner;
  }
}

/// Class used to indicate in which context commit is performed.
///
/// If commit performed inside another commit then instance of this class will be
/// present in zone values.
class _CommitGuard {
  const _CommitGuard();
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
Future<T> commit<T>(
  CommitCallback<T> callback, {
  String? debugName,
}) async {
  final maybeGuard = Zone.current[_CommitGuard];

  return maybeGuard != null
      ? await FlateCommitOverrides._commitRunner(callback, debugName: debugName)
      : await runZoned(
          () async {
            return await FlateCommitOverrides._commitLock.synchronized(
              () async {
                return await FlateCommitOverrides._commitRunner(
                  callback,
                  debugName: debugName,
                );
              },
            );
          },
          zoneValues: {
            _CommitGuard: const _CommitGuard(),
          },
        );
}

/// This method execute provide [callback]
///
/// This method used in [commit] to execute provided callback. You can override this method
/// to declare custom logic which for example can be evaluated before and after
/// execution of [callback]
@mustCallSuper
@protected
FutureOr<T> runCommit<T>(
  CommitCallback<T> callback, {
  String? debugName,
}) async {
  return await callback();
}
