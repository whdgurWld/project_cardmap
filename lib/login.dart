import 'package:flutter/material.dart';
import 'package:project_cardmap/auth.dart';
import 'package:project_cardmap/components/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                imagePath: 'assets/google.png',
                onTap: () async {
                  await Auth().signInWithGoogle();

                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, '/');
                },
                text: 'Sign in with Google',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
