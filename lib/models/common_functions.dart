import 'package:checkout_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonFunctions {
  static void showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('OK'),
          ),

        ],
      ),
    );
  }

  static void showSuccessToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
