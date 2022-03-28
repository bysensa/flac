part of '../core.dart';

/// The class is a fragment of the application state.
///
/// In cases when some part of the application state is not shared, then it should be placed in a fragment.
/// The application can consist of one or more fragments. Each fragment in its implementation can use
/// all registered parts and services, but must not use other fragments. Parts and services can be obtained
/// in a fragment by calling methods [usePart] and [useService].
abstract class FlateFragment extends FlateElement
    with _PartResolver, _ServiceResolver, _ContextResolver {}
