import 'package:flutter/material.dart';

import '../constants.dart';
import 'auth_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .20),
            Image.asset(
              'signinlogo.png',
              height: 145,
            ),
            const SizedBox(height: 30),
            const Text(
              "Sign in to continue.",
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(),
                ),
                color: kDarkButtonBg,
                textColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 135, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
