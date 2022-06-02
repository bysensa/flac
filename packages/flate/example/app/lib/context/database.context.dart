import 'package:cbl/cbl.dart';
import 'package:flate/flate.dart';

mixin DatabaseContext on FlateContext {
  late final Database database;

  @override
  Future<void> prepare() async {
    await super.prepare();
    database = await Database.openAsync(
      '_db',
      DatabaseConfiguration(directory: './'),
    );
  }

  @override
  Future<void> release() async {
    await super.release();
    await database.close();
  }
}
