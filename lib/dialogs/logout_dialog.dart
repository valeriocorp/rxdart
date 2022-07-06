import 'package:flutter/material.dart' show BuildContext;

import 'generic_dialog.dart';

Future<bool> showLogoutDialog(
   BuildContext context,
)=> showGenericDialog(
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    optionsBuilder: () => {'Log out': true, 'Cancel': false},
    context: context
    ).then((value) => value ?? false);