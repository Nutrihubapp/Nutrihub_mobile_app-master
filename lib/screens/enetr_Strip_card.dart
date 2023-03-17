// ignore_for_file: file_names

import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

class StripeCards extends StatefulWidget {
  StripeCards({Key? key}) : super(key: key);

  @override
  State<StripeCards> createState() => _StripeCardsState();
}

class _StripeCardsState extends State<StripeCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // CardField(
        //   dangerouslyGetFullCardDetails: true,
        //   onCardChanged: (card) {
        //     print(card);
        //   },
        // ),
        // ElevatedButton(
        //     onPressed: () async {
        //       Stripe.publishableKey =
        //           "pk_test_51Kj0REDA2wq5Bk2EX6TwF0HHb6wiMHth4KkcVh4Ap5lDtuiAATLmyjBEfTQMpvVTqx9X3hcxoH16CSjPPDlgrPwp00La8Mzjnl";
        //       await Stripe.instance
        //           .createPaymentMethod(const PaymentMethodParams.card());
        //     },
        //     child: Text('Pay')),
      ],
    ));
  }
}
