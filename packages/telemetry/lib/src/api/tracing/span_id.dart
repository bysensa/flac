import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart' as convert;
import 'dart:collection';

class SpanId {
  static final _rnd = Random.secure();
  static const _len = 8;

  final Uint8List _raw;

  const SpanId._({
    required Uint8List raw,
  }) : _raw = raw;

  factory SpanId.create() {
    return SpanId._(
      raw: Uint8List.fromList(
        List.generate(_len, (index) => _rnd.nextInt(255)),
      ),
    );
  }

  factory SpanId.fromBytes(List<int> bytes) {
    assert(
      bytes.length == _len && bytes.any((element) => element != 0),
      'SpanId should be $_len-byte array with at least one non-zero byte',
    );
    return SpanId._(raw: Uint8List.fromList(bytes));
  }

  factory SpanId.fromHex(String value) {
    final bytes = convert.hex.decode(value);
    return SpanId.fromBytes(bytes);
  }

  List<int> get bytes => UnmodifiableUint8ListView(_raw);

  String get hex => convert.hex.encode(_raw);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SpanId &&
            runtimeType == other.runtimeType &&
            String.fromCharCodes(_raw) == String.fromCharCodes(other._raw);
  }

  @override
  int get hashCode => String.fromCharCodes(_raw).hashCode;

  @override
  String toString() {
    return 'SpanId{$hashCode}';
  }
}
