import 'package:flutter/widgets.dart';

import '../core.dart';
import 'container.dart';

abstract class FlateComponent extends Widget {
  const FlateComponent({Key? key}) : super(key: key);

  @protected
  @factory
  FlateComponentModel createModel();

  /// Used in the method [FlateComponentElement.update] to determine whether an element
  /// should rebuild its widget tree.
  ///
  /// If method returns true then widget tree will not rebuild during [FlateComponentElement.build].
  /// Else if method returns false then element will rebuild its widget tree.
  @protected
  bool shouldNotRebuild(Widget newWidget) => this == newWidget;

  @override
  Element createElement() => FlateComponentElement(this);
}

abstract class FlateComponentModel<T extends FlateComponent>
    extends ContextAction<FlateIntent> with IntentRegistrationProvider {
  T? _widget;
  FlateComponentElement? _element;

  /// The current configuration.
  ///
  /// A [FlateComponentModel] object's configuration is the corresponding [FlateComponent]
  /// instance. This property is initialized by the library before calling
  /// [initModel]. If the parent updates this location in the tree to a new
  /// widget with the same [runtimeType] and [Widget.key] as the current
  /// configuration, the framework will update this property to refer to the new
  /// widget and then call [didUpdateWidget], passing the old configuration as
  /// an argument.
  T get widget => _widget!;

  /// Whether this [FlateComponentModel] object is currently in a tree.
  ///
  /// After creating a [FlateComponentModel] object and before calling [initModel], the
  /// library "mounts" the [FlateComponentModel] object by associating it with a
  /// [BuildContext]. The [FlateComponentModel] object remains mounted until the framework
  /// calls [dispose], after which time the framework will never ask the [FlateComponentModel]
  /// object to [build] again.
  bool get mounted => _element != null;

  /// Verifies that the [FlateComponentModel] that was created is one that expects to be
  /// created for that particular [Widget].
  bool _debugTypesAreRight(Widget widget) => widget is T;

  /// Provide [FlateFragment] of type [F] from [FlateStore] provided by [Flate]
  F useFragment<F extends FlateFragment>() {
    if (!mounted) {
      throw StateError('Method useFragment<$F>() was called after dispose()');
    }

    return Flate.useFragment<F>(_element!);
  }

  /// Called when this object is inserted into the tree.
  ///
  /// The framework will call this method exactly once for each [FlateComponentModel] object
  /// it creates.
  ///
  /// Override this method to perform initialization that depends on the
  /// on the widget used to configure this object (i.e., [widget]).
  ///
  /// If a [FlateComponentModel]'s [build] method depends on an object that can itself
  /// change state, for example a [ChangeNotifier] or [Stream], or some
  /// other object to which one can subscribe to receive notifications, then
  /// be sure to subscribe and unsubscribe properly in [initModel],
  /// [didUpdateWidget], and [dispose].
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.initModel()`.
  @protected
  @mustCallSuper
  void initModel() {}

  /// Called whenever the widget configuration changes.
  ///
  /// If the parent widget rebuilds and request that this location in the tree
  /// update to display a new widget with the same [runtimeType] and
  /// [Widget.key], the framework will update the [widget] property of this
  /// [FlateComponentModel] object to refer to the new widget and then call this method
  /// with the previous widget as an argument.
  ///
  /// Override this method to respond when the [widget] changes (e.g., to start
  /// implicit animations).
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.didUpdateWidget(oldWidget)`.
  @mustCallSuper
  @protected
  void didUpdateWidget(covariant T oldWidget) {}

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  ///
  /// In most cases, after a [FlateComponentModel] object has been deactivated, it is _not_
  /// reinserted into the tree, and its [dispose] method will be called to
  /// signal that it is ready to be garbage collected.
  ///
  /// In some cases, however, after a [FlateComponentModel] object has been deactivated, the
  /// framework will reinsert it into another part of the tree (e.g., if the
  /// subtree containing this [FlateComponentModel] object is grafted from one location in
  /// the tree to another due to the use of a [GlobalKey]). If that happens,
  /// the framework will call [activate] to give the [FlateComponentModel] object a chance to
  /// reacquire any resources that it released in [deactivate]. It will then
  /// also call [build] to give the object a chance to adapt to its new
  /// location in the tree. If the framework does reinsert this subtree, it
  /// will do so before the end of the animation frame in which the subtree was
  /// removed from the tree. For this reason, [FlateComponentModel] objects can defer
  /// releasing most resources until the framework calls their [dispose] method.
  ///
  /// The framework does not call this method the first time a [FlateComponentModel] object
  /// is inserted into the tree. Instead, the framework calls [initModel] in
  /// that situation.
  ///
  /// Implementations of this method should start with a call to the inherited
  /// method, as in `super.activate()`.
  @protected
  @mustCallSuper
  void activate() {}

  /// Called when this object is removed from the tree.
  ///
  /// The framework calls this method whenever it removes this [FlateComponentModel] object
  /// from the tree. In some cases, the framework will reinsert the [FlateComponentModel]
  /// object into another part of the tree (e.g., if the subtree containing this
  /// [FlateComponentModel] object is grafted from one location in the tree to another due to
  /// the use of a [GlobalKey]). If that happens, the framework will call
  /// [activate] to give the [FlateComponentModel] object a chance to reacquire any resources
  /// that it released in [deactivate]. It will then also call [build] to give
  /// the [FlateComponentModel] object a chance to adapt to its new location in the tree. If
  /// the framework does reinsert this subtree, it will do so before the end of
  /// the animation frame in which the subtree was removed from the tree. For
  /// this reason, [FlateComponentModel] objects can defer releasing most resources until the
  /// framework calls their [dispose] method.
  ///
  /// Subclasses should override this method to clean up any links between
  /// this object and other elements in the tree (e.g. if you have provided an
  /// ancestor with a pointer to a descendant's [RenderObject]).
  ///
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.deactivate()`.
  @protected
  @mustCallSuper
  void deactivate() {}

  /// Called when this object is removed from the tree permanently.
  ///
  /// The framework calls this method when this [FlateComponentModel] object will never
  /// build again. After the framework calls [dispose], the [FlateComponentModel] object is
  /// considered unmounted and the [mounted] property is false. It is an error
  /// to call instance that can cause rebuild at this point. This stage of the lifecycle is terminal:
  /// there is no way to remount a [FlateComponentModel] object that has been disposed.
  ///
  /// Subclasses should override this method to release any resources retained
  /// by this object (e.g., stop any active animations).
  ///
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.dispose()`.
  @protected
  @mustCallSuper
  void dispose() {}

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method in a number of different situations. For
  /// example:
  ///
  ///  * After calling [initModel].
  ///  * After calling [didUpdateWidget].
  ///  * After calling [deactivate] and then reinserting the [FlateComponentModel] object into
  ///    the tree at another location.
  ///
  /// This method can potentially be called in every frame and should not have
  /// any side effects beyond building a widget. Also widget returned by this method
  /// will be cached. By default during widget update this method will be called if
  /// oldWidget != newWidget. To control rebuilds you can override
  /// [FlateComponent.shouldNotRebuild] method.
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

  /// Instance used to prepare [Action]s for [FlateComponentElement].
  IntentRegistrator? _intentRegistration;

  /// if value is true then [build] method return [_oldChildWidget] else new
  /// [_oldChildWidget] value will be build during [build] call.
  bool _shouldNotRebuild = false;

  /// Contains latest widget built by [build] method
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
    _intentRegistration = IntentRegistrator(componentModel: model)..prepare();
  }

  /// Returns [FlateComponentModel] related to this element.
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

/// Widget used to configure utility widgets to support some [FlateComponentModel] functionality.
class _ComponentWrapper extends StatelessWidget {
  final IntentRegistrator? registration;
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
