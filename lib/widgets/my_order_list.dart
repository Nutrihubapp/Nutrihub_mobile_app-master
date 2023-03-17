import 'package:checkout_app/screens/order_details.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MyOrderList extends StatefulWidget {
  final String? orderId;
  final String? totalPrice;
  final String? paymentType;
  final String? status;
  final int? totalItems;
  final String? dateAdded;
  final String? deliveryCharge;
  final String? tax;

  const MyOrderList(
      {Key? key,
      this.orderId,
      this.totalPrice,
      this.paymentType,
      this.status,
      this.totalItems,
      this.dateAdded,
      this.deliveryCharge,
      this.tax})
      : super(key: key);

  @override
  _MyOrderListState createState() => _MyOrderListState();
}

class _MyOrderListState extends State<MyOrderList> {
  dynamic img;
  dynamic color;
  dynamic iconColor;

  @override
  Widget build(BuildContext context) {
    if (widget.status == 'Pending') {
      setState(() {
        img = 'order-status-pending.PNG';
        // iconColor = Colors.deepOrange;
        color = const Color.fromRGBO(240, 212, 212, 1);
      });
    } else if (widget.status == 'Processing') {
      setState(() {
        img = 'order-status-processing.PNG';
        // iconColor = Colors.orange;
        color = const Color.fromRGBO(234, 229, 187, 1);
      });
    } else if (widget.status == 'Delivered') {
      setState(() {
        img = 'order-status-delivered.PNG';
        // iconColor = Colors.green;
        color = const Color.fromRGBO(206, 233, 199, 1);
      });
    } else if (widget.status == 'Canceled') {
      setState(() {
        img = 'cancelled.png';
        // iconColor = Colors.black45;
        color = const Color.fromRGBO(224, 224, 224, 1);
      });
    }
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: OrderDetailsScreen(
              widget.orderId,
              widget.status,
              widget.dateAdded,
              widget.totalPrice,
              widget.deliveryCharge,
              widget.tax),
          withNavBar: true,
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => OrderDetailsScreen(
        //           widget.orderId,
        //           widget.status,
        //           widget.dateAdded,
        //           widget.totalPrice,
        //           widget.deliveryCharge,
        //           widget.tax)),
        // );
      },
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                    child: Card(
                      color: color,
                      elevation: 0.1,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Image.asset(
                          img,
                          // color: iconColor,
                          height: 35,
                          width: 25,
                        ),
                        //child: Icon(Icons.check_box_outline_blank, size: 15,color: Colors.orange,),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10.0, right: 15.0, bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Text(
                              "#" + widget.orderId.toString(),
                              style: const TextStyle(
                                  fontSize: 18, ),
                            ),
                          ),
                          Text(
                            "Status : " + widget.status.toString(),
                            style: const TextStyle(color: Colors.black45),
                          ),
                          Text(
                            "Total : " + widget.totalPrice.toString(),
                            style: const TextStyle(color: Colors.black45),
                          ),
                          Text(
                            "Date : " + widget.dateAdded.toString(),
                            style: const TextStyle(color: Colors.black45),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, bottom: 10.0),
                        child: Text(
                          widget.totalItems.toString() + " Items",
                          style: const TextStyle(color: Colors.black45),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
