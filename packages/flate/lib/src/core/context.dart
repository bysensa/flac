part of '../core.dart';

/// The class is used to store, initialize and dispose information about current Environment
///
/// Potentially, this class can contain information about the current configuration of the application,
/// instances of global services necessary for the operation of services and other entities necessary
/// for the correct operation of the application.
abstract class FlateContext extends FlateElement {}

/// Default instance of [FlateContext] used when context instance is not provided.
class DefaultContext extends FlateContext {}
