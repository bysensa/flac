import 'package:flutter/widgets.dart';

mixin ShouldNotRebuildMixin on StatelessWidget {
  @protected
  bool shouldNotRebuild(Widget newWidget);

  @override
  StatelessElement createElement() => StatelessShouldRebuildElement(this);
}

class StatelessShouldRebuildElement extends StatelessElement {
  bool shouldNotRebuild = false;
  Widget? oldChildWidget;

  StatelessShouldRebuildElement(StatelessWidget widget) : super(widget);

  @override
  void update(covariant StatelessWidget newWidget) {
    if (widget is ShouldNotRebuildMixin) {
      shouldNotRebuild =
          (widget as ShouldNotRebuildMixin).shouldNotRebuild(newWidget);
    }
    super.update(newWidget);
  }

  @override
  void deactivate() {
    _clear();
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    _clear();
    super.didChangeDependencies();
  }

  @override
  void reassemble() {
    _clear();
    super.reassemble();
  }

  void _clear() {
    oldChildWidget = null;
    shouldNotRebuild = false;
  }

  @override
  void unmount() {
    _clear();
    super.unmount();
  }

  @override
  Widget build() {
    if (oldChildWidget == null || !shouldNotRebuild) {
      oldChildWidget = super.build();
      shouldNotRebuild = false;
    }

    return oldChildWidget!;
  }
}
