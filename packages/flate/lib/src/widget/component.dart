import 'package:flutter/widgets.dart';

import '../core.dart';
import 'container.dart';

abstract class FlateComponent extends Widget {
  const FlateComponent({Key? key}) : super(key: key);

  @protected
  @factory
  FlateComponentModel createModel();

  @protected
  bool shouldNotRebuild(Widget newWidget) => this == newWidget;

  @override
  Element createElement() => FlateComponentElement(this);
}

abstract class FlateComponentModel<T extends FlateComponent>
    extends ContextAction<FlateIntent> with IntentRegistrationProvider {
  T? _widget;
  FlateComponentElement? _element;

  T get widget => _widget!;
  bool get mounted => _element != null;

  bool _debugTypesAreRight(Widget widget) => widget is T;

  F useFragment<F extends FlateFragment>() {
    if (!mounted) {
      throw StateError('Method useFragment<$F>() was called after dispose()');
    }

    return Flate.useFragment<F>(_element!);
  }

  @protected
  @mustCallSuper
  void initModel() {}

  @mustCallSuper
  @protected
  void didUpdateWidget(covariant T oldWidget) {}

  @protected
  @mustCallSuper
  void activate() {}

  @protected
  @mustCallSuper
  void deactivate() {}

  @protected
  @mustCallSuper
  void dispose() {}

  @protected
  Widget build(BuildContext context);

  @override
  Object? invoke(FlateIntent intent, [BuildContext? context]) {
    return null;
  }

  bool onNotification(FlateNotification notification) => false;
}

class FlateComponentElement extends ComponentElement {
  FlateComponentModel<FlateComponent>? _model;
  bool _isFirstBuild = true;
  IntentRegistration? _intentRegistration;

  // rebuild specific variables
  bool _shouldNotRebuild = false;
  Widget? _oldChildWidget;

  FlateComponentElement(FlateComponent widget)
      : _model = widget.createModel(),
        super(widget) {
    assert(() {
      if (!model._debugTypesAreRight(widget)) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'VergeWidget.createModel must return a subtype of Model<${widget.runtimeType}>',
          ),
          ErrorDescription(
            'The createModel function for ${widget.runtimeType} returned a model '
            'of type ${model.runtimeType}, which is not a subtype of '
            'Model<${widget.runtimeType}>, violating the contract for createModel.',
          ),
        ]);
      }
      return true;
    }());
    assert(model._element == null);
    model._element = this;
    assert(
      model._widget == null,
      'The createState function for $widget returned an old or invalid state '
      'instance: ${model._widget}, which is not null, violating the contract '
      'for createState.',
    );
    model._widget = widget;
    _intentRegistration = IntentRegistration(componentModel: model)..prepare();
  }

  FlateComponentModel<FlateComponent> get model => _model!;

  @override
  FlateComponent get widget => super.widget as FlateComponent;

  @override
  Widget build() {
    if (_oldChildWidget == null || !_shouldNotRebuild) {
      _shouldNotRebuild = false;
      _oldChildWidget = _ComponentWrapper(
        builder: model.build,
        notificationHandler: model.onNotification,
        registration: _intentRegistration,
      );
    }

    return _oldChildWidget!;
  }

  void _clear() {
    _oldChildWidget = null;
    _shouldNotRebuild = false;
  }

  @mustCallSuper
  @override
  void activate() {
    super.activate();
    model.activate();
    // Since the State could have observed the deactivate() and thus disposed of
    // resources allocated in the build method, we have to rebuild the widget
    // so that its State can reallocate its resources.
    // assert(_lifecycleState == _ElementLifecycle.active); // otherwise markNeedsBuild is a no-op
    markNeedsBuild();
  }

  @mustCallSuper
  @override
  void performRebuild() {
    if (_isFirstBuild) {
      _isFirstBuild = false;
      _firstBuild();
    }
    super.performRebuild();
  }

  void _firstBuild() {
    final Object? debugCheckForReturnedFuture = model.initModel() as dynamic;
    assert(() {
      if (debugCheckForReturnedFuture is Future) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            '${model.runtimeType}.initModel() returned a Future.',
          ),
          ErrorDescription(
            'Model.initModel() must be a void method without an `async` keyword.',
          ),
          ErrorHint(
            'Rather than awaiting on asynchronous work directly inside of initModel, '
            'call a separate method to do this work without awaiting it.',
          ),
        ]);
      }

      return true;
    }());
  }

  @override
  void update(FlateComponent newWidget) {
    _shouldNotRebuild = widget.shouldNotRebuild(newWidget);
    super.update(newWidget);
    assert(widget == newWidget);
    final FlateComponent oldWidget = model._widget!;
    model._widget = widget;

    if (!_shouldNotRebuild) {
      final Object? debugCheckForReturnedFuture =
          model.didUpdateWidget(oldWidget) as dynamic;
      assert(() {
        if (debugCheckForReturnedFuture is Future) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
              '${model.runtimeType}.didUpdateWidget() returned a Future.',
            ),
            ErrorDescription(
              'State.didUpdateWidget() must be a void method without an `async` keyword.',
            ),
            ErrorHint(
              'Rather than awaiting on asynchronous work directly inside of didUpdateWidget, '
              'call a separate method to do this work without awaiting it.',
            ),
          ]);
        }

        return true;
      }());
    }
    rebuild();
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

  @mustCallSuper
  @override
  void deactivate() {
    _clear();
    model.deactivate();
    super.deactivate();
  }

  @mustCallSuper
  @override
  void unmount() {
    super.unmount();
    _clear();
    model.dispose();
    model._element = null;
    // Release resources to reduce the severity of memory leaks caused by
    // defunct, but accidentally retained Elements.
    _model = null;
  }
}

class _ComponentWrapper extends StatelessWidget {
  final IntentRegistration? registration;
  final bool Function(FlateNotification) notificationHandler;
  final WidgetBuilder builder;

  const _ComponentWrapper({
    required this.notificationHandler,
    required this.builder,
    this.registration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Actions(
        actions: registration ?? {},
        child: NotificationListener<FlateNotification>(
          onNotification: notificationHandler,
          child: Builder(builder: builder),
        ),
      );
}
