part of '../core.dart';

/// This mixin should be used in declaring classes that interact with external resources
/// such as a database, files or file system, etc.
///
/// Example:
/// ```dart
/// class MyLocationQuery extends FlateService {
///   late final HttpClient _client;
///
///   @override
///   FutureOr<void> initialize() async {
///     super.initialize();
///     _client = HttpClient();
///   }
///
///   @override
///   FutureOr<void> dispose() async {
///     _client.close();
///     super.dispose();
///   }
///
///   Future<Map<String, dynamic>> myIpLocation() async {
///     final uri = Uri.parse('http://ip-api.com/json/');
///     final req = await _client.getUrl(uri);
///     final res = await req.close();
///     final data = await res.transform(utf8.decoder).join();
///
///     return jsonDecode(data);
///   }
/// }
/// ```
///
abstract class FlateService extends FlateElement {
  C useContext<C>() {
    if (isMounted) {
      return _store!.useContext<C>();
    }
    throw StateError('Service of type $runtimeType is not mounted');
  }
}
