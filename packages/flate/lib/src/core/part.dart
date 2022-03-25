part of '../core.dart';

/// This mixin should be used in the declaration of classes that contain a shared data set
/// and can be used by several [FlatePart] to ensure consistency at the level of several fragments.
///
/// Example:
/// ```dart
/// class User {}
///
/// class GuestUser implements User {}
///
/// class UserPart extends ChangeNotifier with SharedPart {
///   late User _currentUser = GuestUser();
///
///   User get currentUser => _currentUser;
///
///   void changeCurrentUser(User newUser) {
///     if (_currentUser == newUser) {
///       return;
///     }
///     _currentUser = newUser;
///     notifyListeners();
///   }
/// }
///
abstract class FlatePart extends FlateElement {
  /// Return instance of [FlateService] registered with type [S]
  ///
  /// If instance for type [S] is not registered in [FlateStore] then [StateError] will be thrown.
  /// If [FlateFragment] is not mounted([isMounted] returns false) then [StateError] will be thrown
  @protected
  S useService<S>() {
    if (isMounted) {
      return _store!._useService<S>();
    }
    throw StateError('Part of type $runtimeType is not mounted');
  }

  C useContext<C>() {
    if (isMounted) {
      return _store!.useContext<C>();
    }
    throw StateError('Part of type $runtimeType is not mounted');
  }
}
