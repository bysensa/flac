import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:synchronized/synchronized.dart';

part 'core/commit.dart';
part 'core/element.dart';
part 'core/exceptions.dart';
part 'core/registration.dart';
part 'core/registry.dart';
part 'core/store.dart';
part 'core/configuration.dart';

/// Default instance of [FlateContext] used when context instance is not provided.
class DefaultFlateContext extends FlateContext {}

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
abstract class FlateService with FlateElementMixin, FlateServiceMixin {}

/// The class is a fragment of the application state.
///
/// In cases when some part of the application state is not shared, then it should be placed in a fragment.
/// The application can consist of one or more fragments. Each fragment in its implementation can use
/// all registered parts and services, but must not use other fragments. Parts and services can be obtained
/// in a fragment by calling methods [usePart] and [useService].
abstract class FlateFragment with FlateElementMixin, FlateFragmentMixin {}
