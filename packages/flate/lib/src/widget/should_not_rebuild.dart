import 'package:flutter/widgets.dart';

mixin ShouldNotRebuildMixin on Widget {
  @protected
  bool shouldNotRebuild(covariant Widget newWidget) => false;
}

mixin ShouldNotRebuildElementMixin on ComponentElement {
  bool _shouldNotRebuild = false;
  Widget? _oldChildWidget;

  @override
  void update(covariant StatelessWidget newWidget) {
    if (widget is ShouldNotRebuildMixin) {
      _shouldNotRebuild =
          (widget as ShouldNotRebuildMixin).shouldNotRebuild(newWidget);
    }
    super.update(newWidget);
  }

  @override
  void deactivate() {
    _dropCachedWidget();
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    _dropCachedWidget();
    super.didChangeDependencies();
  }

  @override
  void reassemble() {
    _dropCachedWidget();
    super.reassemble();
  }

  void _dropCachedWidget() {
    _oldChildWidget = null;
    _shouldNotRebuild = false;
  }

  @override
  void unmount() {
    _dropCachedWidget();
    super.unmount();
  }

  Widget _maybeBuild(ValueGetter<Widget> builder) {
    if (_oldChildWidget == null || !_shouldNotRebuild) {
      _oldChildWidget = builder();
      _shouldNotRebuild = false;
    }

    return _oldChildWidget!;
  }
}

abstract class StatelessShouldNotRebuildWidget extends StatelessWidget
    with ShouldNotRebuildMixin {
  const StatelessShouldNotRebuildWidget({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() => StatelessShouldNotRebuildElement(this);
}

class StatelessShouldNotRebuildElement extends StatelessElement
    with ShouldNotRebuildElementMixin {
  StatelessShouldNotRebuildElement(
    StatelessShouldNotRebuildWidget widget,
  ) : super(widget);

  @override
  Widget build() {
    return _maybeBuild(super.build);
  }
}
