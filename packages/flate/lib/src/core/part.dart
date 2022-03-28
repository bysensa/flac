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
abstract class FlatePart extends FlateElement
    with _ServiceResolver, _ContextResolver {}
