import 'package:flutter/material.dart' show BuildContext;

import 'generic_dialog.dart';

Future<bool> showDeleteAccountDialog(
   BuildContext context,
)=> showGenericDialog(
    title: 'Delete Account',
    content: 'Are you sure you want to delete your account?',
    optionsBuilder: () => {'Yes': true, 'No': false},
    context: context
    ).then((value) => value ?? false);