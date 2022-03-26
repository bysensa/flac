part of '../core.dart';

mixin FlateActivity {}

abstract class FlateIntent extends Intent with FlateActivity {}

abstract class FlateNotification extends Notification with FlateActivity {}

extension BuildContextExtension on BuildContext {
  VoidCallback? handler<T extends FlateIntent>(T intent) =>
      Actions.handler(this, intent);

  Action<T> findAction<T extends FlateIntent>(T intent) =>
      Actions.find(this, intent: intent);

  Action<T>? maybeFindAction<T extends FlateIntent>(T intent) =>
      Actions.maybeFind(this, intent: intent);

  Object? invoke<T extends FlateIntent>(T intent) =>
      Actions.invoke(this, intent);

  Object? maybeInvoke<T extends FlateIntent>(T intent) =>
      Actions.maybeInvoke<FlateIntent>(this, intent);

  void dispatch(FlateNotification notification) => notification.dispatch(this);
}
