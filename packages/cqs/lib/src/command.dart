import 'dart:async';

abstract class Command {
  FutureOr<void> call();
}
