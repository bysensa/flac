part of '../core.dart';

class ActivationException implements Exception {
  final dynamic exception;
  final StackTrace trace;

  const ActivationException({
    required this.exception,
    required this.trace,
  });

  @override
  String toString() {
    return 'InitializationException: $exception';
  }
}

class DeactivationException implements Exception {
  final dynamic exception;
  final StackTrace trace;

  const DeactivationException({
    required this.exception,
    required this.trace,
  });

  @override
  String toString() {
    return 'DisposeException: $exception';
  }
}
