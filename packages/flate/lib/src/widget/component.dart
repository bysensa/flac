import 'package:flate/flate.dart';
import 'package:flutter/widgets.dart';

import '../core.dart';
import 'action.dart';
import 'container.dart';

mixin FlateComponentMixin<T extends StatefulWidget> on State<T> {
  late IntentRegistrator _intentRegistration;
  late _ComponentInternalAction _internalAction;

  /// Provide [FlateFragment] of type [F] from [FlateStore] provided by [Flate]
  F useFragment<F extends FlateFragment>() {
    if (!mounted) {
      throw StateError(
        'Method useFragment<$F>() was called on unmounted element',
      );
    }

    return Flate.useFragment<F>(context);
  }

  @override
  void initState() {
    super.initState();
    _internalAction = _ComponentInternalAction(
      consumesKeyDelegate: actionsConsumesKey,
      invokeDelegate: invoke,
      isEnabledDelegate: canHandleIntent,
      isActionEnabledDelegate: () => canHandleIntents,
    );
    _intentRegistration = IntentRegistrator(
      intentRegistrationFn: registerIntents,
      delegatedAction: _internalAction,
    )..prepare();
  }

  bool actionsConsumesKey(Intent intent) => false;

  Object? invoke(covariant Intent intent, [BuildContext? context]) {
    return null;
  }

  bool get canHandleIntents => true;

  bool canHandleIntent(Intent intent) => true;

  void registerIntents(IntentRegistration registration) {}

  void notifyActions() {
    _internalAction.notifyListeners();
  }
}

class _ComponentInternalAction extends ContextAction<Intent> {
  final Object? Function(
    Intent intent, [
    BuildContext? context,
  ]) invokeDelegate;

  final bool Function(Intent intent) isEnabledDelegate;
  final bool Function(Intent intent) consumesKeyDelegate;
  final bool Function() isActionEnabledDelegate;

  _ComponentInternalAction({
    required this.invokeDelegate,
    required this.isEnabledDelegate,
    required this.consumesKeyDelegate,
    required this.isActionEnabledDelegate,
  });

  @override
  bool get isActionEnabled => isActionEnabledDelegate();

  @override
  Object? invoke(Intent intent, [BuildContext? context]) {
    return invokeDelegate(intent, context);
  }

  @override
  bool isEnabled(Intent intent) => isEnabledDelegate(intent);

  @override
  bool consumesKey(Intent intent) => consumesKeyDelegate(intent);

  void notifyListeners() {
    notifyActionListeners();
  }
}

class FlateComponentActions extends StatelessReduceRebuildWidget {
  final FlateComponentMixin component;
  final ActionDispatcher? actionDispatcher;
  final Widget child;
  final bool reduceRebuilds;

  const FlateComponentActions({
    required this.component,
    required this.child,
    this.actionDispatcher,
    this.reduceRebuilds = false,
    Key? key,
  }) : super(key: key);

  @override
  bool shouldNotRebuild(covariant FlateComponentActions newWidget) {
    return newWidget.reduceRebuilds &&
        component == newWidget.component &&
        actionDispatcher == newWidget.actionDispatcher &&
        key == newWidget.key;
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: component._intentRegistration,
      dispatcher: actionDispatcher,
      child: child,
    );
  }
}
