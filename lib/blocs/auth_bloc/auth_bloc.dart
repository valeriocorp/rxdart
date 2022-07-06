import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_error.dart';

@immutable
abstract class AuthStatus {
  const AuthStatus();
}

@immutable
class AuthStatusLoggedOut implements AuthStatus {
  const AuthStatusLoggedOut();
}

@immutable
class AuthStatusLoggedIn implements AuthStatus {
  const AuthStatusLoggedIn();
}

@immutable
class AuthCommand{
  final String email;
  final String password;
  const AuthCommand({
    required this.email,
    required this.password,
  });
}

@immutable
class LoginCommand extends AuthCommand{
  const LoginCommand({
    required super.email,
    required super.password,
  });

}
@immutable
class RegisterCommand extends AuthCommand{
  const RegisterCommand({
    required super.email,
    required super.password,
  });

}

extension Loading<E> on Stream<E> {
  Stream<E> setLoadingTo(bool isLoading, {required Sink<bool> onSink,}) => doOnEach((_) { 
    onSink.add(isLoading);
  });
}

@immutable
class Authbloc{
  //read-only propertys
  final Stream<AuthStatus> authStatus;
  final Stream<AuthError?> authError;
  final Stream<bool> isLoading;
  final Stream<String?> userId; 
  //write-only propertys
  final Sink<LoginCommand> login;
  final Sink<RegisterCommand> register;
  final Sink<void> logout;
  final Sink<void> deleteAccount;

  void dispose(){
    login.close();
    register.close();
    logout.close();
    deleteAccount.close();
  }

 const Authbloc._({
    required this.authStatus,
    required this.authError,
    required this.isLoading,
    required this.userId,
    required this.login,
    required this.register,
    required this.logout,
    required this.deleteAccount,
  });

  factory Authbloc(){
    final isLoading = BehaviorSubject<bool>();

    // calculate auth status
    final Stream<AuthStatus> authStatusChanges = FirebaseAuth.instance.authStateChanges().map((user){
      if (user != null) {
        return const AuthStatusLoggedIn();
    
      } else {
            return const AuthStatusLoggedOut();
      }
    });
    // get the user id
    final Stream<String?> userId = FirebaseAuth.instance.authStateChanges().map((user) => user?.uid)
    .startWith(FirebaseAuth.instance.currentUser?.uid);

    //  login + Error handling
    final login = BehaviorSubject<LoginCommand>();
    final Stream<AuthError?> loginError = login
    .setLoadingTo(true, onSink: isLoading)
    .asyncMap<AuthError?>((loginCommand) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginCommand.email,
          password: loginCommand.password,
        );
        return null;
      } on FirebaseAuthException catch(e) {
        return AuthError.from(e);
      }catch (_){
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

     //register + error handling
    final register = BehaviorSubject<RegisterCommand>();
    final Stream<AuthError?> registerError = register
    .setLoadingTo(true, onSink: isLoading)
    .asyncMap<AuthError?>((registerCommand) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: registerCommand.email,
          password: registerCommand.password,
        );
        return null;
      } on FirebaseAuthException catch(e) {
        return AuthError.from(e);
      }catch (_){
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

     //logOut + error handling
    final logout = BehaviorSubject<void>();
    final Stream<AuthError?> logoutError = logout
    .setLoadingTo(true, onSink: isLoading)
    .asyncMap<AuthError?>((_) async {
      try {
        await FirebaseAuth.instance.signOut();
        return null;
      } on FirebaseAuthException catch(e) {
        return AuthError.from(e);
      }catch (_){
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

      //delete account + error handling
    final deleteAccount = BehaviorSubject<void>();
    final Stream<AuthError?> deleteAccountError = deleteAccount.setLoadingTo(true, onSink: isLoading)
    .asyncMap((_)async{
  try {
        await FirebaseAuth.instance.currentUser?.delete();
        return null;
      } on FirebaseAuthException catch(e) {
        return AuthError.from(e);
      }catch (_){
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

  // Auth error = (login error + register error + logout error)
    final Stream<AuthError?> authError = Rx.merge([
      loginError,
      registerError,
      logoutError,
      deleteAccountError,
    ]);

    return Authbloc._(
      authStatus: authStatusChanges,
      authError: authError,
      isLoading: isLoading.stream,
      userId: userId,
      login: login,
      register: register,
      logout: logout,
      deleteAccount: deleteAccount,
    );
  }
}
