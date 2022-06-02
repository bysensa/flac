import 'package:flate/flate.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:package_info_plus/package_info_plus.dart';

mixin PackageInfoContext on FlateContext {
  late final PackageInfo packageInfo;

  @override
  Future<void> prepare() async {
    await super.prepare();
    packageInfo = await PackageInfo.fromPlatform();
    logMessage(
      'package: ${packageInfo.version}(${packageInfo.buildNumber})',
      extras: {
        'appName': packageInfo.appName,
        'packageName': packageInfo.packageName,
        'buildSignature': packageInfo.buildSignature,
      },
    );
  }
}
