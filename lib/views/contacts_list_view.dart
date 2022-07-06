

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:testingrxdart/dialogs/delete_contact_dialog.dart';
import 'package:testingrxdart/type_definition.dart';
import 'package:testingrxdart/views/main_popup_menu_button.dart';

import '../models/contact.dart';

class ContactsListView extends StatelessWidget {
  final DeleteAccountCallback deleteAccount;
  final LogoutCallback logout;
  final DeleteContactCallback deleteContact;
  final VoidCallback createNewContact;
  final Stream<Iterable<Contact>> contacts;
  const ContactsListView({Key? key, required this.deleteAccount, required this.logout, required this.deleteContact, required this.createNewContact, required this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts list'),
        actions: [
          MainPopupMenuButton(logout: logout, deleteAccount: deleteAccount),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewContact,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<Iterable<Contact>>(
        stream: contacts,
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final contacts = snapshot.requireData;
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index){
                  final contact = contacts.elementAt(index);
                  return ContactListile(contact: contact, deleteContact: deleteContact);
                },
              );
          }
        }
      ),
    );
  }
}

class ContactListile extends HookWidget {
  final Contact contact;
  final DeleteContactCallback deleteContact;
  const ContactListile({Key? key, required this.contact, required this.deleteContact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.fullName),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: ()async{
          final shouldDelete = await showDeleteContactDialog(context);
          if(shouldDelete){
            deleteContact(contact);
          }
        },
      ),
    
    );
  }
}