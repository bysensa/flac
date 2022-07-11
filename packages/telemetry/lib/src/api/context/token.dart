part of '../context.dart';

class ContextToken {
  final Context _previousContext;
  final CurrentExecutionUnit _executionUnit;

  const ContextToken._({
    required Context previousContext,
    required CurrentExecutionUnit executionUnit,
  })  : _previousContext = previousContext,
        _executionUnit = executionUnit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContextToken &&
          runtimeType == other.runtimeType &&
          _previousContext == other._previousContext &&
          _executionUnit == other._executionUnit;

  @override
  int get hashCode => _previousContext.hashCode ^ _executionUnit.hashCode;
}
