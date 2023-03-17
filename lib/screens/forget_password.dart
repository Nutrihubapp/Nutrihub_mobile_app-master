import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/models/update_user_model.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/widgets/progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

// ignore: non_constant_identifier_names
Future<UpdateUserModel?> UpdateUser(String email) async {
  const String apiUrl = BASE_URL + "api_frontend/forgot_password";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'email': email,
  });

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isApiCallProcess = false;
  String? data;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0.1,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 650.0,
              child: Form(
                key: globalFormKey,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 60),
                          Center(
                            child: Image.asset(
                              'signinlogo.png',
                              height: 45,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 80),
                          const Text(
                            "Input valid email to reset password",
                            style: TextStyle(

                                color: Colors.black45,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, bottom: 8),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        // onSaved: (input) => _emailController.text = input,
                        validator: (input) =>
                            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                    .hasMatch(input.toString())
                                ? "Email Id should be valid"
                                : null,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            filled: true,
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 14),
                            hintText: "Email",
                            fillColor: Color(0xFFF7F7F7),
                            contentPadding: EdgeInsets.only(
                                left: 14, top: 20, right: 14, bottom: 20)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Consumer<Auth>(
                      builder: (context, auth, widget) {
                        return MaterialButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 80),
                          onPressed: () async {
                            final String email = _emailController.text.toString();
                            if (!globalFormKey.currentState!.validate()) {
                              return;
                            }
                            if (email.isNotEmpty) {
                              final UpdateUserModel? user = await UpdateUser(email);

                              setState(() {
                                // _user = user;
                                CommonFunctions.showSuccessToast(
                                    user!.message.toString());
                              });
                              Navigator.pop(
                                  context, 'Password updated successfully');
   auth.controller.jumpToTab(0);
                              // Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const TabsScreen(selectedPageIndex: 0)),
                              //     (Route<dynamic> route) => false);
                            }
                          },
                          child: const Text(
                            "Reset",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          color: kGreenColor,
                          shape: const StadiumBorder(),
                        );
                      }
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
