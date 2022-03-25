part of '../core.dart';

typedef FragmentBuilder = FlateFragment Function(FlateStore);
typedef FragmentProvider = F Function<F extends FlateFragment>();
typedef Mutation = FutureOr<void> Function();
typedef Transform<S, T> = T Function(S state);
typedef Compute<T> = T Function();
mixin AsAlias {}
