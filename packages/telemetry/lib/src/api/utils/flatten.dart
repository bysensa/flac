extension FlattenMap on Map {
  /// Returns flattened Map
  ///
  /// This function takes Map as input and transforms hierarchical map to
  /// single level map where hierarchical keys represented in form of "key.nestedKey"
  /// If map contains nested [Iterable] when such value wil be treated as list
  /// and each element will be represented by its index ie "key.nestedKey.0"
  Map<String, dynamic> flatten({maxDepth = 32}) {
    Iterable<MapEntry<String, dynamic>> step(
      String key,
      dynamic value,
      int maxDepth,
    ) sync* {
      if (maxDepth == 0) {
        yield MapEntry(key, value.toString());
        return;
      } else if (value is Map) {
        yield* value
            .flatten(maxDepth: maxDepth - 1)
            .entries
            .map((e) => MapEntry('$key.${e.key}', e.value));
        return;
      } else if (value is Iterable) {
        yield* value
            .toList()
            .asMap()
            .flatten(maxDepth: maxDepth - 1)
            .entries
            .map((e) => MapEntry('$key.${e.key}', e.value));
        return;
      } else {
        yield MapEntry(key, value);
        return;
      }
    }

    assert(
      maxDepth >= 0,
      'maxDepth cant be negative value 0 will be used as maxDepth',
    );
    final correctMaxDepth = maxDepth < 0 ? 0 : maxDepth;

    return Map.fromEntries(
      entries.expand(
        (element) => step(
          element.key.toString(),
          element.value,
          correctMaxDepth,
        ),
      ),
    );
  }
}
