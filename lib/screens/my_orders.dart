import 'dart:io';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/providers/product.dart';
import 'package:checkout_app/screens/auth_screen.dart';
import 'package:checkout_app/widgets/my_order_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:    Platform.isIOS? IconButton(icon:const Icon(Icons.arrow_back_ios,color:kBackgroundColor), onPressed:()=>Navigator.pop(context)) : IconButton(icon:const Icon(Icons.arrow_back, color:kBackgroundColor), onPressed:()=>Navigator.pop(context)),
        elevation: 0.1,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kDetailsScreenColor,
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              'My Orders',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: FutureBuilder(
        future:
            Provider.of<Product>(context, listen: false).fetchOrderHistories(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              //period:Duration(seconds:5),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child:SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:5,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: const [
                                    IgnorePointer(
                                      child: MyOrderList(
                                        orderId: '',
                                        totalPrice:  '',
                                        paymentType: '',
                                        status: '',
                                        totalItems:  9,
                                        dateAdded:  '',
                                        deliveryCharge:
                                            '',
                                        tax: '',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 95.0, right: 20),
                                      child: Divider(),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ));
          } else if(  Provider.of<Product>(context, listen: false).orderHistoryItems.isEmpty){

return Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 80),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'no-product-found.png',
                              ),
                            ),
                            const Text(
                              "No Orders Found.",
                              style: TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                      );
            } 
            
          
          else {
            if (dataSnapshot.error != null) {
              
              //error
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .25),
                    Image.asset(
                      'sign-in-to-continue.png',
                      height: 180,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Sign in to continue.",
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AuthScreen.routeName);
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(),
                        ),
                        color: kDarkButtonBg,
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 150, vertical: 15),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          side: const BorderSide(color: kDarkButtonBg),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            else {
              return Consumer<Product>(builder: (context, authData, child) {
                final orderList = authData.orderHistoryItems;
                return orderList.isNotEmpty
                    ? SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: orderList.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    MyOrderList(
                                      orderId: orderList[index].orderId,
                                      totalPrice: orderList[index].totalPrice,
                                      paymentType: orderList[index].paymentType,
                                      status: orderList[index].status,
                                      totalItems: orderList[index].totalItems,
                                      dateAdded: orderList[index].dateAdded,
                                      deliveryCharge:
                                          orderList[index].deliveryCharge,
                                      tax: orderList[index].tax,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 95.0, right: 20),
                                      child: Divider(),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      )
                    : Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 80),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'no-product-found.png',
                              ),
                            ),
                            const Text(
                              "No Orders Found.",
                              style: TextStyle(fontSize: 17),
                            )
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
