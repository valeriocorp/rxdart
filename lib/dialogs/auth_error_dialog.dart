
import 'package:flutter/material.dart';
import 'package:testingrxdart/dialogs/generic_dialog.dart';

import '../blocs/auth_bloc/auth_error.dart';
Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
})=> showGenericDialog(
    title: authError.dialogTile,
     content: authError.dialogText,
      optionsBuilder: () => {'Ok': true},
       context: context);
