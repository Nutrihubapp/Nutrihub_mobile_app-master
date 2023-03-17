import 'package:checkout_app/screens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:checkout_app/providers/auth.dart';

import '../constants.dart';

void mainemailsender() {
  runApp(MaterialApp(home: MyEmailSender(regemail)));
}

String regemail = '';

class MyEmailSender extends StatelessWidget {
  MyEmailSender(String s);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text("ACCOUNT DELETION"),
      ),
      body: Column(
        children: [
          Text('Are you sure you want to delete your account?', style: TextStyle(color: Colors.redAccent),),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: kAppBarColor,
                               textStyle: TextStyle(
                    fontSize: 20,
                   )),
            child: Text('Yes'),
            onPressed: () async {
              EmailContent email = EmailContent(
                to: [
                  'deletion@nutrihubapp.com',
                ],
                subject: 'Deleting account from Nutrihub',
                body:
                    'Please kindly delete my account registered on email : ' +
                        regemail,
              );

              OpenMailAppResult result =
                  await OpenMailApp.composeNewEmailInMailApp(
                      nativePickerTitle: 'Select email app to compose',
                      emailContent: email);

             if (!result.didOpen && result.canOpen) {
                showDialog(
                  context: context,
                  builder: (_) => MailAppPickerDialog(
                    mailApps: result.options,
                    emailContent: email,
                  ),
                );
              }
            },
          ),
          Container(
            width: 20,
            height: 20,

          ),
          ElevatedButton(

            onPressed: () {
              Navigator.pop(context);
            },

            style: ElevatedButton.styleFrom(
                primary: kAppBarColor,
               
                textStyle: TextStyle(
                    fontSize: 20,
                   )),
            child: Text('No'),
          ),

        ],
      ),
    );
  }


}
