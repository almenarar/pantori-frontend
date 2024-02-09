import 'package:pantori/domain/ports.dart';
import 'package:pantori/views/pages/home.dart';
import 'package:pantori/views/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  final ServicePort service;

  const LoginPage({super.key, required this.service});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';

  Future<void> login() async {
    try {
      await widget.service
          .login(usernameController.text, passwordController.text);
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
      return;
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  service: widget.service,
                )),
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginPageName),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //-------------------------------------------------------------------------------------->
            // logo image
            //-------------------------------------------------------------------------------------->
            localImage('images/logo.png', 200, 200),
            //-------------------------------------------------------------------------------------->
            space(16, 0),
            //-------------------------------------------------------------------------------------->
            // username input
            //-------------------------------------------------------------------------------------->
            Container(
                width: 250,
                padding: const EdgeInsets.all(8.0),
                child: textField(
                    usernameController,
                    AppLocalizations.of(context)!.loginUsername,
                    const Icon(Icons.person))),
            //-------------------------------------------------------------------------------------->
            space(16, 0),
            //-------------------------------------------------------------------------------------->
            // pwd input
            //-------------------------------------------------------------------------------------->
            Container(
                width: 250,
                padding: const EdgeInsets.all(8.0),
                child: textField(
                    passwordController,
                    AppLocalizations.of(context)!.loginPassword,
                    const Icon(Icons.key),
                    isPwd: true)),
            //-------------------------------------------------------------------------------------->
            space(16, 0),
            //-------------------------------------------------------------------------------------->
            // login button
            //-------------------------------------------------------------------------------------->
            applyButton(() {
              login();
            }, AppLocalizations.of(context)!.loginButton),
            //-------------------------------------------------------------------------------------->
            space(16, 0),
            //-------------------------------------------------------------------------------------->
            // error message
            //-------------------------------------------------------------------------------------->
            if (errorMessage.isNotEmpty) errorText(errorMessage)
          ],
        )),
      ),
    );
  }
}
