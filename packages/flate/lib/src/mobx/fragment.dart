import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:meta/meta.dart';

import '../core.dart';

/// Subtype of [FlateFragment] designed to work with Mobx state management
abstract class MobxFragment extends FlateFragment {
  @override
  @protected
  FutureOr runMutation(
    Mutation mutation, {
    String? debugName,
  }) async {
    final action = ActionController(name: debugName ?? runtimeType.toString());
    final runInfo = action.startAction();
    try {
      super.runMutation(mutation, debugName: debugName);
    } finally {
      action.endAction(runInfo);
    }
  }
}
