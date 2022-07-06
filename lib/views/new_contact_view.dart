

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:testingrxdart/helpers/if_debugging.dart';
import 'package:testingrxdart/type_definition.dart';

class NewContactView extends HookWidget {
  final CreateContactCallback createContact;
  final GoBackCallback goBack;
  const NewContactView({Key? key, required this.createContact, required this.goBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController(text: 'francisco'.ifDebugging);
    final lastNameController = useTextEditingController(text: 'valerio'.ifDebugging);
    final phoneNumberController = useTextEditingController(text: '+573138146815'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Contact'),
        leading: IconButton(onPressed: goBack, icon:const  Icon(Icons.close)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name...',
                ),
                keyboardType: TextInputType.name,
                keyboardAppearance: Brightness.dark,
              ),
              TextField(
                      controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'last Name...',
                ),
                keyboardType: TextInputType.name,
                keyboardAppearance: Brightness.dark,
             
              ),
              TextField(
                      controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone number...',
                ),
                keyboardType: TextInputType.phone,
                keyboardAppearance: Brightness.dark,
             
              ),

              TextButton(onPressed: (){
                final firstName = firstNameController.text;
                final lastName = lastNameController.text;
                final phoneNumber = phoneNumberController.text;
                createContact(firstName, lastName, phoneNumber);
                goBack();
              }, child: const Text('Save Contact')),

            ],
          ),
        ),
      ),
    );
  }
}