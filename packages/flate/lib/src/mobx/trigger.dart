import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

class Trigger {
  final Atom _trigger;

  Trigger({
    String? triggerName,
  }) : _trigger = Atom(name: triggerName ?? 'trigger');

  @mustCallSuper
  DateTime get triggeredAt {
    _trigger.reportRead();

    return DateTime.now();
  }

  @mustCallSuper
  void trigger() {
    _trigger.reportChanged();
  }
}
