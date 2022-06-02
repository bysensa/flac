import 'package:dio/dio.dart';
import 'package:flate/flate.dart';

mixin HttpContext on FlateContext {
  late final Dio httpClient;

  @override
  Future<void> prepare() async {
    await super.prepare();
    final options = BaseOptions();
    httpClient = Dio(options);
  }

  @override
  Future<void> release() async {
    httpClient.close();
    await super.release();
  }
}
