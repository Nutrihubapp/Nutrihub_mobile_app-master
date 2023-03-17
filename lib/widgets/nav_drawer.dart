import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/screens/all_product_screen.dart';
import 'package:checkout_app/screens/auth_screen.dart';
import 'package:checkout_app/screens/categories.dart';
import 'package:checkout_app/screens/help_and_support_screen.dart';
import 'package:checkout_app/screens/my_orders.dart';
import 'package:checkout_app/screens/tabs_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  var _isInit = true;
  var _name = '';
  var _email = '';
  var _photo = '';
  var token = '';

  @override
  void didChangeDependencies() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
    });
    if (_isInit) {
      setState(() {
        _photo = (prefs.getString('updateImage') ?? '');
        _name = (prefs.getString('name') ?? '');
        _email = (prefs.getString('email') ?? '');
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<Auth>(builder: (context, auth, widget) {
        return Container(
          color: const Color.fromRGBO(244, 244, 244, 1),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                token.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // _photo.isNotEmpty
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(
                          //             left: 15.0, bottom: 10.0, top: 10),
                          //         child: Container(
                          //           alignment: Alignment.centerLeft,
                          //           child: CircleAvatar(
                          //             radius: 50,
                          //             backgroundImage: NetworkImage(_photo),
                          //             backgroundColor: Colors.grey,
                          //           ),
                          //         ),
                          //       )
                          //     : Padding(
                          //         padding: const EdgeInsets.only(
                          //             left: 15.0, bottom: 10.0, top: 10),
                          //         child: Container(
                          //           alignment: Alignment.centerLeft,
                          //           child: const CircleAvatar(
                          //             radius: 50,
                          //             backgroundImage:
                          //                 AssetImage('image-not-found.png'),
                          //             backgroundColor: Colors.grey,
                          //           ),
                          //         ),
                          //       ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            child: Text(
                              _name,
                              style: const TextStyle(
                                 fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              _email,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, bottom: 10.0, top: 10),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.black26,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 15.0,
                            ),
                            child: Text(
                              "You are not signed in.",
                              style: TextStyle(
                                  fontSize: 16),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Please sign in to order products.",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                const Divider(
                  color: Colors.black45,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Provider.of<Auth>(context, listen: false)
                        .changeAppBar(false);
                    pushNewScreen(
                      context,
                      screen: const AllProductScreen(),
                      withNavBar: true,
                    );
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //   return const TabsScreen(selectedPageIndex: 0);
                    // }));
                  },
                  child: ListTile(
                    title: const Align(
                        alignment: Alignment(-1.3, 0), child: Text('Products')),
                    leading: Image.asset(
                      'products.png',
                      height: 22,
                      width: 22,
                      color: Colors.black,
                    ),
                    // leading: Image.asset(
                    //   "home.png",
                    //   height: 22,
                    //   width: 22,
                    //   color: Colors.black38,
                    // ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    pushNewScreen(
                      context,
                      screen: const Categories(),
                      withNavBar: true,
                    );
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return const Categories();
                    // }));
                  },
                  child: ListTile(
                    title: const Align(
                        alignment: Alignment(-1.35, 0),
                        child: Text('Categories')),
                    leading: Image.asset(
                      'categories.png',
                      height: 22,
                      width: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    pushNewScreen(
                      context,
                      screen: const MyOrders(),
                      withNavBar: true,
                    );
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return const MyOrders();
                    // }));
                  },
                  child: ListTile(
                    title: const Align(
                        alignment: Alignment(-1.3, 0),
                        child: Text('My Orders')),
                    leading: Image.asset(
                      'my-orders.png',
                      height: 22,
                      width: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    auth.controller.jumpToTab(1);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //   return const TabsScreen(selectedPageIndex: 1);
                    // }));
                  },
                  child: ListTile(
                    title: const Align(
                        alignment: Alignment(-1.3, 0),
                        child: Text('Wishlist')),
                    leading: Image.asset(
                      'favourites.png',
                      height: 22,
                      width: 22,
                      color: Colors.black,
                    ),
                    // leading: Image.asset(
                    //   'favourites.png',
                    //   height: 22,
                    //   width: 22,
                    //   color: Colors.black38,
                    // ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    auth.controller.jumpToTab(3);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //   return const TabsScreen(selectedPageIndex: 3);
                    // }));
                  },
                  child: ListTile(
                    title: const Align(
                        alignment: Alignment(-1.35, 0),
                        child: Text('My account')),
                    // leading: Icon(Icons.person_outline, color: Colors.black54,),
                    leading: Image.asset(
                      "my-account.png",
                      height: 22,
                      width: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.black54,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const HelpAndSupportScreen();
                    }));
                  },
                  child: const ListTile(
                      title: Align(
                          alignment: Alignment(-1.3, 0),
                          child: Text('Help & Support')),
                      leading: Icon(
                        Icons.support_agent,
                        color: Colors.black,
                      )),
                ),
                token.isNotEmpty
                    ? InkWell(
                        onTap: () async {
                          Provider.of<Auth>(context, listen: false)
                              .logout()
                              .then((_) {
                            Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(
                                builder: (BuildContext context) {
                                  return const BottomNavBar();
                                },
                              ),
                              (_) => false,
                            );
                            // Navigator.pop(context);
                            // auth.controller.jumpToTab(0);
                          });
                          Box box1 = await Hive.openBox('user_info');
                          Box box2 = await Hive.openBox('address');
                         // await box1.deleteFromDisk();
                          await Hive.deleteFromDisk();
                          print(await box1.get('address'));
                        },
                        child: ListTile(
                          title: const Align(
                              alignment: Alignment(-1.3, 0),
                              child: Text('Sign Out')),
                          leading: Image.asset(
                            "logout.png",
                            height: 22,
                            width: 22,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()),
                          );
                        },
                        child: const ListTile(
                          title: Align(
                            alignment: Alignment(-1.4, 0),
                            child: Text('Log in/Sign Up'),
                          ),
                          leading: Icon(Icons.login, color: Colors.black),
                        ),
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
