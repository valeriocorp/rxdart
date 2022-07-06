import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'user-disabled': AuthErrorUserDisabled(),
  'no-current-user': AuthErrorNoCurrentUser(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
};

@immutable
abstract class AuthError {
  final String dialogTile;
  final String dialogText;
  const AuthError({
    required this.dialogTile,
    required this.dialogText,
  });

 factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ?? const AuthErrorUnknown();
}


@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogTile: 'Authentication error',
          dialogText: 'Unknown Authentication error occurred',
        );
} 

//Auth/ no-current-user
@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTile: 'Authentication error',
          dialogText: 'No current user whith this information was found',
        );
}

//auth/requires-recent-login
@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogTile: 'Requires recent login',
          dialogText: 'This operation is sensitive and requires recent authentication. Log in again before retrying this request.',
        );
}

//auth/operation-not-allowed
@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogTile: 'Operation not allowed',
          dialogText: 'You cannot register usin this method at this time',
        );
}

//Auth/ user-not-found
@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTile: 'User not found',
          dialogText: 'the given user does not exist',
        );
}

//Auth/ weak-password
@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogTile: 'Weak password',
          dialogText: 'The password is too weak',
        );
}

//Auth/ invalid-email
@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTile: 'Invalid email',
          dialogText: 'The email address is badly formatted try again',
        );
}

//Auth/ email-already-in-use
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTile: 'Email already in use',
          dialogText: 'The email address is already in use by another account',
        );
}

//Auth/ user-disabled
@immutable
class AuthErrorUserDisabled extends AuthError {
  const AuthErrorUserDisabled()
      : super(
          dialogTile: 'User disabled',
          dialogText: 'The user account has been disabled',
        );
}
