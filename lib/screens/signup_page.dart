import 'dart:convert';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/models/user_model.dart';
import 'package:checkout_app/screens/auth_screen.dart';
import 'package:checkout_app/screens/signup_success_page.dart';
import 'package:checkout_app/widgets/progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

Future<UserModel?> createUser(String name, String address, String email,
    String password, String phone) async {
  const String apiUrl = BASE_URL + "api_frontend/signup";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'name': name,
    'address': address,
    'email': email,
    'password': password,
    'phone': phone,
  });

  if (response.statusCode == 200) {
    final String responseString = response.body;
    var msg = json.decode(response.body)['message'];
    CommonFunctions.showSuccessToast(msg);
    return userModelFromJson(responseString);
  } else {
    return null;
  }
}

class _SignUpPageState extends State<SignUpPage> {
  UserModel? _user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
              height: 670.0,
              child: Form(
                key: globalFormKey,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      title: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Image.asset(
                              'signinlogo.png',
                              height: 45,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "Sign up to continue",
                            style: TextStyle(

                                color: Colors.black45,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Name is Required';
                          }
                          return null;
                        },
                        //onSaved: (input) => nameController.text = input,
                        // validator: (input) => input != null
                        //     ? "Name field cannot be null"
                        //     : null,
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
                            hintText: "Name",
                            fillColor: Color(0xFFF7F7F7),
                            contentPadding: EdgeInsets.only(
                                left: 14, top: 20, right: 14, bottom: 20)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Phone is Required';
                          }
                          return null;
                        },
                        //onSaved: (input) => phoneController.text = input,
                        // validator: (input) => input.length < 11
                        //     ? "Mobile Number cannot be invalid"
                        //     : null,
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
                            hintText: "Mobile Number",
                            fillColor: Color(0xFFF7F7F7),
                            contentPadding: EdgeInsets.only(
                                left: 14, top: 20, right: 14, bottom: 20)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        controller: addressController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Address is Required';
                          }
                          return null;
                        },
                        //onSaved: (input) => nameController.text = input,
                        // validator: (input) => input != null
                        //     ? "Name field cannot be null"
                        //     : null,
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
                            hintText: "Address",
                            fillColor: Color(0xFFF7F7F7),
                            contentPadding: EdgeInsets.only(
                                left: 14, top: 20, right: 14, bottom: 20)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Email is Required';
                          }

                          if (!RegExp(
                                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(value)) {
                            return 'Please enter a valid email Address';
                          }

                          return null;
                        },
                        // onSaved: (input) => emailController.text = input,
                        // validator: (input) => !input.contains('@')
                        //     ? "Email Id should be valid"
                        //     : null,
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
                            hintText: "Email Address",
                            fillColor: Color(0xFFF7F7F7),
                            contentPadding: EdgeInsets.only(
                                left: 14, top: 20, right: 14, bottom: 20)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Password is Required';
                          }
                          return null;
                        },
                        // onSaved: (input) =>
                        // passwordController.text = input,
                        // validator: (input) => input.length < 3
                        //     ? "Password should be more than 3 characters"
                        //     : null,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: const TextStyle(
                              color: Colors.black54, fontSize: 14),
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
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 70),
                      onPressed: () async {
                        final String name = nameController.text.toString();
                        final String address =
                            addressController.text.toString();
                        final String email = emailController.text.toString();
                        final String password =
                            passwordController.text.toString();
                        final String phone = phoneController.text.toString();

                        if (!globalFormKey.currentState!.validate()) {
                          return;
                        }
                        if (name.isNotEmpty &&
                            address.isNotEmpty &&
                            email.isNotEmpty &&
                            password.isNotEmpty &&
                            phone.isNotEmpty) {
                          final UserModel? user = await createUser(
                              name, address, email, password, phone);

                          setState(() {
                            _user = user;
                          });
                          _user!.emailVerificationStatus == '0'
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AuthScreen()),
                                )
                              : Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignUpSuccessPage(email)),
                                );
                        }
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: kGreenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(color: kGreenColor),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AuthScreen()));
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 13,),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
