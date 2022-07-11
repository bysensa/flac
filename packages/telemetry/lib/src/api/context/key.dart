part of '../context.dart';

class ContextKey {
  final String? name;

  const ContextKey._({
    required this.name,
  });

  @override
  String toString() {
    return 'ContextKey{name: $name}';
  }
}
