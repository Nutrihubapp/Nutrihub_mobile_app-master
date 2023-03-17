// ignore_for_file: constant_identifier_names

import 'package:checkout_app/widgets/progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/common_functions.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';
import 'forget_password.dart';
import 'signup_page.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.1,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: deviceSize.width > 600 ? 2 : 1,
                child: const AuthCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  String? data;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submit() async {
    if (!globalFormKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    globalFormKey.currentState!.save();

    setState(() {
      isApiCallProcess = true;
    });
    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).loginUser(
        emailController.text,
        passwordController.text,
      );
      await Provider.of<Auth>(context, listen: false).getAuthToken();
      // await Api().loginUser(_emailController.text, _passwordController.text,);
      Navigator.pop(context);
      // Navigator.pushNamedAndRemoveUntil(context, 'bottomnavbar', (r) => false);
    //  Provider.of<Auth>(context, listen:false).controller.jumpToTab(3);
      CommonFunctions.showSuccessToast('Login Successful');
    } on HttpException {
      var errorMsg = 'Auth failed';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      print(error.toString());
      const errorMsg = 'Could not authenticate!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      isApiCallProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    // emailController.text = "customer@example.com";
    // passwordController.text = "1234";
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: globalFormKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'signinlogo.png',
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 70),
            const Text(
              "Sign In To Your Account",
              style: TextStyle(
                  color: Colors.black,

                  fontSize: 18),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                // onSaved: (input) => loginRequestModel!.email = input,
                validator: (input) =>
                    !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(input!)
                        ? "Email Id should be valid"
                        : null,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                    hintText: "Username or email",
                    fillColor: Color(0xFFF7F7F7),
                    contentPadding: EdgeInsets.only(
                        left: 14, top: 20, right: 14, bottom: 20)),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                controller: passwordController,
                // onSaved: (input) => loginRequestModel!.password = input,
                validator: (input) => input!.length < 3
                    ? "Password should be more than 3 characters"
                    : null,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  filled: true,
                  hintStyle:
                      const TextStyle(color: Colors.black54, fontSize: 14),
                  hintText: "Password",
                  fillColor: const Color(0xFFF7F7F7),
                  contentPadding: const EdgeInsets.only(
                      left: 14, top: 20, right: 14, bottom: 20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Colors.black,
                    icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: MaterialButton(
                  onPressed: _submit,
                  child: const Text(
                    'Sign In',
                    style: TextStyle( fontSize: 16),
                  ),
                  color: kGreenColor,
                  textColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  splashColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(color: kGreenColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgetPassword()),
                );
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                    fontSize: 13,

                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
