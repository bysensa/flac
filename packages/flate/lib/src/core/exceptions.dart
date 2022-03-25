part of '../core.dart';

class InitializationException implements Exception {
  final dynamic exception;
  final StackTrace trace;

  const InitializationException({
    required this.exception,
    required this.trace,
  });

  @override
  String toString() {
    return 'InitializationException: $exception';
  }
}

class DisposeException implements Exception {
  final dynamic exception;
  final StackTrace trace;

  const DisposeException({
    required this.exception,
    required this.trace,
  });

  @override
  String toString() {
    return 'DisposeException: $exception';
  }
}
