import 'dart:convert';
import 'dart:io';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/hive_database_helper.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:checkout_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListItem extends StatefulWidget {
  final String? productId;
  final String? categoryId;
  final dynamic name;
  final String? price;
  final String? outOfStock;
  final String? discountPrice;
  final String? currency;
  final String? currencyPosition;
  final String? discount;
  final String? thumbnail;
  final String? unit;
  final int? isWishlist;
  final Color? backgroundColor;

  const ProductListItem(
      {Key? key,
      this.productId,
      this.outOfStock,
      this.categoryId,
      this.name,
      this.price,
      this.discountPrice,
      this.currency,
      this.currencyPosition,
      this.discount,
      this.thumbnail,
      this.unit,
      this.isWishlist,
      this.backgroundColor})
      : super(key: key);

  @override
  _ProductListItemState createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  var _isInit = true;
  var isLoading = false;
  dynamic _authToken;
  bool _hasBeenPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    dynamic userData;
    dynamic response;
    if (_isInit) {
      // final prefs = await SharedPreferences.getInstance();
      // setState(() {
      //   userData = (prefs.getString('userData') ?? '');
      // });
      // if (userData != null && userData.isNotEmpty) {
      //   response = json.decode(userData);
      //   setState(() {
      //     isLoading = true;
      //     _authToken = response['token'];
      //   });
      // }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  check() async {
    var token = await SharedPreferenceHelper().getAuthToken();
    if (token != null) {
      setState(() {
        isLoading = true;
        // _isAuth = true;
        _authToken = token;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<void> _submit(String productId) async {
    int quantity = 1;
    var url = BASE_URL +
        "api_frontend/add_cart_item?product_id=$productId&quantity=$quantity&auth_token=$_authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      } else {
        // return PopDialog.buildPopupDialog(context, extractedData);
        // ignore: non_constant_identifier_names
        var Msg = extractedData['message'];

        if (Msg == "This item already added") {
          return CommonFunctions.showSuccessToast("+1");
        } else {
          return CommonFunctions.showSuccessToast(Msg);
        }
      }
    } on HttpException {
      var errorMsg = 'Auth failed';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      var errorMsg = 'Sign in to continue';
      CommonFunctions.showErrorDialog(errorMsg, context);
      rethrow;
    }
  }

  Future<void> _submitTwo(String productId) async {
    var url = BASE_URL +
        "api_frontend/add_wishlist_item?product_id=$productId&auth_token=" +
        _authToken;
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      } else {
        // ignore: non_constant_identifier_names
        var Msg = extractedData['message'];
        return CommonFunctions.showSuccessToast(Msg);
        // return PopDialog.buildPopupDialog(context, extractedData);
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: ProductDetailScreen(
              outOfStock: widget.outOfStock,
              productId: widget.productId.toString(),
              isWishlist: widget.isWishlist!.toInt()),
          withNavBar: true,
          //                       );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => ProductDetailScreen(
          //           productId: widget.productId.toString(),
          //           isWishlist: widget.isWishlist!.toInt())),
        );
      },
      child: SizedBox(
        // height: 150,
        width: 120,
        child: Card(
          elevation: 0.1,
          shadowColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: [
              Column(
                children: <Widget>[
                  Stack(
                    children: [
                      widget.thumbnail!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(9),
                                  topLeft: Radius.circular(9)),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/loading_animated.gif',
                                image: widget.thumbnail.toString(),
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  'image-not-found.png',
                                  height: 110,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () async{
                              await check();
                            _submitTwo(widget.productId.toString());
                            setState(() {
                              if (_authToken != null) {
                                _hasBeenPressed = !_hasBeenPressed;
                              } else {
                                // ignore: non_constant_identifier_names
                                var Msg = "You are not logged in";
                                return CommonFunctions.showSuccessToast(Msg);
                              }
                            });
                          },
                          icon: widget.isWishlist == 1
                              ? Icon(
                                  Icons.favorite,
                                  color: _hasBeenPressed
                                      ? kSecondaryColor
                                      : kAppBarColor,
                                )
                              : Icon(
                                  Icons.favorite,
                                  color: _hasBeenPressed
                                      ? kGreenColor
                                      : kSecondaryColor,
                                ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0, right: 1.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit:BoxFit.fitHeight, //ok lo
                                  child: Text(
                                    widget.name!.length < 38
                                        ? widget.name
                                        : widget.name.substring(0, 37),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black87,

                                    ),
                                  ),
                                ),
                                Text(
                                  widget.unit.toString(),
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black45,

                                  ),
                                ),
                                Visibility(
                                    visible: widget.outOfStock == "yes"
                                        ? true
                                        : false,
                                    child: Text('out of stock')),
                                Row(
                                  // alignment: WrapAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      widget.currencyPosition! == 'left' ||
                                              widget.currencyPosition! ==
                                                  'left-space'
                                          ? widget.currency! +
                                              widget.discountPrice.toString() +
                                              "   "
                                          : widget.discountPrice.toString() +
                                              widget.currency! +
                                              "   ",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.green,

                                      ),
                                    ),
                                    if (widget.discount != '0%')
                                      Text(
                                        widget.currencyPosition! == 'left' ||
                                                widget.currencyPosition! ==
                                                    'left-space'
                                            ? widget.currency! +
                                                widget.price.toString()
                                            : widget.price.toString() +
                                                widget.currency!,
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.black38,

                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    Expanded(
                                      child: ButtonTheme(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0,
                                            horizontal:
                                                0.0), //adds padding inside the button
                                        materialTapTargetSize: MaterialTapTargetSize
                                            .shrinkWrap, //limits the touch area to the button area
                                        minWidth: 0, //wraps child's width
                                        height: 25,
                                        child: MaterialButton(
                                          minWidth: 5,
                                          height: 40,
                                          onPressed: widget.outOfStock == "no"
                                              ? () async {
                                                  await check();
                                                  if (_authToken != null) {
                                                    print('checking');
                                                    var item =
                                                        await HiveDatabase
                                                            .checkForItem(widget
                                                                .productId);
                                                    Map cartItem = {
                                                      'shopId': widget
                                                          .categoryId
                                                          .toString(),
                                                      'productId': widget
                                                          .productId
                                                          .toString(),
                                                      'name': widget.name
                                                          .toString(),
                                                      'discountPrice': widget
                                                          .discountPrice
                                                          .toString(),
                                                      'mainPrice': widget
                                                          .discountPrice
                                                          .toString(),
                                                      'currency': widget
                                                          .currency
                                                          .toString(),
                                                      'currencyPosition': widget
                                                          .currencyPosition
                                                          .toString(),
                                                      'thumbnail': widget
                                                          .thumbnail
                                                          .toString(),
                                                      'unit': widget.unit
                                                          .toString(),
                                                      'quantity': 1,
                                                      'normalPrice': widget
                                                          .discountPrice
                                                          .toString(),
                                                    };
                                                    //  if (item == false) {
                                                    await HiveDatabase
                                                        .addItemToCart(
                                                            cartItem,
                                                            widget.productId,
                                                            widget
                                                                .discountPrice);
                                                    //}

                                                    // if (item.isEmpty) {
                                                    //   await DatabaseHelper
                                                    //       .instance
                                                    //       .addItem(
                                                    //     CartProduct(
                                                    //         shopId:
                                                    //             widget.categoryId,
                                                    //         productId: widget
                                                    //             .productId
                                                    //             .toString(),
                                                    //         name: widget.name,
                                                    //         discountPrice: widget
                                                    //             .discountPrice
                                                    //             .toString(),
                                                    //         mainPrice: widget
                                                    //             .discountPrice,
                                                    //         currency: widget
                                                    //             .currency
                                                    //             .toString(),
                                                    //         currencyPosition: widget
                                                    //             .currencyPosition
                                                    //             .toString(),
                                                    //         thumbnail: widget
                                                    //             .thumbnail
                                                    //             .toString(),
                                                    //         unit: widget.unit
                                                    //             .toString(),
                                                    //         quantity: 1),
                                                    //   );
                                                    _submit(widget.productId
                                                        .toString());
                                                    // } else {
                                                    //   CommonFunctions
                                                    //       .showSuccessToast(
                                                    //           'Item already added');
                                                    // }
                                                  } else {
                                                    var errorMsg =
                                                        'Sign in to continue';
                                                    CommonFunctions
                                                        .showErrorDialog(
                                                            errorMsg, context);
                                                  }
                                                }
                                              : () => CommonFunctions
                                                  .showSuccessToast(
                                                      'Item is out of stock'),
                                          child: Container(
                                              height: 35,
                                              width: 35,
                                              child: const Icon(Icons.add,
                                                  color: Colors.white),
                                              decoration: BoxDecoration(
                                                color:
                                                    widget.outOfStock == "yes"
                                                        ? Colors.grey
                                                        : kGreenColor,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              )),

                                          // Image.asset(
                                          //   'add-to-cart.png',
                                          //   height: 35,
                                          //   width: 35,
                                          // ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  //  Box box1 = await Hive.openBox('user_info');
  //                             Map details = await box1.get('user_info');

  //                             Livechat.beginChat(
  //                               "14022744",
  //                               "",
  //                               details['name'],
  //                               details['email'],
  //                             );
