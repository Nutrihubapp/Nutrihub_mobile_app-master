import 'dart:convert';
import 'dart:io';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/models/help_and_support_model.dart';
import 'package:checkout_app/widgets/help_and_support_list_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:livechatt/livechatt.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({Key? key}) : super(key: key);

  @override
  _HelpAndSupportScreenState createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  Future<HelpAndSupportModel>? futureHelpAndSupport;

  Future<HelpAndSupportModel> fetchData() async {
    var url = BASE_URL + "api_frontend/help_and_support";
    try {
      final response = await http.get(Uri.parse(url));
      return HelpAndSupportModel.fromJson(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    futureHelpAndSupport = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         leading:    Platform.isIOS? IconButton(icon:const Icon(Icons.arrow_back_ios,color:kBackgroundColor), onPressed:()=>Navigator.pop(context)) : IconButton(icon:const Icon(Icons.arrow_back, color:kBackgroundColor), onPressed:()=>Navigator.pop(context)),
        elevation: 0.1,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kGreenColor,
        title: const Center(
            child: Padding(
          padding: EdgeInsets.only(right: 50.0),
          child: Text(
            "Help & Support",
            style: TextStyle(color: Colors.white),
          ),
        )),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
          child: FutureBuilder<HelpAndSupportModel>(
        future: futureHelpAndSupport,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              //period:Duration(seconds:5),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child:Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(Icons.email_outlined),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                   "",
                                    style: const TextStyle(
                                        fontSize: 11,
                                       ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 35, right: 35, bottom: 6),
                                  child: MaterialButton(
                                    onPressed: () => customLaunch(
                                        'mailto:'),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Email Us',
                                          style: TextStyle(
                                              
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    color: kDarkButtonBg,
                                    textColor: Colors.white,
                                    splashColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      side: const BorderSide(
                                          color: kDarkButtonBg),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Card(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(Icons.phone),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                   "",
                                    style: const TextStyle(
                                        fontSize: 11,
                                       ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 35, right: 35, bottom: 6),
                                  child: MaterialButton(
                                    onPressed: () => customLaunch('tel:' +
                                       "",),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Call Us',
                                          style: TextStyle(
                                              
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    color: kDarkButtonBg,
                                    textColor: Colors.white,
                                    splashColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      side: const BorderSide(
                                          color: kDarkButtonBg),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.chat_bubble),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                           "",
                            style: const TextStyle(
                                fontSize: 11,),
                          ),
                        ),
                       /* Padding(
                          padding: const EdgeInsets.only(
                              left: 35, right: 35, bottom: 6),
                          child: MaterialButton(
                            onPressed: () async {
                            
                              //  Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return CrispChatScreen();
                              // })),
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Chat with Us',
                                  style: TextStyle(
                                      
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            color: kDarkButtonBg,
                            textColor: Colors.white,
                            splashColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              side: const BorderSide(color: kDarkButtonBg),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var qid = index + 1;
                          return IgnorePointer(
                            child: HelpAndSupportList(
                              helpAndSupportId: "",
                              question:"",
                              answer:"",
                              status:"",
                            ),
                          );
                        }),
                  ),
                ],
              )
            );
          } else {
            if (dataSnapshot.error != null) {
              //error
              return const Center(
                child: Text('Error Occured'),
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(Icons.email_outlined),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    dataSnapshot.data!.systemEmail.toString(),
                                    style: const TextStyle(
                                        fontSize: 11,
                                       ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 35, right: 35, bottom: 6),
                                  child: MaterialButton(
                                    onPressed: () => customLaunch(
                                        'mailto:${dataSnapshot.data!.systemEmail}'),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Email Us',
                                          style: TextStyle(
                                              
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    color: kDarkButtonBg,
                                    textColor: Colors.white,
                                    splashColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      side: const BorderSide(
                                          color: kDarkButtonBg),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Card(
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(Icons.phone),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    dataSnapshot.data!.systemPhone.toString(),
                                    style: const TextStyle(
                                        fontSize: 11,
                                       ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 35, right: 35, bottom: 6),
                                  child: MaterialButton(
                                    onPressed: () => customLaunch('tel:' +
                                        dataSnapshot.data!.systemPhone
                                            .toString()),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Call Us',
                                          style: TextStyle(
                                              
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    color: kDarkButtonBg,
                                    textColor: Colors.white,
                                    splashColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      side: const BorderSide(
                                          color: kDarkButtonBg),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              /*    Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.chat_bubble),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            dataSnapshot.data!.systemEmail.toString(),
                            style: const TextStyle(
                                fontSize: 11,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 35, right: 35, bottom: 6),
                          child: MaterialButton(
                            onPressed: () async {
                              Box box1 = await Hive.openBox('user_info');
                              Map details = await box1.get('user_info');

                              Livechat.beginChat(
                                "14022744",
                                "",
                                details['name'],
                                details['email'],
                              );

                              //  Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return CrispChatScreen();
                              // })),
                            },
                            *//*child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Chat with Us',
                                  style: TextStyle(
                                      
                                      fontSize: 12),
                                ),
                              ],
                            ),*//*
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            color: kDarkButtonBg,
                            textColor: Colors.white,
                            splashColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              side: const BorderSide(color: kDarkButtonBg),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),*/
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dataSnapshot.data!.helpAndSupport!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var qid = index + 1;
                          return HelpAndSupportList(
                            helpAndSupportId: qid.toString(),
                            question: dataSnapshot
                                .data!.helpAndSupport![index].question,
                            answer: dataSnapshot
                                .data!.helpAndSupport![index].answer,
                            status: dataSnapshot
                                .data!.helpAndSupport![index].status,
                          );
                        }),
                  ),
                ],
              );
            }
          }
        },
      )),
    );
  }

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      CommonFunctions.showSuccessToast('could not launch $command');
    }
  }
}
