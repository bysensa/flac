part of '../core.dart';

abstract class FlateIntent extends Intent {}

extension BuildContextIntentExtension on BuildContext {
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
}
