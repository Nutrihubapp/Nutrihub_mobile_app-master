import 'dart:convert';
import 'dart:io';

import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/models/http_exception.dart';
import 'package:checkout_app/models/product_detail.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/hive_database_helper.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:checkout_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-details';
  String? outOfStock;
  String? productId, screen;
  int? isWishlist;

  ProductDetailScreen(
      {Key? key, this.productId, this.screen, this.outOfStock, this.isWishlist})
      : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var _isInit = true;
  var isLoading = false;
  var _isAuth = false;
  var _authToken = '';

  @override
  void initState() {
    super.initState();
    check();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  check() async {
    var token = await SharedPreferenceHelper().getAuthToken();
    if (token != null) {
      setState(() {
        isLoading = true;
        _isAuth = true;
        _authToken = token;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<ProductDetail?> fetchProductDetailById(String id) async {
    var url = BASE_URL + 'api_frontend/product_details?product_id=$id';
    // if (authToken != null) {
    //   url = base_api +
    //       '/api/course_details_by_id?auth_token=$authToken&course_id=$productId';
    // }

    try {
      final response = await http.get(Uri.parse(url));

      final extractedData = json.decode(response.body);
      print(extractedData);
      if (extractedData == null) {
        return null;
      }
      return ProductDetail.fromJson(jsonDecode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _submit(String productId) async {
    var url = BASE_URL +
        "api_frontend/add_cart_item?product_id=$productId&quantity=1&auth_token=$_authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);

      if (extractedData == null) {
        return;
      } else {
        // return PopDialog.buildPopupDialog(context, extractedData);
        // ignore: non_constant_identifier_names
        var Msg = extractedData['message'];
        return CommonFunctions.showSuccessToast('+1 ');
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
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kDetailsScreenColor,
        leading: IconButton(
            icon: Platform.isIOS
                ? const Icon(Icons.arrow_back_ios)
                : const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Center(
          child:  Text(
              'Product Details',
              style: TextStyle(color: Colors.white),
            ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 25.0),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  // Icon(_isWishlist == 1 ? Icons.favorite:Icons.favorite_border, color: Colors.deepOrangeAccent,),
                  widget.isWishlist == 1
                      ? const Icon(Icons.favorite, color: kAppBarColor)
                      : const Icon(Icons.favorite, color: Colors.white)
                ],
              ),
              onTap: () {
                if (_isAuth) {
                  var newVal = 1;
                  if (widget.isWishlist == 1) {
                    newVal = 0;
                  } else {
                    newVal = 1;
                  }
                  // This function is required for changing the state.
                  // Whenever this function is called it refresh the page with new value
                  setState(() {
                    widget.isWishlist = newVal;
                    _submitTwo(widget.productId.toString());
                  });
                } else {
                  // ignore: non_constant_identifier_names
                  var Msg = 'You are not logged in!';
                  CommonFunctions.showSuccessToast(Msg);
                }
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<ProductDetail?>(
          future: fetchProductDetailById(widget.productId.toString()),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                  //period:Duration(seconds:5),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                'image-not-found.png',
                                height: 210,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black87,
                                 ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          ],
                        )),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Center(
                          child: Text(
                            '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      const Visibility(
                        visible: false,
                        child: Center(
                          child: Text(
                            'Out of stock',
                            style:
                                TextStyle(color: Colors.black45, fontSize: 15),
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Quantity',
                          style: TextStyle(color: Colors.black45, fontSize: 15),
                        ),
                      ),
                      const Center(
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.only(
                              left: 100.0, right: 100.0, bottom: 10.0),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              side: BorderSide(color: kGreenColor),
                            ),
                            color: kGreenColor,
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Center(
                              child: Text(
                                'BUY NOW',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            onPressed: null,
                          )),

                    ],
                  ));
            } else {
              if (dataSnapshot.error != null) {
                return const Center(
                  child: Text('Error Occured'),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: dataSnapshot.data!.thumbnail!.isNotEmpty
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height*0.4,
                                child: CarouselSlider.builder(
                                    //  enableAutoSlider: true,
                                    //  autoSliderDelay: const Duration(seconds: 3),
                                    //key: _sliderKey,
                                    unlimitedMode: true,
                                    slideBuilder: (index) {

                                      return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child:
                                          PhotoView(
                                            imageProvider: NetworkImage(dataSnapshot
                                                .data!.thumbnail![index].toString()),
                                            backgroundDecoration: BoxDecoration(color: Colors.white),
                                          ),
                                          // FadeInImage.assetNetwork(
                                          //   placeholder:
                                          //       'assets/loading_animated.gif',
                                          //   image: dataSnapshot
                                          //       .data!.thumbnail![index]
                                          //       .toString(),
                                          //   height: 210,
                                          //   width: double.infinity,
                                          //   fit: BoxFit.cover,
                                          // )
                                      );
                                    },
                                    //slideTransform: const CubeTransform(),
                                    slideIndicator: CircularSlideIndicator(
                                      indicatorBorderColor: Colors.grey,
                                      currentIndicatorColor: Colors.white,
                                      padding:
                                          const EdgeInsets.only(bottom: 32),
                                    ),
                                    itemCount:
                                        dataSnapshot.data!.thumbnail!.length),
                              )
                            // FadeInImage.assetNetwork(
                            //     placeholder: 'assets/loading_animated.gif',
                            //     image: dataSnapshot.data!.thumbnail![0].toString(),
                            //     height: 210,
                            //     width: double.infinity,
                            //     fit: BoxFit.cover,
                            //   )
                            : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    'image-not-found.png',
                                    height: 210,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: dataSnapshot.data!.discount != '0'
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dataSnapshot.data!.discountPrice.toString(),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.black87,
                                       ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      dataSnapshot.data!.price.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                '\$${dataSnapshot.data!.price.toString()}',//currencytochange
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black87,
                                   ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Center(
                        child: Text(
                          dataSnapshot.data!.name.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(),
                    ),
                    Visibility(
                      visible: widget.outOfStock != null
                          ? widget.outOfStock == "yes"
                              ? true
                              : false
                          : dataSnapshot.data!.outOfStock == "yes"
                              ? true
                              : false,
                      child: const Center(
                        child: Text(
                          'Out of stock',
                          style: TextStyle(color: Colors.black45, fontSize: 15),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          dataSnapshot.data!.description.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Quantity',
                        style: TextStyle(color: Colors.black45, fontSize: 15),
                      ),
                    ),
                    Center(
                      child: Text(
                        dataSnapshot.data!.unit.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 100.0, right: 100.0, bottom: 10.0),
                        child: MaterialButton(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              side: BorderSide(color: kGreenColor),
                            ),
                            color: widget.outOfStock == "yes" ||
                                    dataSnapshot.data!.outOfStock == "yes"
                                ? Colors.grey
                                : kGreenColor,
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: const Center(
                              child: Text(
                                'BUY NOW',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            onPressed: widget.outOfStock == "no" ||
                                    widget.outOfStock == null ||
                                    dataSnapshot.data!.outOfStock == "no"
                                ? () async {
                                    await check();
                                    if (_authToken.isNotEmpty) {
                                      // var item = await DatabaseHelper.instance
                                      //     .findItem(widget.productId);
                                      Map cartItem = {
                                        'productId': dataSnapshot
                                            .data!.productId
                                            .toString(),
                                        'name': dataSnapshot.data!.name,
                                        'discountPrice': dataSnapshot
                                            .data!.discountPrice
                                            .toString(),
                                        'mainPrice': dataSnapshot
                                            .data!.discountPrice
                                            .toString(),
                                        'currency': dataSnapshot.data!.currency
                                            .toString(),
                                        'currencyPosition': dataSnapshot
                                            .data!.currencyPosition
                                            .toString(),
                                        'thumbnail': dataSnapshot
                                            .data!.thumbnail![0]
                                            .toString(),
                                        'unit': dataSnapshot.data!.unit,
                                        'quantity': 1
                                      };
                                      //  if (item == false) {
                                      await HiveDatabase.addItemToCart(
                                          cartItem,
                                          widget.productId,
                                          dataSnapshot.data!.discountPrice);
                                      _submit(widget.productId.toString());

                                      setState(() async {
                                        var url = BASE_URL +
                                            "api_frontend/add_cart_item?product_id=${widget.productId}&quantity=1&auth_token=$_authToken";
                                        try {
                                          final response =
                                              await http.get(Uri.parse(url));
                                          final items =
                                              json.decode(response.body);
                                          if (items == null) {
                                            return;
                                          }
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (BuildContext context) =>
                                          //       _buildPopupDialog2(context,
                                          //           items, widget.screen),
                                          // );
                                          CommonFunctions.showSuccessToast(
                                              "+1");
                                        } catch (error) {
                                          var errorMsg = 'Sign in to continue';
                                          CommonFunctions.showErrorDialog(
                                              errorMsg, context);
                                          rethrow;
                                        }
                                      });
                                      // if (item.isEmpty) {
                                      //   await DatabaseHelper.instance.addItem(
                                      //     CartProduct(
                                      //         productId: dataSnapshot
                                      //             .data!.productId
                                      //             .toString(),
                                      //         name: dataSnapshot.data!.name
                                      //             .toString(),
                                      // discountPrice: dataSnapshot
                                      //     .data!.discountPrice
                                      //     .toString(),
                                      //         mainPrice: dataSnapshot
                                      //             .data!.discountPrice,
                                      // currency: dataSnapshot
                                      //     .data!.currency
                                      //     .toString(),
                                      // currencyPosition: dataSnapshot
                                      //     .data!.currencyPosition
                                      //     .toString(),
                                      // thumbnail: dataSnapshot
                                      //     .data!.thumbnail
                                      //     .toString(),
                                      //         unit: dataSnapshot.data!.unit
                                      //             .toString(),
                                      //         quantity: 1),
                                      //   );
                                      // setState(() async {
                                      //   var url = BASE_URL +
                                      //       "api_frontend/add_cart_item?product_id=${widget.productId}&quantity=1&auth_token=$_authToken";
                                      //   try {
                                      //     final response =
                                      //         await http.get(Uri.parse(url));
                                      //     final items =
                                      //         json.decode(response.body);
                                      //     if (items == null) {
                                      //       return;
                                      //     }
                                      //     showDialog(
                                      //       context: context,
                                      //       builder: (BuildContext context) =>
                                      //           _buildPopupDialog2(
                                      //               context, items),
                                      //     );
                                      //   } catch (error) {
                                      //     var errorMsg = 'Sign in to continue';
                                      //     CommonFunctions.showErrorDialog(
                                      //         errorMsg, context);
                                      //     rethrow;
                                      //   }
                                      // });
                                      // } else {
                                      //   var url = BASE_URL +
                                      //       "api_frontend/add_cart_item?product_id=${widget.productId}&quantity=1&auth_token=$_authToken";
                                      //   try {
                                      //     final response =
                                      //         await http.get(Uri.parse(url));
                                      //     final items =
                                      //         json.decode(response.body);
                                      //     if (items == null) {
                                      //       return;
                                      //     }
                                      //     showDialog(
                                      //       context: context,
                                      //       builder: (BuildContext context) =>
                                      //           _buildPopupDialog2(
                                      //               context, items),
                                      //     );
                                      //   } catch (error) {
                                      //     var errorMsg = 'Sign in to continue';
                                      //     CommonFunctions.showErrorDialog(
                                      //         errorMsg, context);
                                      //     rethrow;
                                      //   }
                                      // }
                                    } else {
                                      var errorMsg = 'Sign in to continue';
                                      CommonFunctions.showErrorDialog(
                                          errorMsg, context);
                                    }
                                  }
                                : () {
                                    CommonFunctions.showSuccessToast(
                                        'Item is out of stock');
                                  })),

                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildPopupDialog2(BuildContext context, items, String? screen) {
    var msg = items['message'];
    var status = items['status'];
    if (status == 403) {
      var msg = "You are not signed in. Sign in to continue?";
      return AlertDialog(
        title: const Text('Notifying'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(msg),
          ],
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).changeAppBar(true);
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Close'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).changeAppBar(true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Sign in'),
          ),
        ],
      );
    }
    return AlertDialog(
      title: const Text('Notifying'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(msg),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
        Consumer<Auth>(builder: (context, auth, widget) {
          return MaterialButton(
            onPressed: () {
              if (screen == "filter") {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).pop();
                auth.controller.jumpToTab(2);
              } else {
                auth.controller.jumpToTab(2);
                Navigator.of(context, rootNavigator: true).pop();
              }
              //  Navigator.of(context).pop();

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const TabsScreen(selectedPageIndex: 2)),
              // );
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Go to Cart'),
          );
        }),
      ],
    );
  }
}
