import 'dart:async';
import 'dart:convert';

import 'package:checkout_app/models/cart_product.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/database_helper.dart';
import 'package:checkout_app/providers/fetch_data.dart';
import 'package:checkout_app/widgets/nav_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'account_screen.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'my_wishlist_screen.dart';

// class TabsScreen extends StatefulWidget {
//   final int? selectedPageIndex;

//   const TabsScreen({Key? key, this.selectedPageIndex}) : super(key: key);

//   @override
//   // ignore: no_logic_in_create_state
//   _TabsScreenState createState() => _TabsScreenState(selectedPageIndex);
// }

// class _TabsScreenState extends State<TabsScreen> {
//   int? _selectedPageIndex;
//   _TabsScreenState(this._selectedPageIndex);

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   var _isInit = true;
//   dynamic count = 0;
//   List data = [];
//   List<CartProduct> listProducts = [];
//   dynamic token;
//   var catData = [];
//   Timer? timer;

//   List<Widget> _pages = [
//     const HomeScreen(),
//     const LoginScreen(),
//     const LoginScreen(),
//     const LoginScreen(),
//   ];

//   @override
//   void didChangeDependencies() async {
//     if (_isInit) {
//       bool _isAuth;
//       dynamic userData;
//       dynamic response;

//       final prefs = await SharedPreferences.getInstance();
//       setState(() {
//         userData = (prefs.getString('userData') ?? '');
//       });
//       if (userData != null && userData.isNotEmpty) {
//         response = json.decode(userData);
//         setState(() {
//           token = response['token'];
//         });
//       }
//       if (token != null && token.isNotEmpty) {
//         _isAuth = true;
//       } else {
//         _isAuth = false;
//       }

//       if (_isAuth) {
//         _pages = [
//           const HomeScreen(),
//           const MyWishListScreen(),
//           const CartScreen(),
//           AccountScreen(),
//         ];
//       }

//       setState(() {
//         catData = Provider.of<FetchData>(context, listen: false).listProducts;
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(
//         const Duration(milliseconds: 200), (Timer t) => getCart());
//     // Provider.of<Auth>(context).tryAutoLogin().then((_) {});
//   }

//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }

//   Future<List<Map<String, dynamic>>?> getCart() async {
//     List<Map<String, dynamic>> listMap =
//         await DatabaseHelper.instance.queryAllRows('cart_list');
//     setState(() {
//       count = listMap.length;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void _selectPage(int index) {
//     setState(() {
//       _selectedPageIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         elevation: 0.1,
//         backgroundColor: kAppBarColor,
//         leading: Padding(
//           padding: const EdgeInsets.only(top: 12.0),
//           child: InkWell(
//             onTap: () => scaffoldKey.currentState!.openDrawer(),
//             child: const Icon(
//               Icons.dehaze_rounded,
//               size: 30,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//         title: Image.asset(
//           'Checkout-logo.png',
//           height: 30,
//           fit: BoxFit.contain,
//         ),
//         //backgroundColor: Color.fromRGBO(244, 246, 249, 1),
//         actions: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(top: 8, right: 25.0),
//             child: GestureDetector(
//               child: Stack(
//                 alignment: Alignment.topCenter,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 7.0),
//                     child: Align(
//                       alignment: Alignment.bottomRight,
//                       child: Image.asset(
//                         'shopping-bag.png',
//                         height: 35,
//                         width: 35,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 2.0, top: 18),
//                     child: Text(
//                       count.toString(),
//                       style: const TextStyle(
//                           
//                           fontSize: 15.0,
//                           color: kGreenColor),
//                     ),
//                   ),
//                 ],
//               ),
//               onTap: () {
//                 setState(() {
//                   _selectedPageIndex = 2;
//                 });
//               },
//             ),
//           )
//         ],
//       ),
//       drawer: const NavDrawer(),
//       body: _pages[_selectedPageIndex!],
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: _selectPage,
//         items: const [
//           BottomNavigationBarItem(
//             backgroundColor: kBackgroundColor,
//             icon: Icon(Icons.house),
//             label: 'Store',
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: kBackgroundColor,
//             icon: Icon(Icons.favorite_border),
//             label: 'Wishlist',
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: kBackgroundColor,
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: kBackgroundColor,
//             icon: Icon(Icons.account_circle),
//             label: 'Account',
//           ),
//         ],
//         backgroundColor: kBottomNavigationBarColor,
//         unselectedItemColor: kSecondaryColor,
//         selectedItemColor: Colors.black,
//         selectedIconTheme: const IconThemeData(color: kGreenColor),
//         iconSize: 24,
//         selectedFontSize: 11,
//         unselectedFontSize: 10,
//         currentIndex: _selectedPageIndex!,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }

class BottomNavBar extends StatefulWidget {
  final int? initialIndex;
  static const id = 'bottomnavbar';
  const BottomNavBar({Key? key, this.initialIndex}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int? _initialIndex;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int? _selectedPageIndex;
  //_TabsScreenState(this._selectedPageIndex);

  //final scaffoldKey = GlobalKey<ScaffoldState>();

  var _isInit = true;
  dynamic count = 0;
  List data = [];
  List<CartProduct> listProducts = [];
  dynamic token;
  var catData = [];
  Timer? timer;

  List<Widget> noLoginpages = [
    const HomeScreen(),
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),
  ];
  List<Widget> loginpages = [
    const HomeScreen(),
    const MyWishListScreen(),
    const CartScreen(),
    AccountScreen(),
  ];

  // List<Widget> _buildScreens() {
  //   return [
  //     const HomeScreen(),
  //     const MyWishListScreen(),
  //     const CartScreen(),
  //     const AccountScreen(),
  //     // DetailsScreen(),
  //     // DetailsScreen(),
  //   ];
  // }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      bool _isAuth;
      dynamic userData;
      dynamic response;

      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userData = (prefs.getString('userData') ?? '');
      });
      if (userData != null && userData.isNotEmpty) {
        response = json.decode(userData);
        setState(() {
          token = response['token'];
        });
      }
      if (token != null && token.isNotEmpty) {
        _isAuth = true;
      } else {
        _isAuth = false;
      }

      if (_isAuth) {
        loginpages = [
          const HomeScreen(),
          const MyWishListScreen(),
          const CartScreen(),
          AccountScreen(),
        ];
      }

      setState(() {
        catData = Provider.of<FetchData>(context, listen: false).listProducts;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(milliseconds: 200), (Timer t) => getCart());
    // Provider.of<Auth>(context).tryAutoLogin().then((_) {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<List<Map<String, dynamic>>?> getCart() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllRows('cart_list');
    setState(() {
      count = listMap.length;
      print(listMap.length);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  bool hasAppBar = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, widget) {
      auth.getAuthToken();
      return Scaffold(
        drawer: const NavDrawer(),
        key: scaffoldKey,
        // appBar: auth.controller.index == 2 ||
        //         auth.controller.index == 0 ||
        //         auth.controller.index == 1 ||
        //         auth.controller.index == 3
        //     ? auth.showAppBar == true
        //         ? AppBar(
        //             elevation: 0.1,
        //             backgroundColor: kAppBarColor,
        //             leading: Padding(
        //               padding: const EdgeInsets.only(top: 12.0),
        //               child: InkWell(
        //                 onTap: () => scaffoldKey.currentState!.openDrawer(),
        //                 child: const Icon(
        //                   Icons.dehaze_rounded,
        //                   size: 30,
        //                   color: Colors.black87,
        //                 ),
        //               ),
        //             ),
        //             title: Image.asset(
        //               'Checkout-logo.png',
        //               height: 30,
        //               fit: BoxFit.contain,
        //             ),
        //             //backgroundColor: Color.fromRGBO(244, 246, 249, 1),
        //             actions: <Widget>[
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 8, right: 25.0),
        //                 child: GestureDetector(
        //                   child: Stack(
        //                     alignment: Alignment.topCenter,
        //                     children: <Widget>[
        //                       Padding(
        //                         padding: const EdgeInsets.only(bottom: 7.0),
        //                         child: Align(
        //                           alignment: Alignment.bottomRight,
        //                           child: Image.asset(
        //                             'shopping-bag.png',
        //                             height: 35,
        //                             width: 35,
        //                           ),
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding:
        //                             const EdgeInsets.only(left: 2.0, top: 18),
        //                         child: Text(
        //                           count.toString(),
        //                           style: const TextStyle(
        //                               
        //                               fontSize: 15.0,
        //                               color: kGreenColor),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   onTap: () {
        //                     auth.controller.jumpToTab(2);
        //                   },
        //                 ),
        //               )
        //             ],
        //           )
        //         : null
        //     : null,
        body: PersistentTabView.custom(
        
          context,
          controller: auth.controller,

          itemCount:
              auth.userToken != null ? loginpages.length : noLoginpages.length,
          screens: auth.userToken != null ? loginpages : noLoginpages,
          //  items: _navBarsItems(),
          bottomScreenMargin: 0,
          confineInSafeArea: true,
          backgroundColor:Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: false, // Default is true.
          hideNavigationBar: false,
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.

          customWidget: CustomNavBarWidget(
            selectedIndex: auth.controller.index,
            items: [
              NavBarItem(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.house,
                      color: auth.controller.index == 0
                          ? kBottomNavigationBarColor
                          : kSecondaryColor,
                    ),
                    Text('Store',
                        style: TextStyle(
                          color: auth.controller.index == 0
                              ? kBottomNavigationBarColor
                              : kSecondaryColor,
                        ))
                  ],
                ),
              ),
              NavBarItem(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: auth.controller.index == 1
                          ? kBottomNavigationBarColor
                          : kSecondaryColor,
                    ),
                    Text('Wishlist',
                        style: TextStyle(
                          color: auth.controller.index == 1
                              ? kBottomNavigationBarColor
                              : kSecondaryColor,
                        ))
                  ],
                ),
              ),
              NavBarItem(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: auth.controller.index == 2
                          ?  kBottomNavigationBarColor
                          : kSecondaryColor,
                    ),
                    Text('Cart',
                        style: TextStyle(
                          color: auth.controller.index == 2
                              ?  kBottomNavigationBarColor
                              : kSecondaryColor,
                        ))
                  ],
                ),
              ),
              NavBarItem(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: auth.controller.index == 3
                          ?  kBottomNavigationBarColor
                          : kSecondaryColor,
                    ),
                    Text('Account',
                        style: TextStyle(
                          color: auth.controller.index == 3
                              ? kBottomNavigationBarColor
                              : kSecondaryColor,
                        ))
                  ],
                ),
              ),
            ],
            onItemSelected: (index) {
              setState(() {
                auth.controller.index =
                    index; // NOTE: THIS IS CRITICAL!! Don't miss it!
              });
            },
          ),

          screenTransitionAnimation: const ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.linear,
            duration: Duration(milliseconds: 200),
          ),
        ),
      );
    });
  }
}

class NavBarItem {
  final Widget image;

  NavBarItem(this.image);
}

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<NavBarItem>
      items; // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  final ValueChanged<int> onItemSelected;

  // ignore: use_key_in_widget_constructors
  const CustomNavBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  Widget _buildItem(NavBarItem item, bool isSelected) {
    return Container(
        alignment: Alignment.center,
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [item.image],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        color:kDetailsScreenColor,
      ),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              int index = items.indexOf(item);
              return GestureDetector(
                //  behavior: HitTestBehavior.translucent,
                onTap: () {
                  onItemSelected(index);

                  // if (selectedIndex == 0) {
                  //   print('yes');
                  //   Navigator.of(context).pushAndRemoveUntil(
                  //     CupertinoPageRoute(
                  //       builder: (BuildContext context) {
                  //         return BottomNavBar();
                  //       },
                  //     ),
                  //     (_) => false,
                  //   );
                  // }
                },
                child: _buildItem(item, selectedIndex == index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
