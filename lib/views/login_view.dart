import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:testingrxdart/helpers/if_debugging.dart';
import 'package:testingrxdart/type_definition.dart';

class LoginView extends HookWidget {
  final LoginFunction login;
  final VoidCallback goToRegisterView;
  const LoginView(
      {Key? key, required this.login, required this.goToRegisterView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
        text: 'franciscojvg0607@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: '123456'.ifDebugging);
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your Email...',
                ),
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.dark,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Enter your password here...',
                ),
                keyboardAppearance: Brightness.dark,
                obscureText: true,
                obscuringCharacter: '*',
              ),
              TextButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    login(email, password);
                  },
                  child: const Text('Login')),
              TextButton(
                onPressed: () {
                  goToRegisterView();
                },
                child: const Text('Not register yet? Click here to register'),
              ),
            ],
          ),
        ));
  }
}
