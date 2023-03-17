import 'dart:convert';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/order_confirm.dart';
import 'package:checkout_app/models/payment_class.dart';
import 'package:checkout_app/providers/notificationservice.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:checkout_app/screens/my_orders.dart';
import 'package:checkout_app/screens/webview_container.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:stripe_payment/stripe_payment.dart';
import 'package:timezone/data/latest.dart' as tz;

class OnlinePaySuccessScreen extends StatefulWidget {
  final String? paymentType;
  final String? fcmToken;
  final String? delivertoaddress;
  final String? price;

  const OnlinePaySuccessScreen(
      {Key? key,
      this.price,
      this.paymentType,
      this.delivertoaddress,
      this.fcmToken})
      : super(key: key);

  @override
  _OnlinePaySuccessScreenState createState() => _OnlinePaySuccessScreenState();
}

class _OnlinePaySuccessScreenState extends State<OnlinePaySuccessScreen> {
  String? _authToken = '';
  String? btnText;
  dynamic edges;

  String paymentId = '0';
  // Token? _paymentToken;
  // //PaymentMethod? _paymentMethod;
  // String? _error;
  // final String? _paymentIntentClientSecret = null;

  // PaymentIntentResult? _paymentIntent;
  // Source? _source;
  final ScrollController _controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // final CreditCard testCard = CreditCard(
  //   number: '4000002760003184',
  //   expMonth: 12,
  //   expYear: 21,
  //   name: 'Test User',
  //   cvc: '133',
  //   addressLine1: 'Address 1',
  //   addressLine2: 'Address 2',
  //   addressCity: 'City',
  //   addressState: 'CA',
  //   addressZip: '1337',
  // );

  Future<OrderConfirm>? futureConfirmOrder;
  int orderId = 0;
  Future<OrderConfirm> fetchData() async {
    // Dialogs.showLoadingDialog(context);
    _authToken = await SharedPreferenceHelper().getAuthToken();
    print(_authToken);
    var url = BASE_URL +
        "api_frontend/confirm_order?payment_type=online_payment&fcm_token=${widget.fcmToken}&auth_token=$_authToken";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          orderId = jsonDecode(response.body)['order_id'];
          print(jsonDecode(response.body));
        });
        NotificationService().showNotification(
            1, "Order Confirmation", "Order placed successfully", 1);
        await fetchPaymentId();
       await updatePaidPrice();
         await updatePaymentPriceData();
      }

      return OrderConfirm.fromJson(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  fetchPaymentId() async {
    Box box1 = await Hive.openBox('user_info');
    final userMap = await box1.get('user_info');
    // Dialogs.showLoadingDialog(context);
    _authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        "https://greenersapp.com/greenersapp/api_frontend/payment_data?order_id=$orderId";
    try {
      print(widget.price.toString());
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
      print(widget.price.toString());
      final response = await http.post(Uri.parse(url), body: {
        'user_id': userMap['id'],
        'paid_price': double.parse(widget.price.toString()).toString(),
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
        'paid_price': double.parse(widget.price.toString()).toString(),
        'delivertoaddress': widget.delivertoaddress.toString(),
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

  final payment = Payment();
  @override
  void initState() {
    super.initState();
    futureConfirmOrder = fetchData();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.paymentType == "paypal") {
      btnText = "Pay By Paypal";
      edges = const EdgeInsets.symmetric(vertical: 10, horizontal: 95);
    } else if (widget.paymentType == "razorpay") {
      btnText = "Pay By Razorpay";
      edges = const EdgeInsets.symmetric(vertical: 10, horizontal: 80);
    } else {
      btnText = "Pay By Stripe";
      edges = const EdgeInsets.symmetric(vertical: 10, horizontal: 95);
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
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
                            "My Orders",
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
                                    side: const BorderSide(color: kGreenColor)),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                if (snapshot.error != null) {
                  return const Text("Error Occoured");
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
                                    pushNewScreen(
                                      context,
                                      screen: const MyOrders(),
                                      withNavBar: true,
                                    );
                                  },
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
                              // Center(
                              //   child: MaterialButton(
                              //     padding: edges,
                              //     onPressed: () async {
                              //       // await Stripe.instance.presentPaymentSheet();
                              //       //  print(widget.paymentType);
                              //       if (widget.paymentType == "stripe") {
                              //         print('stripe');
                              //         await payment.makePayment(
                              //             amount: widget.price
                              //                 .toString()
                              //                 .substring(1),
                              //             currency: 'USD');
                              //         final _links = [
                              //           BASE_URL +
                              //               'payment/online_payment/${snapshot.data!.orderId}/${snapshot.data!.paymentType}'
                              //         ];
                              //         _links
                              //             .map((link) => _handleURLButtonPress(
                              //                 context, link))
                              //             .toList();
                              //       }else{

                              //       }
                              //       final _links = [
                              //         BASE_URL +
                              //             'payment/online_payment/${snapshot.data!.orderId}/${snapshot.data!.paymentType}'
                              //       ];
                              //       _links
                              //           .map((link) => _handleURLButtonPress(
                              //               context, link))
                              //           .toList();
                              //     },
                              //     child: Text(
                              //       btnText.toString(),
                              //       style: const TextStyle(
                              //           color: Colors.white, fontSize: 18),
                              //     ),
                              //     color: kDarkButtonBg,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(10.0),
                              //         side: const BorderSide(
                              //             color: kDarkButtonBg)),
                              //   ),
                              // ),
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
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    // print(url);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}
