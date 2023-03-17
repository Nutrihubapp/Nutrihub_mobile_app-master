import 'dart:convert';

import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/database_helper.dart';
import 'package:checkout_app/providers/hive_database_helper.dart';
import 'package:checkout_app/screens/online_pay_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

String tokenKey =
    "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";
  // "sk_test_51KiexYLlY2bBukWkxX5JNQ3clx3ZhzRU0PDJnhPxcUXbtB67gV6pKOLHPM2peiiNhEa6zweg0Q6ubJqMw3zhHPkB00ZBq3e5oi";

class Payment {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(
      {required String amount,
        required String currency,
        var context,
        paytype,
        fcmToken,
        price,
        deliveryFee}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      print(paymentIntentData!['ephemeralSecret']);
      if (paymentIntentData != null) {
        //  StripePaymentIntenOutput? intent = await StripeAppService.instance
        //       .createTipPayment(stripePaymentInput);

        // await Stripe.instance.initPaymentSheet(
        //     paymentSheetParameters: SetupPaymentSheetParameters(
        //       applePay: true,
        //       googlePay: true,
        //       //   style: ThemeMode.light,
        //       testEnv: false,
        //       merchantCountryCode: 'US',
        //       merchantDisplayName: 'Prospects',
        //       customerId: paymentIntentData!['customer'],
        //       paymentIntentClientSecret: paymentIntentData!['client_secret'],
        //       setupIntentClientSecret: paymentIntentData!['client_secret'],
        //       customerEphemeralKeySecret: paymentIntentData!['client_secret'],
        //     ));

        displayPaymentSheet(context, paytype, fcmToken, amount, deliveryFee);
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(context, paytype, fcmToken, price, deliveryPrice) async {
    // try {
      // await Stripe.instance.presentPaymentSheet();
      print('payment success');
      //await DatabaseHelper.instance.removeCart();
      await HiveDatabase.clearCart();
      print(paytype);
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OnlinePaySuccessScreen(
                  delivertoaddress:
                  Provider.of<Auth>(context, listen: false)
                      .usersDefaultAddress
                      .toString(),
                  paymentType: paytype,
                  fcmToken: fcmToken,
                  price: '${double.parse(price) - deliveryPrice}',
                )));
      });
    }
    // on Exception catch (e) {
    //   if (e is StripeException) {
    //     // print("Error from Stripe: ${e.error.localizedMessage}");
    //   } else {
    //     print("Unforeseen error: $e");
    //   }
    // } catch (e) {
    //   print("exception:$e");
    // }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            ///change the token key here
            'Authorization': " Bearer $tokenKey",
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    if (amount.contains(".")) {
      final String number = ((double.parse(amount) * 10) ~/ 1).toString();
      final result = double.parse(amount) * 100;
      print(' result ${result.round()}');
      return result.round().toString();
    } else {
      final a = (int.parse(amount)) * 100;
      return a.toString();
    }
  }
// }
