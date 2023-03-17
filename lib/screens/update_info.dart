import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/models/user_data.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/database_helper.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:checkout_app/widgets/nav_drawer.dart';
import 'package:checkout_app/widgets/progress_hud.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'address_screen.dart';

class UpdateInfo extends StatefulWidget {
  static const id = 'updateinfo';

  const UpdateInfo({
    Key? key,
  }) : super(key: key);

  @override
  _UpdateInfoState createState() => _UpdateInfoState();
}

bool load = false;

// ignore: non_constant_identifier_names

class _UpdateInfoState extends State<UpdateInfo> {
  File? _image;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  var _isLoading = false;
  dynamic token = "";
  dynamic userImage;

  Future<UserData>? futureUser;

  Future<UserData> fetchUser() async {
    token = await SharedPreferenceHelper().getAuthToken();
    final response = await http
        .get(Uri.parse(BASE_URL + "api_frontend/userdata?auth_token=$token"));
    if (response.statusCode == 200) {
      return UserData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load...');
    }
  }

  List containedAddress = [];

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();

    // timer = Timer.periodic(
    //     const Duration(milliseconds: 200), (Timer t) => getCartItems());
    //  awaitBox();
  }

  // awaitBox() async {
  //   box1 = await Hive.openBox('addresses_list');
  // }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  //final TextEditingController passwordController2 = TextEditingController();

  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Timer? timer;
  dynamic count = 0;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<List<Map<String, dynamic>>?> getCartItems() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllRows('cart_list');
    setState(() {
      count = listMap.length;
    });
  }

  getImage() {
    if (_imageFile == null) {
      return NetworkImage(userImage);
    } else {
      return FileImage(File(_imageFile!.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  InputDecoration getInputDecoration(
      String hintext, IconData iconData, Widget iconData2) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        borderSide: BorderSide(color: Colors.white, width: 2),
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
      suffixIcon: iconData2,
      prefixIcon: Icon(
        iconData,
        color: Colors.black38,
        // color: Color(0xFFc7c8ca),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const NavDrawer(),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: kAppBarColor,
        leadingWidth: MediaQuery.of(context).size.width*0.4,
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
            SizedBox(width: 10,),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Image.asset(
                'Checkout-logo.png',
                height: 52,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        //backgroundColor: Color.fromRGBO(244, 246, 249, 1),
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8, right: 25.0),
        //     child: GestureDetector(
        //       child: Stack(
        //         alignment: Alignment.topCenter,
        //         children: <Widget>[
        //           Padding(
        //             padding: const EdgeInsets.only(bottom: 7.0),
        //             child: Align(
        //               alignment: Alignment.bottomRight,
        //               child: Image.asset(
        //                 'shopping-bag.png',
        //                 height: 35,
        //                 width: 35,
        //               ),
        //             ),
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.only(left: 2.0, top: 18),
        //             child: Text(
        //               count.toString(),
        //               style: const TextStyle(
        //
        //                   fontSize: 15.0,
        //                   color: kGreenColor),
        //             ),
        //           ),
        //         ],
        //       ),
        //       onTap: () {
        //         Provider.of<Auth>(context, listen: false)
        //             .controller
        //             .jumpToTab(2);
        //       },
        //     ),
        //   )
        // ],
      ),
      // appBar: AppBar(
      //     elevation: 0.1,
      //     iconTheme: const IconThemeData(color: Colors.black),
      //     backgroundColor: Colors.white,
      //     leading: IconButton(
      //           icon: const Icon(Icons.arrow_back),
      //           onPressed: () {

      //             Navigator.pop(context);
      //           },

      //         ),
      //     title: Text(
      //       'Edit Profile',
      //       style: TextStyle(
      //
      //         color: Colors.black,
      //         fontSize: 18,
      //       ),
      //     )),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<UserData>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                  //period:Duration(seconds:5),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        fit: StackFit.loose,
                        alignment: Alignment.center,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 30.0,
                                      right: 15.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundImage: AssetImage(''),
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   flex: 1,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(
                              //         left: 10.0,
                              //         top: 15.0,
                              //         right: 15.0,
                              //         bottom: 15.0),
                              //     child: Column(
                              //       children: [
                              //         Padding(
                              //           padding:
                              //               const EdgeInsets.only(right: 8.0),
                              //           child: MaterialButton(
                              //             onPressed: () {
                              //               // Navigator.push(
                              //               //   context, MaterialPageRoute(
                              //               //     builder: (context) => TopProducts(),
                              //               //   ),
                              //               // );

                              //             },
                              //             color: kDarkButtonBg,
                              //             child: Row(
                              //               children: const [
                              //                 Padding(
                              //                   padding: EdgeInsets.only(
                              //                       left: 8.0),
                              //                   child: Icon(
                              //                     Icons.edit,
                              //                     color: Colors.white,
                              //                   ),
                              //                 ),
                              //                 Padding(
                              //                   padding: EdgeInsets.only(
                              //                       left: 4.0),
                              //                   child: Text(
                              //                     'Choose Image',
                              //                     style: TextStyle(
                              //                         fontSize: 15,
                              //                         fontWeight:
                              //                             FontWeight.w100,
                              //                         color: Colors.white),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //             padding: const EdgeInsets.all(0),
                              //             textColor: Colors.black87,
                              //             shape: RoundedRectangleBorder(
                              //               borderRadius:
                              //                   BorderRadius.circular(10.0),
                              //               // side: BorderSide(color: Color.fromRGBO(100, 186, 2, 1),)
                              //             ),
                              //           ),
                              //         ),
                              //         if (_image != null)
                              //           _isLoading
                              //               ? const Center(
                              //                   child:
                              //                       CircularProgressIndicator(),
                              //                 )
                              //               : Padding(
                              //                   padding:
                              //                       const EdgeInsets.only(
                              //                           right: 8.0),
                              //                   child: MaterialButton(
                              //                     onPressed:(){},
                              //                     color: Colors.grey,
                              //                     child: Row(
                              //                       children: const [
                              //                         Padding(
                              //                           padding:
                              //                               EdgeInsets.only(
                              //                                   left: 8.0),
                              //                           child: Icon(
                              //                             Icons
                              //                                 .upload_outlined,
                              //                             color: Colors.white,
                              //                           ),
                              //                         ),
                              //                         Padding(
                              //                           padding:
                              //                               EdgeInsets.only(
                              //                                   left: 4.0),
                              //                           child: Text(
                              //                             'Upload Image',
                              //                             style: TextStyle(
                              //                                 fontSize: 15,
                              //                                 fontWeight:
                              //                                     FontWeight
                              //                                         .w100,
                              //                                 color: Colors
                              //                                     .white),
                              //                           ),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     padding:
                              //                         const EdgeInsets.all(0),
                              //                     textColor: Colors.black87,
                              //                     shape:
                              //                         RoundedRectangleBorder(
                              //                       borderRadius:
                              //                           BorderRadius.circular(
                              //                               10.0),
                              //                       // side: BorderSide(color: Color.fromRGBO(100, 186, 2, 1),)
                              //                     ),
                              //                   ),
                              //                 )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "Edit Account",
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
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                    elevation: 0.6,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 6.0,
                                              right: 6.0,
                                              bottom: 6.0,
                                              top: 10.0),
                                          child: TextFormField(
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                            keyboardType: TextInputType.name,
                                            controller: nameController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Name is Required';
                                              }
                                              return null;
                                            },
                                            onSaved: (String? value) {},
                                            decoration: getInputDecoration(
                                                "Your Name",
                                                Icons.person_outline,
                                                const SizedBox()),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 6.0,
                                              right: 6.0,
                                              bottom: 6.0,
                                              top: 4.0),
                                          child: TextFormField(
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                            keyboardType: TextInputType.phone,
                                            controller: phoneController,
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Phone is Required';
                                              }
                                              return null;
                                            },
                                            onSaved: (String? value) {},
                                            decoration: getInputDecoration(
                                                "Mobile Number",
                                                Icons.phone,
                                                const SizedBox()),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                bottom: 6.0,
                                                top: 4.0),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0)),
                                                color: Color(0xFFF7F7F7),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Icon(Icons.house,
                                                        color:
                                                            Color(0xff9E9E9E)),
                                                    Expanded(
                                                      child: Center(child:
                                                          Consumer<Auth>(
                                                              builder: (context,
                                                                  auth,
                                                                  widget) {
                                                        //   auth.getUserAddress();
                                                        return GestureDetector(
                                                          onTap: () {},
                                                          child: Text(
                                                              auth.usersDefaultAddress
                                                                      .isNotEmpty
                                                                  ? auth
                                                                      .usersDefaultAddress
                                                                  : snapshot
                                                                      .data!
                                                                      .address
                                                                      .toString(),
                                                              style: const TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  fontSize:
                                                                      13)),
                                                        );
                                                      })),
                                                    ),
                                                    //  const Spacer(),
                                                    Consumer<Auth>(builder:
                                                        (context, auth,
                                                            widget) {
                                                      return GestureDetector(
                                                          onTap: () async {
                                                            pushNewScreen(
                                                              context,
                                                              screen:
                                                                  AddressScreen(),
                                                              withNavBar: true,
                                                            );
                                                            // Navigator.push(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //         builder:
                                                            //             (context) {
                                                            //   Provider.of<Auth>(
                                                            //           context,
                                                            //           listen:
                                                            //               false)
                                                            //       .getUserAddress();
                                                            //   return AddressScreen();
                                                            // }));
                                                          },
                                                          child: const Icon(
                                                              Icons.edit));
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            )),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                        ),
                                        //    ..._getFriends(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Consumer<Auth>(builder: (context, auth, widget) {
                        return IgnorePointer(
                          child: MaterialButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 70),
                            onPressed: () async {
                              final String name =
                                  nameController.text.toString();
                              final String phone =
                                  phoneController.text.toString();
                              final String address =
                                  addressController.text.toString();
                              var authToken =
                                  await SharedPreferenceHelper().getAuthToken();
                              if (!globalFormKey.currentState!.validate()) {
                                return;
                              }
                              if (name.isNotEmpty &&
                                  phone.isNotEmpty &&
                                  authToken != null &&
                                  auth.usersDefaultAddress.isNotEmpty) {
                                await auth.UpdateUser(name, phone,
                                        auth.usersDefaultAddress, authToken)
                                    .then((value) {
                                  Provider.of<Auth>(context, listen: false)
                                      .getUserInfo();
                                });

                                setState(() {
                                  // _user = user;
                                });
                                Navigator.pop(
                                    context, 'Profile updated successfully');
                                auth.controller.jumpToTab(3);
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(
                                //         builder: (context) => const TabsScreen(
                                //             selectedPageIndex: 3)),
                                //     (Route<dynamic> route) => false);
                              }
                            },
                            child: auth.load
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                            color: kGreenColor,
                            shape: const StadiumBorder(),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              } else {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  //WidgetsBinding.instance!.addPostFrameCallback((_) {
                  //  setState(() {
                  nameController = TextEditingController(
                      text: snapshot.data!.name.toString());
                  phoneController = TextEditingController(
                      text: snapshot.data!.phone.toString());
                  addressController = TextEditingController(
                      text: snapshot.data!.address.toString());
                  //   });
                  // });

                  // nameController.text = snapshot.data!.name.toString();
                  // phoneController.text = snapshot.data!.phone.toString();
                  // addressController.text = snapshot.data!.address.toString();

                  // aboutController.text = snapshot.data!.about.toString();
                  userImage = snapshot.data!.photo.toString();
                  return Form(
                    key: globalFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          fit: StackFit.loose,
                          alignment: Alignment.center,
                          children: [
                            Row(
                              children: const [
                                // Expanded(
                                //   flex: 1,
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(
                                //         left: 30.0,
                                //         right: 15.0,
                                //         top: 10.0,
                                //         bottom: 10.0),
                                //     child: CircleAvatar(
                                //       radius: 70,
                                //       backgroundImage: getImage(),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        Stack(
                          children: [

                            const Padding(
                              padding: EdgeInsets.only(left: 20, top: 20),
                              child: Text(
                                "Edit Account",
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
                                    padding: const EdgeInsets.all(4.0),
                                    child: Card(
                                      elevation: 0.6,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0,
                                                right: 6.0,
                                                bottom: 6.0,
                                                top: 10.0),
                                            child: TextFormField(
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              keyboardType: TextInputType.name,
                                              controller: nameController,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Name is Required';
                                                }
                                                return null;
                                              },
                                              onSaved: (String? value) {},
                                              decoration: getInputDecoration(
                                                  "Your Name",
                                                  Icons.person_outline,
                                                  const SizedBox()),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0,
                                                right: 6.0,
                                                bottom: 6.0,
                                                top: 4.0),
                                            child: TextFormField(
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              keyboardType: TextInputType.phone,
                                              controller: phoneController,
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return 'Phone is Required';
                                                }
                                                return null;
                                              },
                                              onSaved: (String? value) {},
                                              decoration: getInputDecoration(
                                                  "Mobile Number",
                                                  Icons.phone,
                                                  const SizedBox()),
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0,
                                                  right: 12.0,
                                                  bottom: 6.0,
                                                  top: 4.0),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  color: Color(0xFFF7F7F7),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Icon(Icons.house,
                                                          color: Color(
                                                              0xff9E9E9E)),
                                                      Expanded(
                                                        child: Center(child:
                                                            Consumer<Auth>(
                                                                builder:
                                                                    (context,
                                                                        auth,
                                                                        widget) {
                                                          //   auth.getUserAddress();
                                                          return GestureDetector(
                                                            onTap: () {
                                                              pushNewScreen(
                                                                context,
                                                                screen:
                                                                    AddressScreen(),
                                                                withNavBar:
                                                                    true,
                                                              );
                                                            },
                                                            child: Text(
                                                                auth.usersDefaultAddress
                                                                        .isNotEmpty
                                                                    ? auth
                                                                        .usersDefaultAddress
                                                                    : snapshot
                                                                        .data!
                                                                        .address
                                                                        .toString(),
                                                                style: const TextStyle(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    fontSize:
                                                                        13)),
                                                          );
                                                        })),
                                                      ),
                                                      //  const Spacer(),
                                                      Consumer<Auth>(builder:
                                                          (context, auth,
                                                              widget) {
                                                        return GestureDetector(
                                                            onTap: () async {
                                                              pushNewScreen(
                                                                context,
                                                                screen:
                                                                    AddressScreen(),
                                                                withNavBar:
                                                                    true,
                                                              );
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder:
                                                              //             (context) {
                                                              //   Provider.of<Auth>(
                                                              //           context,
                                                              //           listen:
                                                              //               false)
                                                              //       .getUserAddress();
                                                              //   return AddressScreen();
                                                              // }));
                                                            },
                                                            child: const Icon(
                                                                Icons.edit));
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                          ),
                                          //    ..._getFriends(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Consumer<Auth>(builder: (context, auth, widget) {
                          // return MaterialButton(
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 12, horizontal: 70),
                          //   onPressed: () async {
                          //     final String name =
                          //         nameController.text.toString();
                          //     final String phone =
                          //         phoneController.text.toString();
                          //     final String address =
                          //         addressController.text.toString();
                          //     var authToken =
                          //         await SharedPreferenceHelper().getAuthToken();
                          //     if (!globalFormKey.currentState!.validate()) {
                          //       return;
                          //     }
                          //     if (name.isNotEmpty &&
                          //         phone.isNotEmpty &&
                          //         authToken != null &&
                          //         auth.usersDefaultAddress.isNotEmpty) {
                          //       await auth.UpdateUser(name, phone,
                          //               auth.usersDefaultAddress, authToken)
                          //           .then((value) {
                          //         Provider.of<Auth>(context, listen: false)
                          //             .getUserInfo();
                          //       });
                          //
                          //       setState(() {
                          //         // _user = user;
                          //       });
                          //       Navigator.pop(
                          //           context, 'Profile updated successfully');
                          //       auth.controller.jumpToTab(3);
                          //       // Navigator.of(context).pushAndRemoveUntil(
                          //       //     MaterialPageRoute(
                          //       //         builder: (context) => const TabsScreen(
                          //       //             selectedPageIndex: 3)),
                          //       //     (Route<dynamic> route) => false);
                          //     }
                          //   },
                          //   child: auth.load
                          //       ? const Center(
                          //           child: CircularProgressIndicator())
                          //       : const Text(
                          //           "Update",
                          //           style: TextStyle(
                          //               color: Colors.white, fontSize: 18),
                          //         ),
                          //   color: kGreenColor,
                          //   shape: const StadiumBorder(),
                          // );
                          return MaterialButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 70),
                            onPressed: () async {
                              final String name =
                              nameController.text.toString();
                              final String phone =
                              phoneController.text.toString();
                              final String address =
                              addressController.text.toString();
                              var authToken =
                              await SharedPreferenceHelper().getAuthToken();
                              if (!globalFormKey.currentState!.validate()) {
                                return;
                              }
                              if (name.isNotEmpty &&
                                  phone.isNotEmpty &&
                                  authToken != null &&
                                  auth.usersDefaultAddress.isNotEmpty) {
                                await auth.UpdateUser(name, phone,
                                    auth.usersDefaultAddress, authToken)
                                    .then((value) {
                                  Provider.of<Auth>(context, listen: false)
                                      .getUserInfo();
                                });

                                setState(() {
                                  // _user = user;
                                });
                                Navigator.pop(
                                    context, 'Profile updated successfully');
                                auth.controller.jumpToTab(3);
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(
                                //         builder: (context) => const TabsScreen(
                                //             selectedPageIndex: 3)),
                                //     (Route<dynamic> route) => false);
                              }
                            },
                            child: Text(
                              "Update",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            color:  kGreenColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: kGreenColor)),
                          );
                        }),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  // List<Widget> _getFriends() {
  //   List<Widget> addressTextFieldsList = [];
  //   for (int i = 0; i < addressList.length; i++) {
  //     addressTextFieldsList.add(Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 16.0),
  //       child: Row(
  //         children: [
  //           Expanded(child: FriendTextFields(i)),
  //           const SizedBox(
  //             width: 16,
  //           ),
  //           // we need add button at last friends row only
  //           _addRemoveButton(i == addressList.length - 1, i),
  //         ],
  //       ),
  //     ));
  //   }
  //   return addressTextFieldsList;
  // }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 150,
      // width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Choose profile photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                                icon:
                    const Icon(Icons.camera_alt_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  takePhoto(ImageSource.camera);
                },
                label: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton.icon(

                icon: const Icon(
                  Icons.image_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  takePhoto(ImageSource.gallery);
                },
                label: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
      _image = File(pickedFile!.path);
    });
  }

  Future<void> _uploadFile(filePath) async {
    String fileName = basename(filePath.path);
    // print("file base name:$fileName");
    var token = await SharedPreferenceHelper().getAuthToken();
    try {
      FormData formData = FormData.fromMap({
        "auth_token": token,
        "user_image":
            await MultipartFile.fromFile(filePath.path, filename: fileName),
      });

      await Dio()
          .post(BASE_URL + "api_frontend/change_profile_photo", data: formData);
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('photo', filePath.path);

      // Response response = await Dio().post(BASE_URL + "api_frontend/change_profile_photo", data: formData);
      // print("File upload response: $response");
      // _showSnackBarMsg(response.data['message']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _submitImage(BuildContext pContext) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _uploadFile(_image);
      Provider.of<Auth>(pContext, listen: false).getUserInfo();
      CommonFunctions.showSuccessToast('Image uploaded Successfully');
    } on HttpException {
      var errorMsg = 'Upload failed.';
      CommonFunctions.showSuccessToast(errorMsg);
    } catch (error) {
      const errorMsg = 'Upload failed.';
      CommonFunctions.showSuccessToast(errorMsg);
    }

    setState(() {
      _isLoading = false;
    });
  }
}

// class FriendTextFields extends StatefulWidget {
//   final int index;
//   const FriendTextFields(this.index);
//   @override
//   _FriendTextFieldsState createState() => _FriendTextFieldsState();
// }

// class _FriendTextFieldsState extends State<FriendTextFields> {
//   TextEditingController? _nameController;
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameController!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       _nameController!.text = _UpdateInfoState.addressList[widget.index];
//     });
//     return TextFormField(
//       controller: _nameController,
//       // save text field data in friends list at index
//       // whenever text field value changes
//       onChanged: (v) => _UpdateInfoState.addressList[widget.index] = v,
//       decoration: const InputDecoration(hintText: 'Enter your friend\'s name'),
//       validator: (v) {
//         if (v!.trim().isEmpty) return 'Please enter something';
//         return null;
//       },
//     );
//   }
// }
