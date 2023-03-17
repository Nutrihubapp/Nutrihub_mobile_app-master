import 'package:checkout_app/constants.dart';
import 'package:checkout_app/screens/auth_screen.dart';
import 'package:checkout_app/widgets/progress_hud.dart';
import 'package:flutter/material.dart';

class SignUpSuccessPage extends StatefulWidget {
  final String email;
  const SignUpSuccessPage(this.email, {Key? key}) : super(key: key);

  @override
  _SignUpSuccessPageState createState() => _SignUpSuccessPageState();
}

class _SignUpSuccessPageState extends State<SignUpSuccessPage> {
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Verify Email",
          style: TextStyle(
            fontSize: 18,

            color: Colors.white,
          ),
        ),
        backgroundColor: kGreenColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .15),
            Image.asset(
              'sign-in-to-continue.png',
              height: 180,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Text(
                "A verification link was sent to your email address: " +
                    widget.email,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: MaterialButton(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 110),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                color: kGreenColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: kGreenColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
