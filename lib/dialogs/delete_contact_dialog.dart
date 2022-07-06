import 'package:flutter/material.dart' show BuildContext;

import 'generic_dialog.dart';

Future<bool> showDeleteContactDialog(
   BuildContext context,
)=> showGenericDialog(
    title: 'Delete contac',
    content: 'Are you sure you want to delete this contact? you can\'t undo this action',
    optionsBuilder: () => {'Delete contact': true, 'Cancel': false},
    context: context
    ).then((value) => value ?? false);