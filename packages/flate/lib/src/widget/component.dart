import 'package:flutter/widgets.dart';

import '../core.dart';
import 'container.dart';

abstract class FlateComponent extends Widget {
  const FlateComponent({Key? key}) : super(key: key);

  @protected
  @factory
  FlateComponentModel createModel();

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
  Object? invoke(FlateIntent intent, [BuildContext? context]) {}
}

class FlateComponentElement extends ComponentElement {
  FlateComponentModel<FlateComponent>? _model;
  bool _isFirstBuild = true;
  IntentRegistration? _intentRegistration;

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
  Widget build() => Actions(
        actions: _intentRegistration ?? {},
        child: Builder(builder: model.build),
      );

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
    super.update(newWidget);
    assert(widget == newWidget);
    final FlateComponent oldWidget = model._widget!;
    model._widget = widget;

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

  @mustCallSuper
  @override
  void deactivate() {
    model.deactivate();
    super.deactivate();
  }

  @mustCallSuper
  @override
  void unmount() {
    super.unmount();
    model.dispose();
    model._element = null;
    // Release resources to reduce the severity of memory leaks caused by
    // defunct, but accidentally retained Elements.
    _model = null;
  }
}