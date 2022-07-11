import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart' as convert;

class TraceId {
  static final _rnd = Random.secure();
  static const _len = 16;

  final Uint8List _raw;

  const TraceId._({
    required Uint8List raw,
  }) : _raw = raw;

  factory TraceId.create() {
    return TraceId._(
      raw: Uint8List.fromList(
        List.generate(_len, (index) => _rnd.nextInt(255)),
      ),
    );
  }

  factory TraceId.fromBytes(List<int> bytes) {
    assert(
      bytes.length == _len && bytes.any((element) => element != 0),
      'TraceId should be $_len-byte array with at least one non-zero byte',
    );
    return TraceId._(raw: Uint8List.fromList(bytes));
  }

  factory TraceId.fromHex(String value) {
    final bytes = convert.hex.decode(value);
    return TraceId.fromBytes(bytes);
  }

  List<int> get bytes => UnmodifiableUint8ListView(_raw);

  String get hex => convert.hex.encode(_raw);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TraceId &&
          runtimeType == other.runtimeType &&
          String.fromCharCodes(_raw) == String.fromCharCodes(other._raw);

  @override
  int get hashCode => String.fromCharCodes(_raw).hashCode;

  @override
  String toString() {
    return 'TraceId{$hashCode}';
  }
}
