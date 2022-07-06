import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testingrxdart/blocs/auth_bloc/auth_bloc.dart';
import 'package:testingrxdart/blocs/auth_bloc/auth_error.dart';
import 'package:testingrxdart/blocs/contacts_bloc.dart';
import 'package:testingrxdart/blocs/views_bloc/current_view.dart';
import 'package:testingrxdart/blocs/views_bloc/views_bloc.dart';

import '../models/contact.dart';

@immutable
class AppBloc {
  final Authbloc _authbloc;
  final ViewsBloc _viewsbloc;
  final ContactsBloc _contactsBloc;

  final Stream<CurrentView> currentView;
  final Stream<bool> isLoading;
  final Stream<AuthError?> authError;
  final StreamSubscription<String?> _userIdChange;

  factory AppBloc(){
    final authBloc = Authbloc();
    final viewsBloc = ViewsBloc();
    final contactsBloc = ContactsBloc();

    //pass userId from auth bloc into the contacts bloc
    final userIdChanges = authBloc.userId.listen((String? userId) { 
      contactsBloc.userId.add(userId);
    });

    //calculate the current view
    final Stream<CurrentView> currentViewBasedOnAuthStatus = 
    authBloc.authStatus.map<CurrentView>((authStatus){
      if(authStatus is AuthStatusLoggedIn){
        return CurrentView.contactList;
      }else{
        return CurrentView.login;
      }
    });

    //current view
    final Stream<CurrentView> currentView = Rx.merge([
      currentViewBasedOnAuthStatus,
      viewsBloc.currentView,
    ]);

    //is loading TODO: recuerda puedes agregar mas loading a los otros blocs para tenerlos aqui
    final Stream<bool> isLoading = Rx.merge([
      authBloc.isLoading,
    ]);

  return AppBloc._(
    authbloc: authBloc,
    viewsbloc: viewsBloc,
    contactbloc: contactsBloc,
    currentView: currentView,
    isLoading: isLoading.asBroadcastStream(),
    authError: authBloc.authError.asBroadcastStream(),
    userIdChange: userIdChanges,
  );
  }

  void dispose(){
    _authbloc.dispose();
    _viewsbloc.dispose();
    _contactsBloc.dispose();
    _userIdChange.cancel();
  }

  const AppBloc._({
   required Authbloc authbloc,
   required ViewsBloc viewsbloc,
   required ContactsBloc contactbloc,
   required this.currentView,
   required this.isLoading,
   required this.authError,
   required  StreamSubscription<String?> userIdChange,}
  ): _authbloc = authbloc,
      _viewsbloc = viewsbloc,
      _contactsBloc = contactbloc,
      _userIdChange = userIdChange;

  void deleteContact(Contact contact) {
    _contactsBloc.deleteContact.add(contact);
  }

  void createContact(
     String firstnName,
     String lastName,
     String phoneNumber,
  ) {
    _contactsBloc.createContact.add(Contact.withoutId(
      firstName: firstnName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    ));
  }

  void deleteAccount(){
    _contactsBloc.deleteAllContact.add(null);
    _authbloc.deleteAccount.add(null);
  }

  void logout() {
    _authbloc.logout.add(null);
  }

  Stream<Iterable<Contact>> get contacts => _contactsBloc.contacts;

  void register(String email, String password) {
    _authbloc.register.add(
      RegisterCommand(
        email: email,
        password: password,
      ),
    );
  }

  void login(String email, String password) {
    _authbloc.login.add(
      LoginCommand(
        email: email,
        password: password,
      ),
    );
  }

  void goToContactListView() =>
      _viewsbloc.goToView.add(CurrentView.contactList);
  void goToCreateContactView() =>
      _viewsbloc.goToView.add(CurrentView.createContact);
  void goToRegisterView() => _viewsbloc.goToView.add(CurrentView.register);
  void goToLoginView() => _viewsbloc.goToView.add(CurrentView.login);
}
