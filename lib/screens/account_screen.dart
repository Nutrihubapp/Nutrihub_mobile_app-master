import 'dart:async';

import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';
import 'change_password.dart';
import 'emailsender.dart';
import 'update_info.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account-screen';

  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic count = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    //   timer = Timer.periodic(
    //       const Duration(milliseconds: 200), (Timer t) =>
    //  getCartItems();
    //);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // Future<List<Map<String, dynamic>>?> getCartItems() async {
  //   List<Map<String, dynamic>> listMap =
  //       await DatabaseHelper.instance.queryAllRows('cart_list');
  //   setState(() {
  //     count = listMap.length;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle:false,
        elevation:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  .1,
        backgroundColor: kAppBarColor,
        leadingWidth: 50,
        leading: Row(
          children: [
            SizedBox(width: 10,),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: InkWell(
                onTap: () => scaffoldKey.currentState!.openDrawer(),
                child: const Icon(
                  Icons.dehaze_rounded,
                  size: 30,
                  color: kBottomNavigationBarColor,
                ),
              ),
            ),
          ],
        ),
        title: Container(
          margin: EdgeInsets.only(top: 2),
          child: Image.asset(
            'Checkout-logo.png',
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).getUserInfo(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
                //period:Duration(seconds:5),
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 15),
                          child: Text(
                            "Profile",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black87),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "Account",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black87),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 45.0),
                            child: Stack(
                              fit: StackFit.loose,
                              alignment: Alignment.centerLeft,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 0.6,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        ListTile(
                                          title: Text(
                                            '',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          leading: Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Divider(height: 0.1),
                                        ),
                                        ListTile(
                                          title: Text(
                                            '',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          leading: Icon(
                                            Icons.email_outlined,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Divider(height: 0.1),
                                        ),
                                        ListTile(
                                          title: Text(
                                            '',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          leading: Icon(
                                            Icons.phone,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              bottom: 15),
                                          child: Divider(height: 0.1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 250.0, left: 10, right: 10),
                            child: Card(
                              elevation: 0.6,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ListTile(
                                title: const Text(
                                  "Change Password",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                leading: const Icon(
                                  Icons.vpn_key_outlined,
                                  color: Colors.indigo,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChangePassword()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          } else {
            if (dataSnapshot.error != null) {
              //error
              return const Center(
                child: Text('Error Occured'),
              );
            } else {
              return Consumer<Auth>(builder: (context, authData, child) {
                final user = authData.user;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 15),
                          child: Text(
                            "Profile",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black87),
                          ),
                        ),
                      ),
                      Stack(
                        fit: StackFit.loose,
                        alignment: Alignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 15.0,
                                      right: 15.0,
                                      bottom: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "Account",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black87),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 45.0),
                            child: Stack(
                              fit: StackFit.loose,
                              alignment: Alignment.centerLeft,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 0.6,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            user.address.toString(),
                                            style:
                                                const TextStyle(fontSize: 15.0),
                                          ),
                                          leading: const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Divider(height: 0.1),
                                        ),
                                        ListTile(
                                          title: Text(
                                            user.email.toString(),
                                            style:
                                                const TextStyle(fontSize: 15.0),
                                          ),
                                          leading: const Icon(
                                            Icons.email_outlined,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: Divider(height: 0.1),
                                        ),
                                        ListTile(
                                          title: Text(
                                            user.phone.toString(),
                                            style:
                                                const TextStyle(fontSize: 15.0),
                                          ),
                                          leading: const Icon(
                                            Icons.phone,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              bottom: 15),
                                          child: Divider(height: 0.1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 250.0, left: 10, right: 10),
                            child: Card(
                              elevation: 0.6,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: ListTile(
                                title: const Text(
                                  "Change Password",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                leading: const Icon(
                                  Icons.vpn_key_outlined,
                                  color: Colors.indigo,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChangePassword()),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10),
                        child: Card(
                          elevation: 0.6,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: ListTile(
                            title: const Text(
                              "Delete Account",
                              style: TextStyle(fontSize: 15.0, color: Colors.red),
                            ),
                            leading: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyEmailSender(
                                        regemail = user.email.toString())),
                              );
                            },
                          ),
                        ),
                      ),
                      // Column(
                      //   children: [
                      //     MaterialButton(
                      //       onPressed: () {
                      //         pushNewScreen(
                      //           context,
                      //           screen: const UpdateInfo(),
                      //           withNavBar: true,
                      //         );
                      //       },
                      //       color: kDarkButtonBg,
                      //       child: Column(
                      //         children: const [
                      //           Padding(
                      //             padding: EdgeInsets.only(left: 4.0),
                      //             child: Icon(
                      //               Icons.edit,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.only(left: 4.0),
                      //             child: Text(
                      //               'Edit',
                      //               style: TextStyle(
                      //                   fontSize: 15, color: Colors.white),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       padding: const EdgeInsets.all(0),
                      //       textColor: Colors.black87,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //         // side: BorderSide(color: Color.fromRGBO(100, 186, 2, 1),)
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 20,),
                      MaterialButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 70),
                        onPressed: ()  {
                          pushNewScreen(
                            context,
                            screen: const UpdateInfo(),
                            withNavBar: true,
                          );
                        },
                        child: Text(
                          "Edit",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                        color:  kGreenColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: kGreenColor)),
                      ),
                    ],
                  ),
                );
              });
            }
          }
        },
      ),
    );
  }
}
