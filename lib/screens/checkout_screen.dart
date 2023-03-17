import 'dart:async';
import 'dart:convert';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/api_checkout_class.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/models/payment_class.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/database_helper.dart';
import 'package:checkout_app/providers/fetch_data.dart';
import 'package:checkout_app/providers/hive_database_helper.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:checkout_app/screens/address_screen.dart';
import 'package:checkout_app/widgets/nav_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'online_pay_success_screen.dart';
import 'payment_method.dart';

enum SingingCharacter { onDelivery, paypal, razorpay, paytm, stripe }

class CheckoutScreen extends StatefulWidget {
  String? totalPrice;

  CheckoutScreen({Key? key, this.totalPrice}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  dynamic _authToken;
  var data = '';

  SingingCharacter? _character = SingingCharacter.onDelivery;

  Future<ApiCheckoutClass>? checkout;

  Future<ApiCheckoutClass> fetchCheckoutCart() async {
    _authToken = await SharedPreferenceHelper().getAuthToken();
    final response = await http.get(
        Uri.parse(BASE_URL + "api_frontend/checkout?auth_token=$_authToken"));
    if (response.statusCode == 200) {
      return ApiCheckoutClass.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load...');
    }
  }

  String s = "";

  //List userAddresses = [];
  // Future<void> getUserAddress() async {
  //   print(Provider.of<Auth>(context, listen: false).user.userId);
  //   var authToken = await SharedPreferenceHelper().getAuthToken();
  //   var url1 = BASE_URL + 'api_frontend/userdata?auth_token=$authToken';
  //   final response1 = await http.get(Uri.parse(url1));
  //   final responseData = json.decode(response1.body);
  //   var url =
  //       "https://greenersapp.com/greenersapp/api_frontend/address?userid=${responseData['user_id']}";
  //   try {
  //     final response = await http.get(Uri.parse(url),
  //         headers: {'Content-type': ' application/json', 'Charset': 'utf-8'});
  //     if (response.statusCode == 200) {
  //       var parseJson = parse(response.body);
  //       List decodedAddress = jsonDecode(parseJson.body!.innerHtml);
  //       print(decodedAddress);
  //       setState(() {
  //         userAddresses = decodedAddress;
  //       });
  //     }
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  List containedAddress = [];
  var _isInit = true;
  var _isLoading = false;
  List couponList = [];
  dynamic count = 0;
  Timer? timer;
  final TextEditingController discountController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<FetchData>(context).fetchCuponCode().then((_) {
        setState(() {
          _isLoading = false;
          couponList =
              Provider.of<FetchData>(context, listen: false).couponList;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    checkout = fetchCheckoutCart();
    timer = Timer.periodic(
        const Duration(milliseconds: 200), (Timer t) => getHiveCartLength());
    //getUserAddress();
    containedAddress
        .add(Provider.of<Auth>(context, listen: false).usersDefaultAddress);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<List<Map<String, dynamic>>?> getHiveCartLength() async {
    var listMap = await HiveDatabase.getAllCartItems();
    setState(() {
      count = listMap.length;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Provider.of<Auth>(context, listen: false).changeAppBar(true);
    bool couponIsApplied = false;
    String newPrice = "";
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool couponIsApplied = false;
  String newPrice = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
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
      // appBar: AppBar(
      //   elevation: 1,
      //   leading: Consumer<Auth>(builder: (context, auth, widget) {
      //     return IconButton(
      //         icon: const Icon(Icons.arrow_back),
      //         onPressed: () {
      //           auth.changeFromCheckout(false);
      //           print(auth.fromCheckout);
      //           auth.changeAppBar(true);
      //           Navigator.pop(context);
      //         });
      //   }),
      //   iconTheme: const IconThemeData(color: Colors.black),
      //   backgroundColor: Colors.white,
      //   title: Image.asset(
      //     'Checkout-logo.png',
      //     height: 35,
      //     fit: BoxFit.contain,
      //   ),
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<ApiCheckoutClass>(
            future: checkout,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 100.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 18),
                            child: Text(
                              Provider.of<Auth>(context, listen: false)
                                      .updatedName
                                      .isEmpty
                                  ? snapshot.data!.userName.toString()
                                  : Provider.of<Auth>(context, listen: false)
                                      .updatedName,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, bottom: 10),
                                child: snapshot.data!.address.toString() == ''
                                    ? const Text(
                                        "Enter-Delivery-Address",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w100),
                                      )
                                    :
                                    // Consumer<Auth>(
                                    //     builder: (context, auth, widget) {
                                    //     return
                                    GestureDetector(
                                        onTap: () {
                                          Provider.of<Auth>(context,
                                                  listen: false)
                                              .getUserInfo();
                                          pushNewScreen(
                                            context,
                                            screen: AddressScreen(),
                                            withNavBar: true,
                                          );
                                        },
                                        child: Text(Provider.of<Auth>(context,
                                                    listen: false)
                                                .usersDefaultAddress
                                                .isNotEmpty
                                            ? Provider.of<Auth>(context,
                                                    listen: false)
                                                .usersDefaultAddress
                                            : containedAddress.isNotEmpty
                                                ? containedAddress[0].isNotEmpty
                                                    ? containedAddress[0]
                                                    : "select an address"
                                                : "select an address"),
                                      ),
                                // }),
                                //   : Text('')),
                              )),
                              // Consumer<Auth>(builder: (context, auth, widget) {
                              //   auth.changeFromCheckout(true);
                              //   return
                              IconButton(
                                  icon: const Icon(
                                    Icons.edit_location_outlined,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    Provider.of<Auth>(context, listen: false)
                                        .getUserInfo();
                                    pushNewScreen(
                                      context,
                                      screen: AddressScreen(),
                                      withNavBar: true,
                                    );
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           const UpdateInfo()),
                                    // );
                                  }),
                              // })
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      width: double.infinity,
                      height: 30.0,
                      child: Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Payment:",
                          style: TextStyle(fontSize: 20, color: Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      // height: 40.0,
                      child: Column(
                        children: [
                          RadioListTile<SingingCharacter>(
                            title: const Text(
                              'Cash on Delivery',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black45),
                            ),
                            value: SingingCharacter.onDelivery,
                            groupValue: _character,
                            selected: true,
                            onChanged: (SingingCharacter? value) {
                              print(value);
                              setState(() {
                                _character = value!;
                              });
                            },
                          ),
                          // if (snapshot.data!.paypal == "1")
                          //   RadioListTile<SingingCharacter>(
                          //     title: const Text(
                          //       'Paypal',
                          //       style: TextStyle(
                          //           fontSize: 16, color: Colors.black45),
                          //     ),
                          //     value: SingingCharacter.paypal,
                          //     groupValue: _character,
                          //     onChanged: (SingingCharacter? value) {
                          //       setState(() {
                          //         _character = value!;
                          //       });
                          //     },
                          //   ),
                          // if (snapshot.data!.razorpay == "1")
                          //   RadioListTile<SingingCharacter>(
                          //     title: const Text(
                          //       'Razorpay',
                          //       style: TextStyle(
                          //           fontSize: 16,
                          //           fontWeight: FontWeight.w100,
                          //           color: Colors.black45),
                          //     ),
                          //     value: SingingCharacter.razorpay,
                          //     groupValue: _character,
                          //     onChanged: (SingingCharacter? value) {
                          //       setState(() {
                          //         _character = value!;
                          //       });
                          //     },
                          //   ),
                          // if (snapshot.data!.paytm == "1")
                          //   RadioListTile<SingingCharacter>(
                          //     title: const Text(
                          //       'Pay by Card',
                          //       style: TextStyle(
                          //           fontSize: 16,
                          //           fontWeight: FontWeight.w100,
                          //           color: Colors.black45),
                          //     ),
                          //     value: SingingCharacter.stripe,
                          //     groupValue: _character,
                          //     onChanged: (SingingCharacter? value) {
                          //       setState(() {
                          //         _character = value!;
                          //       });
                          //     },
                          //   ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Container(
                      width: double.infinity,
                      height: 285,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: ListView(
                        children: [
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Items',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 22),
                                ),
                                Text(
                                  snapshot.data!.totalItems.toString() +
                                      ' ' +
                                      "Items",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.text,
                            controller: discountController,
                            // onSaved: (input) => loginRequestModel!.password = input,
                            validator: (input) => input!.length < 3
                                ? "Password should be more than 3 characters"
                                : null,
                            //  obscureText: hidePassword,
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0)),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(15.0)),
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
                                hintText: "Discount Code",
                                fillColor: const Color(0xFFF7F7F7),
                                contentPadding: const EdgeInsets.only(
                                    left: 14, top: 20, right: 14, bottom: 20),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        for (var e in couponList) {
                                          if (discountController.text.trim() ==
                                                  e['code'] &&
                                              e['type'] == "2") {
                                            final totalAmount = double.parse(
                                                snapshot.data!.totalPrice
                                                    .toString()
                                                    .substring(1));
                                            final percentageAmountCalculated =
                                                (double.parse(e['number']) *
                                                        totalAmount) /
                                                    100;
                                            setState(() {
                                              couponIsApplied = true;

                                              newPrice = (totalAmount -
                                                      percentageAmountCalculated)
                                                  .toString();
                                            });

                                            CommonFunctions.showSuccessToast(
                                                "discount is applied");
                                          }
                                          if (discountController.text.trim() ==
                                                  e['code'] &&
                                              e['type'] == "1") {
                                            final totalAmount = double.parse(
                                                snapshot.data!.totalPrice
                                                    .toString()
                                                    .substring(1));
                                            final minusAmountCalculated =
                                                double.parse(e['number']);
                                            setState(() {
                                              couponIsApplied = true;
                                              newPrice = (totalAmount -
                                                      minusAmountCalculated)
                                                  .toString();
                                            });
                                            CommonFunctions.showSuccessToast(
                                                "discount is applied");
                                          }
                                          if (discountController.text.isEmpty) {
                                            return CommonFunctions
                                                .showSuccessToast(
                                                    "enter a discount code");
                                          }
                                        }
                                      },
                                      child: const Text('Apply')),
                                )),
                          ),
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Discount Code Applied',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                couponIsApplied
                                    ? const Icon(Icons.check,
                                        color: kGreenColor)
                                    : const Icon(Icons.cancel,
                                        color: Colors.red),
                              ],
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Price',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                Text(
                                  newPrice.isNotEmpty
                                      ? '\$$newPrice'
                                      : snapshot.data!.totalPrice.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          /* const Divider(),*/
                          /* ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                */ /*Row(
                                  children: [
                                    const Text(
                                      'Tax',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "(${snapshot.data!.taxVal})",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.black45),
                                    ),
                                  ],
                                ),*/ /*
                               */ /* Text(
                                  snapshot.data!.tax.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.blue),
                                ),*/ /*
                              ],
                            ),
                          ),*/
                          const Divider(),
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Delivery Charge',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16),
                                ),
                                Text(
                                  snapshot.data!.deliveryCharge.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 16,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Grand Total Price',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 16),
                                ),
                                Text(
                                  newPrice.isNotEmpty
                                      ? '\$${double.parse(newPrice) + double.parse(snapshot.data!.deliveryCharge.toString().substring(1))}' //currencytochange
                                      : '\$${double.parse(snapshot.data!.grandTotalPrice.toString().substring(1))}', //currencytochange
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 16,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: MaterialButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 70),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(
                                      //context,
                                      snapshot.data!.grandTotalPrice
                                          .toString()
                                          .substring(1),
                                      snapshot.data!.deliveryCharge
                                          .toString()));
                        },
                        child: const Text(
                          "Confirm Order",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        color: kGreenColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: kGreenColor)),
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return Shimmer.fromColors(
                  //period:Duration(seconds:5),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 18),
                              child: Text(
                                '',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w100),
                              ),
                            ),
                            Row(
                              children: [
                                const Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 18.0, bottom: 10),
                                        child: Text(
                                          "Enter-Delivery-Address",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w100),
                                        )

                                        // }),
                                        //   : Text('')),
                                        )),
                                // Consumer<Auth>(builder: (context, auth, widget) {
                                //   auth.changeFromCheckout(true);
                                //   return
                                IconButton(
                                    icon: const Icon(
                                      Icons.edit_location_outlined,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const UpdateInfo()),
                                      // );
                                    }),
                                // })
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        width: double.infinity,
                        height: 30.0,
                        child: Padding(
                          padding: EdgeInsets.only(left: 18),
                          child: Text(
                            "Payment:",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w100,
                                color: Colors.black87),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 120.0,
                        child: Column(
                          children: const [],
                        ),
                      ),
                      const Divider(),
                      Container(
                        width: double.infinity,
                        height: 285,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: ListView(
                          children: [
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Total Items',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 22),
                                  ),
                                  Text(
                                    ' ' + "Items",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              controller: discountController,
                              // onSaved: (input) => loginRequestModel!.password = input,
                              validator: (input) => input!.length < 3
                                  ? "Password should be more than 3 characters"
                                  : null,
                              //  obscureText: hidePassword,
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0)),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(15.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
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
                                  hintText: "coupon code",
                                  fillColor: const Color(0xFFF7F7F7),
                                  contentPadding: const EdgeInsets.only(
                                      left: 14, top: 20, right: 14, bottom: 20),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: GestureDetector(
                                        onTap: () {},
                                        child: const Text('Apply')),
                                  )),
                            ),
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Coupon Code Applied',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  couponIsApplied
                                      ? const Icon(Icons.check,
                                          color: kGreenColor)
                                      : const Icon(Icons.cancel,
                                          color: Colors.red),
                                ],
                              ),
                            ),
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Total Price',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        'Tax',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.black45),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Delivery Charge',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Grand Total Price',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 16,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: MaterialButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 70),
                          onPressed: () {},
                          child: const Text(
                            "Confirm Order",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          color: kGreenColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: kGreenColor)),
                        ),
                      ),
                      const SizedBox(height: 70),
                    ],
                  ));
            },
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _buildPopupDialog(totalPrice, deliveryCharge) {
    // ignore: non_constant_identifier_names
    var Msg = "Do you want to confirm your order?";
    return AlertDialog(
      title: const Text('Notifying'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(Msg),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('No'),
        ),
        MaterialButton(
          onPressed: () async {
            if (Provider.of<Auth>(context, listen: false)
                .usersDefaultAddress
                .isEmpty) {
              Navigator.of(context, rootNavigator: true).pop();
              CommonFunctions.showSuccessToast('please select an address');
            } else {
              dynamic fcmToken = await FirebaseMessaging.instance.getToken();
              print(fcmToken);
              if (_character != null) {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PaymentMethod(
                      delivertoaddress:
                          Provider.of<Auth>(context, listen: false)
                              .usersDefaultAddress
                              .toString(),
                      fcmToken: fcmToken,
                      paidPrice: newPrice.isNotEmpty
                          ? '${double.parse(newPrice) + double.parse(deliveryCharge)}'
                          : '${double.parse(totalPrice)}',
                    );
                  }));
                  //    await DatabaseHelper.instance.removeCart();
                  await HiveDatabase.clearCart();

                //                 else if (_character == SingingCharacter.razorpay) {
                //   var razorpay = "razorpay";
                //   Navigator.of(context).pop();
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => OnlinePaySuccessScreen(
                //               delivertoaddress:
                //                   Provider.of<Auth>(context, listen: false)
                //                       .usersDefaultAddress
                //                       .toString(),
                //               paymentType: razorpay,
                //               fcmToken: fcmToken,
                //             )),);
                // } else if (_character == SingingCharacter.stripe) {
                //   final payment = Payment();
                //   var paytm = "stripe";
                //   Navigator.of(context, rootNavigator: true).pop();
                //   /*print(double.parse(totalPrice.substring(1)));*/
                //
                //   // await payment
                //   payment
                //       .makePayment(
                //         amount:
                //             //"1020.00",
                //             newPrice.isNotEmpty
                //                 ? '${double.parse(newPrice) + double.parse(deliveryCharge.substring(1))}'
                //                 : '${double.parse(totalPrice)}',
                //         currency: 'USD',
                //         context: context,
                //         paytype: paytm,
                //         fcmToken: fcmToken,
                //         deliveryFee: double.parse(deliveryCharge.substring(1)),
                //       )
                //       .then((value) {});
                //   // final _links = [
                //   //   BASE_URL +
                //   //       'payment/online_payment/${snapshot.data!.orderId}/${}'
                //   // ];
                //   // _links
                //   //     .map((link) => _handleURLButtonPress(
                //   //         context, link))
                //   //     .toList();
                //   //   Navigator.of(context).pop();
                //
                // } else {
                //   var paypal = "paypal";
                //   Navigator.of(context).pop();
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => OnlinePaySuccessScreen(
                //               paymentType: paypal,
                //               fcmToken: fcmToken,
                //             )),
                //   );
                // }
              }
            }
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Confirm'),
        ),
      ],
    );
    // return PopDialog.buildPopupDialog(context, extractedData);
  }
}

//  Provider.of<FetchData>(context).checkShopTime().then((_) {
//         _isLoading = false;
//         shopClosingTime =
//             Provider.of<FetchData>(context, listen: false).closingTime;
//       });
