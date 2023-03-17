import 'dart:io';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/providers/product.dart';
import 'package:checkout_app/widgets/order_details_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? id;
  final String? status;
  final String? date;
  final String? amount;
  final String? deliveryCharge;
  final String? tax;

  const OrderDetailsScreen(this.id, this.status, this.date, this.amount,
      this.deliveryCharge, this.tax,
      {Key? key})
      : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
         leading:    Platform.isIOS? IconButton(icon:const Icon(Icons.arrow_back_ios,color:kBackgroundColor), onPressed:()=>Navigator.pop(context)) : IconButton(icon:const Icon(Icons.arrow_back, color:kBackgroundColor), onPressed:()=>Navigator.pop(context)),
        elevation: 0.1,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kGreenColor,
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              'Order Details',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<Product>(context, listen: false)
            .orderDetails(widget.id.toString()),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              //period:Duration(seconds:5),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Order ID #",
                            style:
                                TextStyle(color: Colors.black45, fontSize: 15),
                          ),
                        ),
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                          "",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  "Order Status",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ),
                              ),
                              Center(
                                child: Text(
                                  widget.status.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: const [
                              Center(
                                child: Text(
                                  "Order Added",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ),
                              ),
                              Center(
                                child: Text(
                                 "",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: const [
                              Center(
                                child: Text(
                                  "Order Amount",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ),
                              ),
                              Center(
                                child: Text(
                                "",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: const [
                              Center(
                                child: Text(
                                  "Delivery Charge",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ),
                              ),
                              Center(
                                child: Text(
                               "",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  "Tax",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ),
                              ),
                              const Center(
                                child: Text(
                                 "",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                      const Divider(),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 0.0),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        // height: MediaQuery.of(context).size.height * 75/100,
                        child: ListView.builder(
                            itemCount:5,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return const OrderDetailsList(
                                productId:"",
                                categoryId: "",
                                name:  "",
                                price: "",
                                discountPrice: "",
                                discount: "",
                                unit:  "",
                                thumbnail:  "",
                                itemQuantity: "",
                              );
                            }),
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
              return Consumer<Product>(builder: (context, authData, child) {
                final orderDetail = authData.orderProducts;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Order ID #",
                            style:
                                TextStyle(color: Colors.black45, fontSize: 15),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            widget.id.toString(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  "Order Status",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ),
                              ),
                              Center(
                                child: Text(
                                  widget.status.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  "Order Added",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ),
                              ),
                              Center(
                                child: Text(
                                  widget.date.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  "Order Amount",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ),
                              ),
                              Center(
                                child: Text(
                                  widget.amount.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  "Delivery Charge",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ),
                              ),
                              Center(
                                child: Text(
                                  widget.deliveryCharge.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                          Expanded(
                              child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  "Tax",
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 15),
                                ),
                              ),
                              Center(
                                child: Text(
                                  widget.tax.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                      const Divider(),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 0.0),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        // height: MediaQuery.of(context).size.height * 75/100,
                        child: ListView.builder(
                            itemCount: orderDetail.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return OrderDetailsList(
                                productId: orderDetail[index].productId,
                                categoryId: orderDetail[index].categoryId,
                                name: orderDetail[index].name,
                                price: orderDetail[index].price,
                                discountPrice: orderDetail[index].discountPrice,
                                discount: orderDetail[index].discount,
                                unit: orderDetail[index].unit,
                                thumbnail: orderDetail[index].thumbnail,
                                itemQuantity: orderDetail[index].itemQuantity,
                              );
                            }),
                      ),
                      Gap(60),
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
