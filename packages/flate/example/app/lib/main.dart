import 'package:app/core.dart';
import 'package:app/screens.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flate/flate.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'context.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CouchbaseLiteFlutter.init();
  runApp(
    Flate(
      context: AppContext(),
      loading: const SplashScreen(),
      ready: const App(),
    ),
  );
}
