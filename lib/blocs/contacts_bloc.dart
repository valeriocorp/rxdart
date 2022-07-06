import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:testingrxdart/models/contact.dart';

typedef _Snapshot = QuerySnapshot<Map<String, dynamic>>;
typedef _Document = DocumentReference<Map<String, dynamic>>;

//esta extencion quita los valores que lleguen nulos de un stream y solo devuelve los valores no nulos
extension Unwrap<T> on Stream<T?>{
  Stream<T> unwrap() => switchMap((optional) async* {
    if(optional != null) yield optional;
  });
}

@immutable
class ContactsBloc{
  final Sink<String?> userId;
  final Sink<Contact> createContact;
  final Sink<Contact> deleteContact;
  final Sink<void> deleteAllContact;
  final Stream<Iterable<Contact>> contacts;
  final StreamSubscription<void> _createContactSubscription;
  final StreamSubscription<void> _deleteContactSubscription;
  final StreamSubscription<void> _deleteAllContactSubscription;


  void dispose(){
    userId.close();
    createContact.close();
    deleteContact.close();
    deleteAllContact.close();
    _createContactSubscription.cancel();
    _deleteContactSubscription.cancel();
    _deleteAllContactSubscription.cancel();

  }

  const ContactsBloc._({
    required this.userId,
    required this.createContact,
    required this.deleteContact,
    required this.deleteAllContact,
    required this.contacts,
    required StreamSubscription<void> createContactSubscription,
    required StreamSubscription<void> deleteContactSubscription,
    required StreamSubscription<void> deleteAllContactSubscription,
  }):_createContactSubscription = createContactSubscription,
      _deleteContactSubscription = deleteContactSubscription,
      _deleteAllContactSubscription = deleteAllContactSubscription;


  factory ContactsBloc(){
    final backend = FirebaseFirestore.instance;

    final userId = BehaviorSubject<String?>();

    //upon changes to user id, retrieve our contacts
    final Stream<Iterable<Contact>> contacts = userId.switchMap<_Snapshot>((userId){
      if(userId == null){
        return const Stream<_Snapshot>.empty();
      }else{
        return backend.collection(userId).snapshots();
      }
    }).map<Iterable<Contact>>((snapshots) sync*{
      for(final doc in snapshots.docs){
        yield Contact.fromJson(doc.data(), id: doc.id);
      }
    });

    //create contact
    final createContact = BehaviorSubject<Contact>();

    final StreamSubscription<void> createContactSubscription = createContact.switchMap((contactToCreate) => 
    userId.take(1)
    .unwrap()
    .asyncMap((userId) => backend.collection(userId).add(contactToCreate.data),
    ),
    ).listen((event) { });

    //delete contact
    final deleteContact = BehaviorSubject<Contact>();

    final StreamSubscription<void> deleteContactSubscription = deleteContact.switchMap((contactToDelete) => 
    userId.take(1)
    .unwrap()
    .asyncMap((userId) => backend.collection(userId).doc(contactToDelete.id).delete(),
    ),
    ).listen((event) { });

    //delete all contacts
    final deleteAllContact = BehaviorSubject<void>();

    final StreamSubscription<void> deleteAllContactSubscription = 
    deleteAllContact
    .switchMap((_) => userId.take(1).unwrap())
    .asyncMap((userId) => backend.collection(userId).get())
    .asyncMap((collection) => Stream.fromFutures(
      collection.docs.map((doc) => doc.reference.delete()))).listen((_) { });

    //create contactbloc

    return ContactsBloc._(
      userId: userId,
      createContact: createContact,
      deleteContact: deleteContact,
      contacts: contacts,
      createContactSubscription: createContactSubscription,
      deleteContactSubscription: deleteContactSubscription, 
      deleteAllContact: deleteAllContact,
      deleteAllContactSubscription: deleteAllContactSubscription,
    );
  }    


}