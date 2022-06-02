import 'package:app/context/database.context.dart';
import 'package:app/context/http.context.dart';
import 'package:app/context/location.context.dart';
import 'package:app/context/logging.context.dart';
import 'package:app/context/mobx.context.dart';
import 'package:app/context/package_info.context.dart';
import 'package:flate/flate.dart';

class AppContext extends FlateContext
    with
        LoggingContext,
        LocationContext,
        DatabaseContext,
        PackageInfoContext,
        MobxContext,
        HttpContext {}
