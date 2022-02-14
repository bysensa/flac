import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class FlacComponent extends Widget {
  const FlacComponent({Key? key}) : super(key: key);

  @override
  @factory
  FlacComponentElement createElement() => FlacComponentElement(this);

  @factory
  ComponentModel createModel();

  @factory
  FlacView<FlacViewModel<FlacComponent, ComponentModel>> createView();

  @factory
  FlacViewModel<FlacComponent, ComponentModel> createViewModel();
}

class FlacComponentElement extends ComponentElement {
  bool _isFirstBuild = true;
  ComponentModel? _model;
  bool _shouldRebuildOnChangeDependencies = true;
  FlacView? _view;
  FlacViewModel? _viewModel;

  FlacComponentElement(FlacComponent widget)
      : _viewModel = widget.createViewModel(),
        _view = widget.createView(),
        _model = widget.createModel(),
        super(widget) {
    assert(_debugTypesAreRight());
    assert(viewModel._element == null);
    viewModel._element = this;
    assert(
      viewModel._component == null,
      'The createState function for $widget returned an old or invalid state '
      'instance: ${viewModel._component}, which is not null, violating the contract '
      'for createState.',
    );
    viewModel
      .._component = component
      .._model = _model;
    view._viewModel = viewModel;
    assert(viewModel._debugLifecycle == _FlacViewModelLifecycle.created);
  }

  FlacComponent get component => widget as FlacComponent;
  FlacViewModel get viewModel => _viewModel!;
  FlacView get view => _view!;

  @override
  void activate() {
    super.activate();
    viewModel.activate();
  }

  @override
  Widget build() => view.build(this);

  @override
  void deactivate() {
    viewModel.deactivate();
    super.deactivate();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<FlacViewModel>(
          'viewModel',
          _viewModel,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<FlacView>(
          'view',
          _view,
          defaultValue: null,
        ),
      );
  }

  @override
  InheritedWidget dependOnInheritedElement(
    Element? ancestor, {
    Object? aspect,
  }) {
    assert(ancestor != null);
    assert(() {
      final Type targetType = ancestor!.widget.runtimeType;
      if (viewModel._debugLifecycle == _FlacViewModelLifecycle.created) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'dependOnInheritedWidgetOfExactType<$targetType>() or dependOnInheritedElement() was called before ${viewModel.runtimeType}.initState() completed.',
          ),
          ErrorDescription(
            'When an inherited widget changes, for example if the value of Theme.of() changes, '
            "its dependent widgets are rebuilt. If the dependent widget's reference to "
            'the inherited widget is in a constructor or an initState() method, '
            'then the rebuilt dependent widget will not reflect the changes in the '
            'inherited widget.',
          ),
          ErrorHint(
            'Typically references to inherited widgets should occur in widget build() methods. Alternatively, '
            'initialization based on inherited widgets can be placed in the didChangeDependencies method, which '
            'is called after initState and whenever the dependencies change thereafter.',
          ),
        ]);
      }
      if (viewModel._debugLifecycle == _FlacViewModelLifecycle.defunct) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'dependOnInheritedWidgetOfExactType<$targetType>() or dependOnInheritedElement() was called after dispose(): $this',
          ),
          ErrorDescription(
            'This error happens if you call dependOnInheritedWidgetOfExactType() on the '
            'BuildContext for a widget that no longer appears in the widget tree '
            '(e.g., whose parent widget no longer includes the widget in its '
            'build). This error can occur when code calls '
            'dependOnInheritedWidgetOfExactType() from a timer or an animation callback.',
          ),
          ErrorHint(
            'The preferred solution is to cancel the timer or stop listening to the '
            'animation in the dispose() callback. Another solution is to check the '
            '"mounted" property of this object before calling '
            'dependOnInheritedWidgetOfExactType() to ensure the object is still in the '
            'tree.',
          ),
          ErrorHint(
            'This error might indicate a memory leak if '
            'dependOnInheritedWidgetOfExactType() is being called because another object '
            'is retaining a reference to this State object after it has been '
            'removed from the tree. To avoid memory leaks, consider breaking the '
            'reference to this object during dispose().',
          ),
        ]);
      }

      return true;
    }());

    return super
        .dependOnInheritedElement(ancestor as InheritedElement, aspect: aspect);
  }

  @override
  void didChangeDependencies() {
    _shouldRebuildOnChangeDependencies = false;
    super.didChangeDependencies();
    _shouldRebuildOnChangeDependencies = true;
  }

  @override
  void markNeedsBuild() {
    if (_shouldRebuildOnChangeDependencies) {
      super.markNeedsBuild();
    } else {
      viewModel.didChangeDependencies();
    }
  }

  @override
  void performRebuild() {
    if (_isFirstBuild) {
      _isFirstBuild = false;
      _firstBuild();
    }
    super.performRebuild();
  }

  @override
  void reassemble() {
    if (_debugShouldReassemble(BindingBase.debugReassembleConfig, widget)) {
      viewModel.reassemble();
    }
    super.reassemble();
  }

  @override
  void unmount() {
    super.unmount();
    viewModel.dispose();
    assert(() {
      if (viewModel._debugLifecycle == _FlacViewModelLifecycle.defunct) {
        return true;
      }
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
          '${viewModel.runtimeType}.dispose failed to call super.dispose.',
        ),
        ErrorDescription(
          'dispose() implementations must always call their superclass dispose() method, to ensure '
          'that all the resources used by the widget are fully released.',
        ),
      ]);
    }());
    // Release resources to reduce the severity of memory leaks caused by
    // defunct, but accidentally retained Elements.
    viewModel
      .._element = null
      .._model = null;
    view._viewModel = null;
    _view = null;
    _viewModel = null;
    _model = null;
  }

  @override
  void update(FlacComponent newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    final FlacComponent oldComponent = viewModel._component!;
    viewModel._component = component;

    final Object? debugCheckForReturnedFuture =
        viewModel.didUpdateComponent(oldComponent) as dynamic;
    assert(() {
      if (debugCheckForReturnedFuture is Future) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            '${viewModel.runtimeType}.didUpdateWidget() returned a Future.',
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

  bool _debugTypesAreRight() {
    final isViewTypesAreRight = view._debugTypesAreRight(viewModel);
    final isViewModelTypesAreRight =
        viewModel._debugTypesAreRight(component, _model!);
    if (isViewModelTypesAreRight && isViewTypesAreRight) {
      return true;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'Invalid generic type declared in ${view.runtimeType} or ${viewModel.runtimeType}',
      ),
      ErrorDescription(
        'View of type ${view.runtimeType} expect ViewModel of type ${view._viewModelType} '
        'but component ${component.runtimeType} provide ViewModel of type ${viewModel.runtimeType} via ${component.runtimeType}.createViewModel.\n'
        'ViewModel of type ${viewModel.runtimeType} expect component of type ${viewModel._componentType} and '
        'model of type ${viewModel._modelType} but component type is ${component.runtimeType} and provided model type is ${_model.runtimeType}.',
      ),
    ]);
  }

  void _firstBuild() {
    assert(viewModel._debugLifecycle == _FlacViewModelLifecycle.created);
    try {
      final Object? debugCheckForReturnedFuture =
          viewModel.initModel() as dynamic;
      assert(() {
        if (debugCheckForReturnedFuture is Future) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
              '${viewModel.runtimeType}.initState() returned a Future.',
            ),
            ErrorDescription(
              'State.initState() must be a void method without an `async` keyword.',
            ),
            ErrorHint(
              'Rather than awaiting on asynchronous work directly inside of initState, '
              'call a separate method to do this work without awaiting it.',
            ),
          ]);
        }

        return true;
      }());
    } finally {
      assert(() {
        viewModel._debugLifecycle = _FlacViewModelLifecycle.initialized;

        return true;
      }());
    }

    try {
      viewModel.didChangeDependencies();
    } finally {
      assert(() {
        viewModel._debugLifecycle = _FlacViewModelLifecycle.ready;

        return true;
      }());
    }
  }
}

// Whether a [DebugReassembleConfig] indicates that an element holding [widget] can skip
// a reassemble.
bool _debugShouldReassemble(DebugReassembleConfig? config, Widget? widget) =>
    config == null ||
    config.widgetName == null ||
    widget?.runtimeType.toString() == config.widgetName;

//+─────────────────────────────────────────────────────────────────────────
//+ MVVM
//+─────────────────────────────────────────────────────────────────────────

/// Marker mixin used to describe MVVM Model
mixin ComponentModel {}

/// This marker class can be useful in MVVM for case
/// when you dont want to use globally registered model
/// When this marker used as generic model parameter in FlacDerivedModel or FlacViewModel
/// this generic parameter will be checked and if it equal to NoModel when
/// instance of NoModel will be provided as model
class NoComponentModel implements ComponentModel {
  const NoComponentModel();
}

enum _FlacViewModelLifecycle {
  /// The [FlacViewModel] object has been created. [FlacViewModel.initModel] is called at this
  /// time.
  created,

  /// The [FlacViewModel.initModel] method has been called but the [State] object is
  /// not yet ready to build. [FlacViewModel.didChangeDependencies] is called at this time.
  initialized,

  /// The [FlacViewModel] object is ready to build and [FlacViewModel.dispose] has not yet been
  /// called.
  ready,

  /// The [FlacViewModel.dispose] method has been called and the [FlacViewModel] object is
  /// no longer able to build.
  defunct,
}

mixin FlacViewModel<C extends FlacComponent, M extends ComponentModel> {
  FlacComponentElement? _element;
  FlacComponent? _component;
  _FlacViewModelLifecycle _debugLifecycle = _FlacViewModelLifecycle.created;

  Type get _modelType => M;

  ComponentModel? _model;
  M get model => _model as M;

  C get component => _component! as C;
  Type get _componentType => C;

  BuildContext get context {
    assert(() {
      if (_element == null) {
        throw FlutterError(
          'This widget has been unmounted, so the State no longer has a context (and should be considered defunct). \n'
          'Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the State is still active.',
        );
      }

      return true;
    }(), '');

    return _element!;
  }

  /// Whether this [FlacViewModel] object is currently in a tree.
  ///
  /// After creating a [FlacViewModel] object and before calling [initModel], the
  /// framework "mounts" the [FlacViewModel] object by associating it with a
  /// [BuildContext]. The [FlacViewModel] object remains mounted until the framework
  /// calls [dispose]
  bool get mounted => _element != null;

  bool _debugTypesAreRight(FlacComponent component, ComponentModel model) =>
      component is C && model is M;

  @mustCallSuper
  void initModel() {
    assert(_debugLifecycle == _FlacViewModelLifecycle.created);
  }

  @mustCallSuper
  void dispose() {
    assert(_debugLifecycle == _FlacViewModelLifecycle.ready);
    assert(() {
      _debugLifecycle = _FlacViewModelLifecycle.defunct;

      return true;
    }());
  }

  @mustCallSuper
  void activate() {}

  @mustCallSuper
  void deactivate() {}

  @mustCallSuper
  void didChangeDependencies() {}

  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      // ..add(ObjectFlagProperty<M>('model', _model, ifNull: 'no model'))
      ..add(ObjectFlagProperty<FlacComponent>(
        'component',
        _component,
        ifNull: 'no component',
      ))
      ..add(ObjectFlagProperty<Element>(
        '_element',
        _element,
        ifNull: 'not mounted',
      ));
  }

  @mustCallSuper
  void reassemble() {}

  @mustCallSuper
  void didUpdateComponent(covariant C oldComponent) {}
}

mixin FlacView<VM extends FlacViewModel> {
  FlacViewModel? _viewModel;
  VM get viewModel => _viewModel as VM;

  Type get _viewModelType => VM;

  bool _debugTypesAreRight(FlacViewModel viewModel) => viewModel is VM;

  Widget build(BuildContext context);
}
