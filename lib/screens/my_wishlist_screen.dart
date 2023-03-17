import 'dart:async';
import 'dart:convert';

import 'package:checkout_app/models/wishlist_model.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/database_helper.dart';
import 'package:checkout_app/providers/hive_database_helper.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:checkout_app/widgets/nav_drawer.dart';
import 'package:checkout_app/widgets/wish_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

class MyWishListScreen extends StatefulWidget {
  const MyWishListScreen({Key? key}) : super(key: key);

  @override
  _MyWishListScreenState createState() => _MyWishListScreenState();
}

class _MyWishListScreenState extends State<MyWishListScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic _authToken = '';

  Future<Wishlist>? futureWishList;

  Future<Wishlist> fetchWishListItems() async {
    _authToken = await SharedPreferenceHelper().getAuthToken();
    var url = BASE_URL + "api_frontend/wishlist_item?auth_token=$_authToken";
    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));
      return Wishlist.fromJson(json.decode(response.body));
    } catch (error) {
      rethrow;
    }
  }

  dynamic count = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    futureWishList = fetchWishListItems();
    timer = Timer.periodic(
        const Duration(milliseconds: 200), (Timer t) => getHiveCart());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<List<Map<String, dynamic>>?> getHiveCart() async {
    Box userBox = await Hive.openBox('user_info');
    var userMapBox = await userBox.get('user_info') ?? null;
    if (userMapBox != null) {
      var listMap = await HiveDatabase.getAllCartItems();
      setState(() {
        count = listMap.length;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, widget) {
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text(
                      'My Wishlist',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<Wishlist>(
                future: futureWishList,
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                        //period:Duration(seconds:5),
                        baseColor: Colors.white,
                        highlightColor: Colors.grey,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 8.0, bottom: 2.0, right: 8.0, top: 0),
                          child: StaggeredGridView.countBuilder(
                              padding: const EdgeInsets.all(2.0),
                              shrinkWrap: true,
                              itemCount: 10,
                              crossAxisCount: 2,
                              staggeredTileBuilder: (int index) =>
                                  const StaggeredTile.fit(1),
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 5.0,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Text('');
                              }),
                        ));
                  } else {
                    if (dataSnapshot.error != null) {
                      //error
                      return const Center(
                        child: Text('Error Occured'),
                      );
                    } else {
                      return dataSnapshot.data!.status != 403
                          ? Container(
                              margin: const EdgeInsets.only(
                                  left: 8.0, bottom: 2.0, right: 8.0, top: 0),
                              child: StaggeredGridView.countBuilder(
                                  padding: const EdgeInsets.all(2.0),
                                  shrinkWrap: true,
                                  itemCount:
                                      dataSnapshot.data!.wishlistItems!.length,
                                  crossAxisCount: 2,
                                  staggeredTileBuilder: (int index) =>
                                      const StaggeredTile.fit(1),
                                  mainAxisSpacing: 8.0,
                                  crossAxisSpacing: 5.0,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return WishListItem(
                                        outOfStock: dataSnapshot.data!
                                            .wishlistItems![index].outOfStock,
                                        productId: dataSnapshot.data!
                                            .wishlistItems![index].productId,
                                        categoryId: dataSnapshot.data!
                                            .wishlistItems![index].categoryId,
                                        name: dataSnapshot
                                            .data!.wishlistItems![index].name,
                                        price: dataSnapshot
                                            .data!.wishlistItems![index].price,
                                        discountPrice: dataSnapshot
                                            .data!
                                            .wishlistItems![index]
                                            .discountPrice,
                                        discount: dataSnapshot.data!
                                            .wishlistItems![index].discount,
                                        thumbnail: dataSnapshot.data!
                                            .wishlistItems![index].thumbnail,
                                        unit: dataSnapshot
                                            .data!.wishlistItems![index].unit,
                                        isWishlist: 1,
                                        currency: dataSnapshot.data!
                                            .wishlistItems![index].currency,
                                        currencyPosition: dataSnapshot
                                            .data!
                                            .wishlistItems![index]
                                            .currencyPosition,
                                        backgroundColor: Colors.white);
                                  }),
                            )
                          : Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .15),
                                  Align(
                                    alignment: const Alignment(-0.3, 0),
                                    child: Image.asset(
                                      'no-product-found.png',
                                      height: 220,
                                    ),
                                  ),
                                  const Text(
                                    "No product added to wishlist.",
                                    style: TextStyle(fontSize: 17),
                                  )
                                ],
                              ),
                            );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
