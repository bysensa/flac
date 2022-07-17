import 'package:telemetry/src/api/common.dart';

typedef Attributes = Set<Attribute>;
typedef Attribute = MapEntry<String, dynamic>;
typedef StringAttribute = MapEntry<String, String>;
typedef BoolAttribute = MapEntry<String, bool>;
typedef DoubleAttribute = MapEntry<String, double>;
typedef IntAttribute = MapEntry<String, int>;
typedef StringArrayAttribute = MapEntry<String, List<String>>;
typedef BoolArrayAttribute = MapEntry<String, List<bool>>;
typedef DoubleArrayAttribute = MapEntry<String, List<double>>;
typedef IntArrayAttribute = MapEntry<String, List<int>>;

extension DynamicToAttribute on dynamic {
  Attribute attr(String name) {
    if (name.isEmpty) {
      return InvalidAttribute(
        name,
        this,
        reason: 'Name of attribute should not be empty',
      );
    }
    if (this is String) {
      return StringAttribute(name, this);
    } else if (this is bool) {
      return BoolAttribute(name, this);
    } else if (this is double) {
      return DoubleAttribute(name, this);
    } else if (this is int) {
      return IntAttribute(name, this);
    } else if (this is List<String>) {
      return StringArrayAttribute(name, this);
    } else if (this is List<bool>) {
      return BoolArrayAttribute(name, this);
    } else if (this is List<double>) {
      return DoubleArrayAttribute(name, this);
    } else if (this is List<int>) {
      return IntArrayAttribute(name, this);
    } else {
      return InvalidAttribute(
        name,
        this,
        reason: 'Unsupported attribute type: $runtimeType',
      );
    }
  }
}
//
// extension StringToAttribute on String {
//   StringAttribute attribute(String name) => StringAttribute(name, this);
// }
//
// extension BoolToAttribute on bool {
//   BoolAttribute attribute(String name) => BoolAttribute(name, this);
// }
//
// extension DoubleToAttribute on double {
//   DoubleAttribute attribute(String name) => DoubleAttribute(name, this);
// }
//
// extension IntToAttribute on int {
//   IntAttribute attribute(String name) => IntAttribute(name, this);
// }
//
// extension StringListToAttribute on List<String> {
//   StringArrayAttribute attribute(String name) =>
//       StringArrayAttribute(name, this);
// }
//
// extension BoolListToAttribute on List<bool> {
//   BoolArrayAttribute attribute(String name) => BoolArrayAttribute(name, this);
// }
//
// extension DoubleListToAttribute on List<double> {
//   DoubleArrayAttribute attribute(String name) =>
//       DoubleArrayAttribute(name, this);
// }
//
// extension IntListToAttribute on List<int> {
//   IntArrayAttribute attribute(String name) => IntArrayAttribute(name, this);
// }

class InvalidAttribute implements Attribute {
  @override
  final String key;

  @override
  final dynamic value;

  final String reason;

  InvalidAttribute(this.key, this.value, {required this.reason});
}

class AttributeName {
  static final RegExp _symbolRegexp = RegExp(r'^\w+\("(.*)"\)');
  final String name;

  AttributeName(this.name);

  factory AttributeName.fromSymbol(Symbol symbol) {
    try {
      final name = _symbolRegexp.firstMatch(symbol.toString())!.group(1)!;
      return AttributeName(name);
    } catch (err) {
      return InvalidAttributeName();
    }
  }

  factory AttributeName.fromString(String value) {
    return value.isEmpty ? InvalidAttributeName() : AttributeName(value);
  }

  factory AttributeName.fromDynamic(dynamic name) {}

  @override
  String toString() {
    return name;
  }
}

class InvalidAttributeName implements AttributeName {
  @override
  String get name => '';
}
