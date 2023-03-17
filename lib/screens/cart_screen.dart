import 'dart:async';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/cart_product.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/database_helper.dart';
import 'package:checkout_app/providers/fetch_data.dart';
import 'package:checkout_app/providers/hive_database_helper.dart';
import 'package:checkout_app/widgets/cart_list_item.dart';
import 'package:checkout_app/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartProduct> listProducts = [];
  dynamic totalPrice = 0;
  dynamic currency;
  dynamic currencyPosition;

  var _isInit = true;
  var _isLoading = false;
  var catData = [];

  Future<List<Map<String, dynamic>>?> getCart() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllRows('cart_list');
    setState(() {
      for (var map in listMap) {
        listProducts.add(CartProduct.fromMap(map));
      }
      for (int i = 0; i < listProducts.length; i++) {
        totalPrice = totalPrice + listProducts[i].mainPrice;
        currency = listProducts[i].currency;
        currencyPosition = listProducts[i].currencyPosition;
      }
    });
  }

  Future<List<Map<String, dynamic>>?> getHiveCart() async {
    List listMap = await HiveDatabase.getAllCartItems();
    setState(() {
      for (var map in listMap) {
        listProducts.add(CartProduct.fromMap(Map<String, dynamic>.from(map)));
      }
      for (int i = 0; i < listProducts.length; i++) {
        totalPrice = double.parse(totalPrice.toString()) +
            double.parse(listProducts[i].mainPrice.toString());
        currency = listProducts[i].currency;
        currencyPosition = listProducts[i].currencyPosition;
      }
    });
  }

  void updateTotalPrice(dynamic price) {
    setState(() => totalPrice =
        double.parse(totalPrice.toString()) + double.parse(price.toString()));
  }

  void listUpdate(dynamic productId) {
    for (int i = 0; i < listProducts.length; i++) {
      if (productId == listProducts[i].productId) {
        listProducts.removeAt(i);
      }
    }
  }

  List shopClosingTime = [];
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<FetchData>(context).getCart().then((_) {
        setState(() {
          _isLoading = false;
          catData = Provider.of<FetchData>(context, listen: false).listProducts;
        });
      });
      Provider.of<FetchData>(context).checkShopTime().then((_) {
        _isLoading = false;
        shopClosingTime =
            Provider.of<FetchData>(context, listen: false).closingTime;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool shopIsClosed = false;
  dynamic count = 0;
  Timer? timer;
  @override
  void initState() {
    getHiveCart();
    super.initState();
    timer = Timer.periodic(
        const Duration(milliseconds: 200), (Timer t) => getHiveCartLength());
        
   
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<List<Map<String, dynamic>>?> getHiveCartLength() async {
    var listMap = await HiveDatabase.getAllCartItems();
    setState(() {
      count = listMap.length;
    });
  }

  Future<List<Map<String, dynamic>>?> getCartItems() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllRows('cart_list');
    setState(() {
      count = listMap.length;
    });
    // Provider.of<Auth>(context, listen: false).changeCount(count);

    ///  Provider.of<Auth>(context, listen: false).changeCount(listMap.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Provider.of<Auth>(context, listen: false).resetCount();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
     
    return Consumer<Auth>(builder: (context, auth, widget) {
      for (var element in shopClosingTime) {
      //  print(element['closetime']);
      String closeTime = '${element['closetime']}';
      String openTime = '${element['opentime']}';
      initializeDateFormatting();

      final currentTime =
    DateFormat('HH').format(DateTime.now());
      //print(currentTime);

      if (int.parse(currentTime) >= int.parse(closeTime.toString()) ||
          int.parse(currentTime) < int.parse(openTime.toString())) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          setState(() {
            shopIsClosed = true;
          });
        });
        // print('shop is closed');
      } else {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          setState(() {
            shopIsClosed = false;
          });
        });

        // print('shop is open');

        //    print('shop is open');
      }
    }
      auth.getAuthToken();
      return Scaffold(
        drawer: const NavDrawer(),
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle:false,
          elevation:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  .1,
          backgroundColor: kAppBarColor,
          leadingWidth: 50,
          leading: Row(
            children: [
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: InkWell(
                  onTap: () => scaffoldKey.currentState!.openDrawer(),
                  child: const Icon(
                    Icons.dehaze_rounded,
                    size: 30,
                    color: kBottomNavigationBarColor,
                  ),
                ),
              ),
            ],
          ),
          title: Container(
            margin: EdgeInsets.only(top: 2),
            child: Image.asset(
              'Checkout-logo.png',
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: kBackgroundColor,
        body: _isLoading
            ? Shimmer.fromColors(
              //period:Duration(seconds:5),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text(
                            'My Cart',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (listProducts.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .15),
                            Align(
                              alignment: const Alignment(-0.3, 0),
                              child: Image.asset(
                                'no-product-found.png',
                                height: 220,
                              ),
                            ),
                            const Text(
                              "No product added to cart.",
                              style: TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    Column(
                      children: [
                        ListView.builder(
                          // key: Key('builder ${selected.toString()}'), //attention
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listProducts.length,
                          itemBuilder: (ctx, index) {
                            final item = listProducts[index];
                            //  / print(item.shopId);
                            return CartListItem(
                              id: item.id,
                              normalPrice: item.normalPrice,
                              index: index,
                              productId: item.productId,
                              name: item.name,
                              discountPrice: item.discountPrice,
                              mainPrice: item.mainPrice,
                              currency: item.currency,
                              currencyPosition: item.currencyPosition,
                              thumbnail: item.thumbnail,
                              unit: item.unit,
                              quantity: item.quantity,
                              updateTotalPrice: updateTotalPrice,
                              listUpdate: listUpdate,
                            );
                          },
                        ),
                      ],
                    ),
                    if (listProducts.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  // dataSnapshot.data!.totalDiscountedPrice
                                  // currencyPosition == 'left' ||
                                  //currencyPosition == 'left-space'
                                  //?
                                  '\$$totalPrice',//currencytochange
                                  // : totalPrice.toStringAsFixed(2) +
                                  //     currencyPosition,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Visibility(
                              visible: shopIsClosed == false,
                              child: MaterialButton(
                                
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 70),
                                onPressed: () async {
                                        //print(totalPrice.toStringAsFixed(2));
                            
                                        if (shopIsClosed == true) {
                                          CommonFunctions.showSuccessToast(
                                              'shop is closed ');
                                        } else {
                                          pushNewScreen(
                                            context,
                                            screen: CheckoutScreen(
                                              totalPrice: totalPrice.toString(),
                                            ),
                                            withNavBar: true,
                                          );
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           const CheckoutScreen()),
                                          // );
                                        }
                                      },
                                child: Text(
                                  shopIsClosed ? "Store is Closed" : "Checkout",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                color:  kGreenColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(color: kGreenColor)),
                              ),
                            ),
                               // Visibility(
                               //   visible:shopIsClosed,
                               //   child: FlatButton(
                               //
                               //                               padding: const EdgeInsets.symmetric(
                               //      vertical: 8, horizontal: 70),
                               //                               onPressed: (){},
                               //                               child: Text(
                               //    shopIsClosed ? "Store is Closed" : "Checkout",
                               //    style: const TextStyle(
                               //        color: Colors.white, fontSize: 18),
                               //                               ),
                               //                               color: Colors.grey,
                               //                               shape: RoundedRectangleBorder(
                               //      borderRadius: BorderRadius.circular(10.0),
                               //     ),
                               //                             ),
                               // ),
                            const SizedBox(height: 70)
                          ],
                        ),
                      ),
                  ],
                ),
              ),)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          Text(
                            'My Cart',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (listProducts.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .15),
                            Align(
                              alignment: const Alignment(-0.3, 0),
                              child: Image.asset(
                                'no-product-found.png',
                                height: 220,
                              ),
                            ),
                            const Text(
                              "No product added to cart.",
                              style: TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    Column(
                      children: [
                        ListView.builder(
                          // key: Key('builder ${selected.toString()}'), //attention
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listProducts.length,
                          itemBuilder: (ctx, index) {
                            final item = listProducts[index];
                            //  / print(item.shopId);
                            return CartListItem(
                              id: item.id,
                              normalPrice: item.normalPrice??'',
                              index: index,
                              productId: item.productId,
                              name: item.name,
                              discountPrice: item.discountPrice,
                              mainPrice: item.mainPrice,
                              currency: item.currency,
                              currencyPosition: item.currencyPosition,
                              thumbnail: item.thumbnail,
                              unit: item.unit,
                              quantity: item.quantity,
                              updateTotalPrice: updateTotalPrice,
                              listUpdate: listUpdate,
                            );
                          },
                        ),
                      ],
                    ),
                    if (listProducts.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  // dataSnapshot.data!.totalDiscountedPrice
                                  // currencyPosition == 'left' ||
                                  //currencyPosition == 'left-space'
                                  //?
                                  '\$$totalPrice',//currencytochange
                                  // : totalPrice.toStringAsFixed(2) +
                                  //     currencyPosition,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Visibility(
                              visible: shopIsClosed == false,
                              child: MaterialButton(
                                
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 70),
                                onPressed: () async {
                                        //print(totalPrice.toStringAsFixed(2));
                            
                                        if (shopIsClosed == true) {
                                          CommonFunctions.showSuccessToast(
                                              'shop is closed ');
                                        } else {
                                          pushNewScreen(
                                            context,
                                            screen: CheckoutScreen(
                                              totalPrice: totalPrice.toString(),
                                            ),
                                            withNavBar: true,
                                          );
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           const CheckoutScreen()),
                                          // );
                                        }
                                      },
                                child: Text(
                                  shopIsClosed ? "Store is Closed" : "Checkout",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                color:  kGreenColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(color: kGreenColor)),
                              ),
                            ),
                               // Visibility(
                               //   visible:shopIsClosed,
                               //   child: FlatButton(
                               //
                               //                               padding: const EdgeInsets.symmetric(
                               //      vertical: 8, horizontal: 70),
                               //                               onPressed: (){},
                               //                               child: Text(
                               //    shopIsClosed ? "Store is Closed" : "Checkout",
                               //    style: const TextStyle(
                               //        color: Colors.white, fontSize: 18),
                               //                               ),
                               //                               color: Colors.grey,
                               //                               shape: RoundedRectangleBorder(
                               //      borderRadius: BorderRadius.circular(10.0),
                               //     ),
                               //                             ),
                               // ),
                            const SizedBox(height: 70)
                          ],
                        ),
                      ),
                  ],
                ),
              ),
      );
    });
  }
}
