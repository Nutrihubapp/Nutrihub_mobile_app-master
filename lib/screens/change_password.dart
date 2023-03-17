// ignore_for_file: non_constant_identifier_names

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/models/update_user_model.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/screens/tabs_screen.dart';
import 'package:checkout_app/widgets/app_bar.dart';
import 'package:checkout_app/widgets/progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

Future<UpdateUserModel?> UpdateUser(String auth_token, String currentPass,
    String newPass, String ConfirmNewPass) async {
  String apiUrl = BASE_URL + "api_frontend/change_password";

  final response = await http.post(Uri.parse(apiUrl), body: {
    'auth_token': auth_token,
    'current_password': currentPass,
    'new_password': newPass,
    'confirm_new_password': ConfirmNewPass,
  });

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return updateUserModelFromJson(responseString);
  } else {
    return null;
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _passwordControllerOld = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordControllerValidate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(color: Color(0xFF3862FD)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      filled: true,
      hintStyle: const TextStyle(color: Color(0xFFc7c8ca)),
      hintText: hintext,
      fillColor: const Color(0xFFF7F7F7),
      prefixIcon: Icon(
        iconData,
        color: const Color(0xFFc7c8ca),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title:  'Change Password'),
      body: SingleChildScrollView(
        child: Stack(
          children: [

            Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Update Password',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        
                      ),
                    ),
                  ),
                ),
                isApiCallProcess
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Card(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          child: Form(
                            key: globalFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  style: const TextStyle(fontSize: 16),
                                  decoration: getInputDecoration(
                                    'Current Password',
                                    Icons.vpn_key,
                                  ),
                                  obscureText: true,
                                  controller: _passwordControllerOld,
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'Can not be empty';
                                    }
                                  },
                                  onSaved: (value) {
                                    _passwordControllerOld.text =
                                        value.toString();
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 16),
                                  decoration: getInputDecoration(
                                    'New Password',
                                    Icons.vpn_key,
                                  ),
                                  obscureText: true,
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value.toString().isEmpty ||
                                        value.toString().length < 4) {
                                      return 'Password is too short!';
                                    }
                                  },
                                  onSaved: (value) {
                                    _passwordController.text = value.toString();
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 16),
                                  decoration: getInputDecoration(
                                    'Confirm Password',
                                    Icons.vpn_key,
                                  ),
                                  obscureText: true,
                                  controller: _passwordControllerValidate,
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match!';
                                    }
                                  },
                                  onSaved: (value) {
                                    _passwordControllerValidate.text =
                                        value.toString();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<Auth>(
                      builder: (context, auth, widget) {
                        return MaterialButton(
                          onPressed: () async {
                            final String currentPass =
                                _passwordControllerOld.text.toString();
                            final String newPass =
                                _passwordController.text.toString();
                            final String confirmNewPass =
                                _passwordControllerValidate.text.toString();
                            final String authToken =
                                Provider.of<Auth>(context, listen: false)
                                    .token
                                    .toString();
                            if (!globalFormKey.currentState!.validate()) {
                              return;
                            }
                            if (currentPass.isNotEmpty &&
                                newPass.isNotEmpty &&
                                confirmNewPass.isNotEmpty &&
                                authToken.isNotEmpty) {
                              final UpdateUserModel? user = await UpdateUser(
                                  authToken, currentPass, newPass, confirmNewPass);

                              setState(() {
                                // print(user!.message.toString());
                                // _user = user;
                                CommonFunctions.showSuccessToast(
                                    user!.message.toString());
                              });
                              Navigator.pop(
                                  context, 'Password updated successfully');
   auth.controller.jumpToTab(3);
                              // Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const TabsScreen(selectedPageIndex: 3)),
                              //     (Route<dynamic> route) => false);
                            }
                          },
                          child: const Text(
                            'UPDATE',
                            style: TextStyle(),
                          ),
                          color: kGreenColor,
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            side: const BorderSide(color: kGreenColor),
                          ),
                        );
                      }
                    ),
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
