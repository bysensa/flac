import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:flate/flate.dart';
import 'package:lumberdash/lumberdash.dart';

mixin LoggingContext on FlateContext {
  @override
  Future<void> prepare() async {
    await super.prepare();
    putLumberdashToWork(withClients: [ColorizeLumberdash()]);
  }
}
