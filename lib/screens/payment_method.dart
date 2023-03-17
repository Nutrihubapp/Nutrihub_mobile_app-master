import 'dart:convert';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/order_confirm.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/notificationservice.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:checkout_app/screens/my_orders.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timezone/data/latest.dart' as tz;

class PaymentMethod extends StatefulWidget {
  final String? fcmToken;
  final String? paidPrice;
  final String? delivertoaddress;
  const PaymentMethod(
      {Key? key, this.paidPrice, this.delivertoaddress, this.fcmToken})
      : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String? _authToken = '';
  int orderId = 0;
  String paymentId = '0';
  Future<OrderConfirm>? futureConfirmOrder;

  Future<OrderConfirm> fetchData() async {
    // Dialogs.showLoadingDialog(context);
    _authToken = await SharedPreferenceHelper().getAuthToken();
    var url = BASE_URL +
        "api_frontend/confirm_order?payment_type=cash_on_delivery&fcm_token=${widget.fcmToken}&auth_token=$_authToken";
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        setState(() {
          orderId = jsonDecode(response.body)['order_id'];
        
        });
        await fetchPaymentId();
        await updatePaidPrice();
        await updatePaymentPriceData();

        NotificationService().showNotification(
            1, "Order Confirmation", "Order placed successfully", 1);
      }
      return OrderConfirm.fromJson(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  Future<OrderConfirm>? futurePaidPrice;
  fetchPaymentId() async {
   
    // Dialogs.showLoadingDialog(context);
    _authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        "https://greenersapp.com/greenersapp/api_frontend/payment_data?order_id=$orderId";
    try {
  
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        setState(() {
          paymentId = jsonDecode(response.body)['payment_id'];
        });
      }
      //   return OrderConfirm.fromJson(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  Future<OrderConfirm> updatePaidPrice() async {
    Box box1 = await Hive.openBox('user_info');
    final userMap = await box1.get('user_info');
    // Dialogs.showLoadingDialog(context);
    _authToken = await SharedPreferenceHelper().getAuthToken();
    var url = BASE_URL + "api_frontend/update_paid_price";
    try {
      final response = await http.post(Uri.parse(url), body: {
        'user_id': userMap['id'],
        'paid_price': double.parse(widget.paidPrice.toString()).toString(),
        'delivertoaddress': widget.delivertoaddress.toString(),
        'order_id': orderId.toString(),
      });
      print(response.body);
      if (response.statusCode == 200) {}
      return OrderConfirm.fromJson(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  Future<OrderConfirm> updatePaymentPriceData() async {
    Box box1 = await Hive.openBox('user_info');
    final userMap = await box1.get('user_info');
    // Dialogs.showLoadingDialog(context);
    _authToken = await SharedPreferenceHelper().getAuthToken();
    var url = BASE_URL + "api_frontend/update_paymentpaid_price";
    try {
      final response = await http.post(Uri.parse(url), body: {
        'user_id': userMap['id'],
        'paid_price': double.parse(widget.paidPrice.toString()).toString(),
        'order_id': orderId.toString(),
        'payment_id': paymentId,
      });
      print(response.body);
      if (response.statusCode == 200) {}
      return OrderConfirm.fromJson(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    futureConfirmOrder = fetchData();
    // if (orderId != 0) {
    // futurePaidPrice = updatePaidPrice();
    // }
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: kGreenColor,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Confirmation Alert',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder<OrderConfirm>(
          future: futureConfirmOrder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                  //period:Duration(seconds:5),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Image.asset(
                          'order-confirmation.PNG',
                          height: 180,
                        ),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(45.0),
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black45,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          //margin: EdgeInsets.symmetric(vertical: 0.0),
                          width: double.infinity,
                          height: 240.0,
                          child: Column(
                            children: [
                              Center(
                                child: MaterialButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 110),
                                  onPressed: () {},
                                  child: const Text(
                                    "My Orders",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  color: kGreenColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side:
                                          const BorderSide(color: kGreenColor)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Consumer<Auth>(
                                    builder: (context, auth, widget) {
                                  return MaterialButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 70),
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => const TabsScreen(
                                      //           selectedPageIndex: 0)),
                                      // );
                                    },
                                    child: const Text(
                                      "Continue Shopping",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    color: kDarkButtonBg,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                            color: kDarkButtonBg)),
                                  );
                                }),
                              ),
                            ],
                          ),
                        )
                      ]));
            } else {
              if (snapshot.error != null) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * .50,
                    child: Center(child: Text(snapshot.error.toString())));
              } else {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Image.asset(
                        'order-confirmation.PNG',
                        height: 180,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(45.0),
                          child: Text(
                            snapshot.data!.message.toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black45,
                               ),
                          ),
                        ),
                      ),
                      SizedBox(
                        //margin: EdgeInsets.symmetric(vertical: 0.0),
                        width: double.infinity,
                        height: 240.0,
                        child: Column(
                          children: [
                            Center(
                              child: MaterialButton(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 110),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  pushNewScreen(
                                    context,
                                    screen: const MyOrders(),
                                    withNavBar: true,
                                  );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => const MyOrders()),
                                  // );
                                },
                                child: const Text(
                                  "My Orders",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                color: kGreenColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(color: kGreenColor)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Consumer<Auth>(
                                  builder: (context, auth, widget) {
                                return MaterialButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 70),
                                  onPressed: () {
                                    auth.controller.jumpToTab(0);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => const TabsScreen(
                                    //           selectedPageIndex: 0)),
                                    // );
                                  },
                                  child: const Text(
                                    "Continue Shopping",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  color: kDarkButtonBg,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: kDarkButtonBg)),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
