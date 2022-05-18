import 'package:flutter/widgets.dart';
import 'package:synchronized/synchronized.dart';

import '../core.dart';

class Flate extends StatefulWidget {
  final FlateContext? context;
  final List<FlateFragment> fragments;
  final List<FlatePart> parts;
  final List<FlateService> services;
  final Widget loading;
  final Widget ready;
  final Duration viewSwitchDuration;

  const Flate({
    required this.ready,
    required this.loading,
    this.viewSwitchDuration = const Duration(milliseconds: 500),
    this.fragments = const [],
    this.parts = const [],
    this.services = const [],
    this.context,
    Key? key,
  }) : super(key: key);

  @override
  State<Flate> createState() => _FlateState();

  static F useFragment<F extends FlateFragment>(BuildContext context) =>
      _FlateScope.of(context)._store.useFragment<F>();
}

class _FlateState extends State<Flate> {
  final Lock _initializationLock = Lock();
  late final FlateStore _store;
  late Widget _currentView;

  @override
  void initState() {
    super.initState();
    _currentView = widget.loading;
    _store = FlateStore(
      context: widget.context,
      fragments: widget.fragments,
      parts: widget.parts,
      services: widget.services,
    )..addListener(_rebuild);
    _initializationLock.synchronized(_store.prepare);
  }

  void _rebuild() {
    setState(() {
      _currentView = _store.lifecycle != FlateStoreLifecycle.ready
          ? widget.loading
          : _FlateScope(
              store: _store,
              child: widget.ready,
            );
    });
  }

  @override
  void dispose() {
    _store.removeListener(_rebuild);
    _initializationLock.synchronized(_store.release);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.viewSwitchDuration,
      child: _currentView,
    );
  }
}

class _FlateScope extends InheritedWidget {
  final FlateStore _store;

  const _FlateScope({
    Key? key,
    required Widget child,
    required FlateStore store,
  })  : _store = store,
        super(key: key, child: child);

  static _FlateScope of(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<_FlateScope>();
    assert(element != null, 'No Flate found in context');

    return element!.widget as _FlateScope;
  }

  @override
  bool updateShouldNotify(_FlateScope old) {
    return _store != old._store;
  }
}
