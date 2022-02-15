import 'package:flutter_test/flutter_test.dart';
import 'package:flac_verge/flac_verge.dart';

void main() {
  test('adds one to input values', () {
    var state = SomeState(0);
    final value = state.value;
    final _value = state._privateValue;
    final valueText = state.valueText;
    print(valueText);

    expect(state, SomeState(0));
    expect(state, isNot(SomeState(1)));
    expect(state, SomeState(0, innerValue: 0.5));

    var sw = Stopwatch()..start();
    state = testCommit<SomeState>(state, (state) {
      state.innerSome.innerValue = 1.0;
      return state;
    });
    sw.stop();
    print('commit duration: ${sw.elapsedMicroseconds}');

    expect(state, SomeState(0, innerValue: 1.0));

    sw = Stopwatch()..start();
    state = testCommit<SomeState>(state, (state) {
      state.value += 1;
      return state;
    });
    sw.stop();
    print('commit duration: ${sw.elapsedMicroseconds}');

    expect(state, SomeState(1, innerValue: 1.0));
  });

  test('should merge modifications', () {
    final state = SomeState(0);
    final value = state.value;
    final _value = state._privateValue;
    final valueText = state.valueText;

    var sw = Stopwatch()..start();
    final newState = testCommit<SomeState>(state, (state) {
      state.innerSome.innerValue = 1.0;
      state.value += 1;
      return state;
    });
    sw.stop();
    print('commit duration: ${sw.elapsedMicroseconds}');

    print(newState);
    expect(newState, isNot(state));
    expect(newState.value, 1);
    expect(newState.innerSome.innerValue, 1.0);
  });
}

/// Some
mixin Some {
  int? _privateValue;
  late int value;
  late InnerSomeState innerSome;
}

mixin FullSome implements Some {
  String get valueText {
    return value.toString();
  }
}

class SomeState extends State with FullSome {
  SomeState(int value, {double innerValue = 0.5}) {
    initialize(() {
      this.value = value;
      innerSome = InnerSomeState(innerValue);
    });
  }

  @override
  State get newState => SomeState(value);
}

mixin InnerSome {
  late double innerValue;
  late List<InnerItemState> inners;
}

class InnerSomeState extends State implements InnerSome {
  InnerSomeState(double value) {
    initialize(() {
      innerValue = value;
      inners = [InnerItemState()];
    });
  }

  @override
  State get newState => InnerSomeState(innerValue);
}

mixin InnerItem {
  late String text;
}

class InnerItemState extends State implements InnerItem {
  InnerItemState() {
    initialize(() {
      text = "hello";
    });
  }

  @override
  State get newState => InnerItemState();
}
