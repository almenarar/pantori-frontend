import 'package:pantori/domain/ports.dart';
import 'package:pantori/views/pages/home.dart';

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
            Image.asset(
              'images/logo.png',
              width: 200, // Set the width as needed
              height: 200, // Set the height as needed
            ),
            //-------------------------------------------------------------------------------------->
            // space
            //-------------------------------------------------------------------------------------->
            const SizedBox(height: 16.0),
            //-------------------------------------------------------------------------------------->
            // username input
            //-------------------------------------------------------------------------------------->
            Container(
                width: 250,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.loginUsername,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                )),
            //-------------------------------------------------------------------------------------->
            // space
            //-------------------------------------------------------------------------------------->
            const SizedBox(height: 16.0),
            //-------------------------------------------------------------------------------------->
            // pwd input
            //-------------------------------------------------------------------------------------->
            Container(
                width: 250,
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.loginPassword,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.key),
                  ),
                )),
            //-------------------------------------------------------------------------------------->
            // space
            //-------------------------------------------------------------------------------------->
            const SizedBox(height: 16.0),
            //-------------------------------------------------------------------------------------->
            // login button
            //-------------------------------------------------------------------------------------->
            ElevatedButton(
              onPressed: () {
                login();
              },
              child: Text(AppLocalizations.of(context)!.loginButton),
            ),
            //-------------------------------------------------------------------------------------->
            // space
            //-------------------------------------------------------------------------------------->
            const SizedBox(height: 16.0),
            //-------------------------------------------------------------------------------------->
            // error message
            //-------------------------------------------------------------------------------------->
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        )),
      ),
    );
  }
}
