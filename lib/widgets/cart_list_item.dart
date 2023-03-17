import 'dart:convert';

import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/providers/hive_database_helper.dart';
import 'package:checkout_app/providers/product.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constants.dart';

class CartListItem extends StatefulWidget {
  final int? id;
  final int index;
  final String productId;
  final String name;
  final String normalPrice;
  final dynamic discountPrice;
  final dynamic mainPrice;
  final String currency;
  final String currencyPosition;
  final String thumbnail;
  final String unit;
  final int quantity;
  final ValueChanged<dynamic> updateTotalPrice;
  final ValueChanged<dynamic> listUpdate;

  const CartListItem(
      {Key? key,
      this.id,
      required this.index,
      required this.productId,
      required this.normalPrice,
      required this.name,
      this.discountPrice,
      this.mainPrice,
      required this.currency,
      required this.currencyPosition,
      required this.thumbnail,
      required this.unit,
      required this.quantity,
      required this.updateTotalPrice,
      required this.listUpdate})
      : super(key: key);

  @override
  _CartListItemState createState() => _CartListItemState();
}

class _CartListItemState extends State<CartListItem> {
  // dynamic price;
  // dynamic quantity;
  dynamic price;
  dynamic quantity;

  @override
  void initState() {
    super.initState();
    setState(() {
      quantity = widget.quantity;
      price = widget.mainPrice;
    });
  }

  updateQuantity(cartQuantity, productId) async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url = BASE_URL +
        "api_frontend/modify_cart_items?product_id=$productId&quantity=$cartQuantity&auth_token=$authToken";
     await http.get(Uri.parse(url));
   
  }

  addQuantityAndPrice() async {
    setState(() {
      quantity++;
      price = double.parse(price.toString()) +
          double.parse(widget.normalPrice.toString());
    });
    // await DatabaseHelper.instance.updateItem(widget.id, quantity, price);
    await updateQuantity(quantity, widget.productId);
    widget.updateTotalPrice(double.parse(widget.discountPrice.toString()));
    await HiveDatabase.updateCartItems(widget.productId, quantity, price);
  }

  removeQuantityAndPrice() async {
    print('this is  quantity $quantity');
    if (int.parse(quantity.toString()) > 1) {
      // await DatabaseHelper.instance.updateItem(widget.id, quantity, price);
 setState(() {
        quantity = int.parse(quantity.toString()) - 1;
        price = double.parse(price.toString()) -
            double.parse(widget.discountPrice.toString());
      });
      await updateQuantity(quantity, widget.productId);
      widget.updateTotalPrice(-double.parse(widget.discountPrice.toString()));

      await HiveDatabase.updateCartItems(widget.productId, quantity, price);
      // setState(() {
      //   quantity = int.parse(quantity.toString()) - 1;
      //   price = double.parse(price.toString()) -
      //       double.parse(widget.discountPrice.toString());
      // });
      await HiveDatabase.updateCartItems(widget.productId, quantity, price);
    } else {
    
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Notifying'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text('Do you wish to remove this product?'),
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                var authToken = await SharedPreferenceHelper().getAuthToken();
                var url = BASE_URL +
                    "api_frontend/cart_items_remove?product_id=${widget.productId}&auth_token=$authToken";
                try {
                  final response = await http.get(Uri.parse(url));
                  final extractedData = json.decode(response.body);
                  // print(extractedData);
                  if (extractedData == null) {
                    return;
                  }
                } catch (error) {
                  rethrow;
                }
                Navigator.of(context).pop();
                //  await DatabaseHelper.instance.removeProduct(widget.id);
                await HiveDatabase.deleteItems(widget.index);
                widget.listUpdate(widget.productId);
                widget.updateTotalPrice(-int.parse(price.toString()));
                CommonFunctions.showSuccessToast('Removed from cart list.');
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        elevation: 0.2,
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          widget.thumbnail.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10.0, top: 5),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/loading_animated.gif',
                                    image: widget.thumbnail,
                                    height: 70,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10.0, top: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.asset(
                                      'image-not-found.png',
                                      height: 70,
                                      width: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 7),
                                  child: Card(
                                    elevation: 0.1,
                                    color: Colors.white54,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6, right: 6, top: 4, bottom: 4),
                                      child: Center(
                                        child: Text(
                                          widget.unit,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      // mainPrice,
                                      widget.currencyPosition == 'left' ||
                                              widget.currencyPosition ==
                                                  'left-space'
                                          ? widget.currency +
                                              widget.discountPrice.toString()
                                          : widget.discountPrice.toString() +
                                              widget.currency,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, right: 8.0),
                                  child: Text(
                                    widget.currencyPosition == 'left' ||
                                            widget.currencyPosition ==
                                                'left-space'
                                        ? widget.currency + price.toString()
                                        : price.toString() + widget.currency,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                flex: 3,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: IconButton(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      // deleteItem(widget.productId);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Notifying'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const <Widget>[
                                              Text(
                                                  'Do you wish to remove this product?'),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              textColor: Theme.of(context)
                                                  .primaryColor,
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                var authToken =
                                                    await SharedPreferenceHelper()
                                                        .getAuthToken();
                                                var url = BASE_URL +
                                                    "api_frontend/cart_items_remove?product_id=${widget.productId}&auth_token=$authToken";
                                                try {
                                                  final response = await http
                                                      .get(Uri.parse(url));
                                                  final extractedData = json
                                                      .decode(response.body);
                                                  // print(extractedData);
                                                  if (extractedData == null) {
                                                    return;
                                                  }
                                                } catch (error) {
                                                  rethrow;
                                                }
                                                Navigator.of(context).pop();
                                                await HiveDatabase.deleteItems(
                                                    widget.index);
                                                widget.listUpdate(
                                                    widget.productId);
                                                widget.updateTotalPrice(
                                                    -double.parse(
                                                        price.toString()));
                                                CommonFunctions.showSuccessToast(
                                                    'Removed from cart list.');
                                              },
                                              textColor: Theme.of(context)
                                                  .primaryColor,
                                              child: const Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    iconSize: 22,
                                    icon: const Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(Icons.delete_outline,
                                          color: Colors.black45),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18, right: 15),
                            child: SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonTheme(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal:
                                          18.0), //adds padding inside the button
                                  materialTapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap, //limits the touch area to the button area
                                  minWidth: 0, //wraps child's width
                                  height: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: MaterialButton(
                                          onPressed: () {
                                            removeQuantityAndPrice();
                                          },
                                          shape: const CircleBorder(
                                              side: BorderSide(
                                                  color: Colors.black38)),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Icon(Icons.remove,
                                                color: Colors.black45,
                                                size: 20),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Consumer<Product>(
                                      builder: (context, product, widget) {
                                    return Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              Expanded(
                                child: ButtonTheme(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal:
                                          8.0), //adds padding inside the button
                                  materialTapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap, //limits the touch area to the button area
                                  minWidth: 0, //wraps child's width
                                  height: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4.0, right: 5.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: MaterialButton(
                                          onPressed: () {
                                            addQuantityAndPrice();
                                          },
                                          shape: const CircleBorder(
                                              side: BorderSide(
                                                  color: Colors.black38)),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Icon(Icons.add,
                                                color: Colors.black45,
                                                size: 20),
                                          )),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      flex: 3,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
