part of '../core.dart';

typedef RegistryBuilder = FlateRegistry Function();

class FlateConfiguration {
  final RegistryBuilder registryBuilder;
  static final Lock _commitLock = Lock(reentrant: false);
  static CommitRunner _commitRunner = runCommit;

  const FlateConfiguration({
    this.registryBuilder = FlateRegistry.new,
  });

  /// Change function used to execute callback provided in [commit] function
  ///
  /// Initially [commitRunner] value is [runCommit]
  static set commitRunner(CommitRunner newCommitRunner) {
    _commitRunner = newCommitRunner;
  }
}
