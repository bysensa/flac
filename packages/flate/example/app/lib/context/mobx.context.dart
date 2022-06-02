import 'package:flate/flate.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:mobx/mobx.dart';

mixin MobxContext on FlateContext {
  @override
  Future<void> prepare() async {
    await super.prepare();
    mainContext.spy((event) => logMessage('$event'));
    mainContext.config = mainContext.config.clone(
      isSpyEnabled: true,
    );
  }
}
