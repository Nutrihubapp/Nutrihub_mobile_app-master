import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/fetch_data.dart';
import 'package:checkout_app/providers/hive_database_helper.dart';
import 'package:checkout_app/screens/product_detail_screen.dart';
import 'package:checkout_app/screens/sub_category_product_screen.dart';
import 'package:checkout_app/widgets/category_list_item.dart';
import 'package:checkout_app/widgets/filter_widget.dart';
import 'package:checkout_app/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'search_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _controller = TextEditingController();

  var _isInit = true;
  var _isLoading = false;
  var catData = [];
  var topProducts = [];
  var imageitems = [];
  dynamic count = 0;
  Timer? timer;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<FetchData>(context).fetchCategories().then((_) {
        setState(() {
          // _isLoading = false;
          catData = Provider.of<FetchData>(context, listen: false).items;
        });
      });

      Provider.of<FetchData>(context).fetchImages().then((_) {
        setState(() {
          _isLoading = false;
          imageitems =
              Provider.of<FetchData>(context, listen: false).imageItems;
        });
      });
      Provider.of<FetchData>(context).checkShopTime().then((_) {
        _isLoading = false;
        setState(() {
          shopClosingTime =
              Provider.of<FetchData>(context, listen: false).closingTime;
        });
      });

      Provider.of<FetchData>(context).fetchTopProducts().then((_) {
        setState(() {
          _isLoading = false;
          topProducts = Provider.of<FetchData>(context, listen: false).topItems;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List shopClosingTime = [];
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(milliseconds: 200), (Timer t) => getHiveCart());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // Future<List<Map<String, dynamic>>?> getCart() async {
  //   List<Map<String, dynamic>> listMap =
  //       await DatabaseHelper.instance.queryAllRows('cart_list');
  //   setState(() {
  //     count = listMap.length;
  //   });
  // }

  Future<List<Map<String, dynamic>>?> getHiveCart() async {
    Box userBox = await Hive.openBox('user_info');
    var userMapBox = await userBox.get('user_info');
    if (userMapBox != null) {
      var listMap = await HiveDatabase.getAllCartItems();
      setState(() {
        count = listMap.length;
      });
    }
  }

  void _showFilterModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return const FilterWidget();
      },
    );
  }

  bool shopIsClosed = false;
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
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        auth.changeCount(count);
      });
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
              // SizedBox(width: 10,),
              // Container(
              //   margin: EdgeInsets.only(top: 2),
              //   child: Image.asset(
              //     'Checkout-logo.png',
              //     height: 52,
              //     fit: BoxFit.cover,
              //   ),
              // ),
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
          actions: <Widget>[
          Visibility(
            visible: shopIsClosed,
            child: Image.asset('assets/closed.png',fit: BoxFit.contain,width:100,    height: 200,)),
          ],
        ),
        backgroundColor: kBackgroundColor,
        body: _isLoading
            ? Shimmer.fromColors(
                //period:Duration(seconds:5),
                baseColor: Colors.white,
                highlightColor: Colors.grey,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          left: 10, top: 15, right: 10, bottom: 5),
                      child: Form(
                        key: globalFormKey,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 2.0,
                                    top: 0.0,
                                    right: 8.0,
                                    bottom: 8.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontSize: 17.0,
                                  ),
                                  textInputAction: TextInputAction.search,
                                  keyboardType: TextInputType.text,
                                  controller: _controller,
                                  onFieldSubmitted: (String value) {
                                    final String searchValue = _controller.text;
                                    if (!globalFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    if (searchValue.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SearchDetails(
                                              value: _controller.text),
                                        ),
                                      );
                                    }
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          final String searchValue =
                                              _controller.text;
                                          if (!globalFormKey.currentState!
                                              .validate()) {
                                            return;
                                          }
                                          if (searchValue.isNotEmpty) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchDetails(
                                                        value:
                                                            _controller.text),
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.search),
                                        iconSize: 30,
                                        color: const Color(0xFFB3B3B3),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle: const TextStyle(
                                          color: Color(0xFFB3B3B3)),
                                      hintText: "Search for products",
                                      fillColor: kBackgroundColor,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14,
                                          top: 15,
                                          right: 10,
                                          bottom: 15)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 8),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 2, top: 2),
                                  child: MaterialButton(
                                    child: Image.asset(
                                      'filter_icon.png',
                                      height: 20,
                                    ),
                                    onPressed: () => _showFilterModal(context),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Text(shopClosingTime.isNotEmpty
                    //     ? 'Open Time ${shopClosingTime[0]['opentime']} - Close Time ${shopClosingTime[0]['closetime']}'
                    //     : ""),
                    imageitems.isNotEmpty
                        ? CarouselSlider(
                            items:
                                // items,

                                imageitems.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: const BoxDecoration(
                                          color: Color(0xff5B32BE)),
                                      child: GestureDetector(
                                          child: Image.network(i['imagelink'],
                                              fit: BoxFit.fill),
                                          onTap: () {
                                            if (i['type'] == "category") {
                                              Provider.of<Auth>(context,
                                                      listen: false)
                                                  .changeAppBar(false);
                                              pushNewScreen(
                                                context,
                                                screen:
                                                    SubCategoryAndProductScreen(
                                                  categoryId: i['navigationid'],
                                                  title: i['type'],
                                                ),
                                                withNavBar: false,
                                              );
                                            } else {
                                              Provider.of<Auth>(context,
                                                      listen: false)
                                                  .changeAppBar(false);
                                              pushNewScreen(
                                                context,
                                                screen: ProductDetailScreen(
                                                    productId:
                                                        i['navigationid']),
                                                withNavBar: false,
                                              );
                                            }
                                          }));
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(
                              autoPlay: true,
                            ))
                        : const SizedBox(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Row(
                        children: const <Widget>[
                          Text(
                            'Categories',
                            style: TextStyle(

                                fontSize: 18,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //height: 140,
                      //width: 200,
                     // height:1000,
                      margin: const EdgeInsets.only(
                          left: 8.0, bottom: 2.0, right: 8.0, top: 0),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 30,
                                  mainAxisExtent: 170),
                          padding: const EdgeInsets.all(2.0),
                          shrinkWrap: true,
                          itemCount: catData.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var unescape = HtmlUnescape();
                            var title = unescape.convert(catData[index].title);
                            return CategoryListItem(
                              categoryId: catData[index].categoryId,
                              parentId: catData[index].parentId,
                              title: title,
                              thumbnail: catData[index].thumbnail,
                              backgroundColor: const Color(0xFFF5F5F5),
                            );
                          }),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: 5, horizontal: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       const Text(
                    //         'Popular Products',
                    //         style: TextStyle(
                    //             
                    //             fontSize: 18,
                    //             color: Colors.black54),
                    //       ),
                    //       ButtonTheme(
                    //         padding: const EdgeInsets.symmetric(
                    //             vertical: 4.0,
                    //             horizontal:
                    //                 8.0), //adds padding inside the button
                    //         materialTapTargetSize: MaterialTapTargetSize
                    //             .shrinkWrap, //limits the touch area to the button area
                    //         minWidth: 0, //wraps child's width
                    //         height: 0,
                    //         child: MaterialButton(
                    //           // color: Colors.black12,
                    //           onPressed: () {
                    //             Provider.of<Auth>(context, listen: false)
                    //                 .changeAppBar(false);
                    // pushNewScreen(
                    //   context,
                    //   screen: AllProductScreen(),
                    //   withNavBar: false,
                    // );
                    //             // Navigator.push(
                    //             //   context,
                    //             //   MaterialPageRoute(
                    //             //     builder: (context) =>
                    //             //         const AllProductScreen(),
                    //             //   ),
                    //             // );
                    //           },
                    //           child: const Padding(
                    //             padding: EdgeInsets.only(left: 4.0, right: 4.0),
                    //             child: Text(
                    //               "See all",
                    //               style: TextStyle(color: Colors.black38),
                    //             ),
                    //           ),
                    //           padding: const EdgeInsets.all(0),
                    //           textColor: Colors.black87,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(6.0),
                    //             //side: BorderSide(color: Color.fromRGBO(100, 186, 2, 1),)
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(vertical: 0.0),
                    //   padding: const EdgeInsets.symmetric(horizontal: 4),
                    //   height: 235,
                    //   // width: 200,
                    //   child: ListView.builder(
                    //       shrinkWrap: true,
                    //       itemCount: topProducts.length,
                    //       scrollDirection: Axis.horizontal,
                    //       itemBuilder: (context, index) {
                    //         return ProductListItem(
                    //           outOfStock: topProducts[index].outOfStock,
                    //           productId: topProducts[index].productId,
                    //           categoryId: topProducts[index].categoryId,
                    //           name: topProducts[index].name,
                    //           price: topProducts[index].price,
                    //           discountPrice: topProducts[index].discountPrice,
                    //           currency: topProducts[index].currency,
                    //           currencyPosition:
                    //               topProducts[index].currencyPosition,
                    //           discount: topProducts[index].discount,
                    //           thumbnail: topProducts[index].thumbnail,
                    //           unit: topProducts[index].unit,
                    //           isWishlist: topProducts[index].isWishlist,
                    //           backgroundColor: Colors.white,
                    //         );
                    //         // var thumbnail = base_api +
                    //         //     "uploads/category/optimized/" +
                    //         //     catData[index].thumbnail;
                    //         // var unescape = HtmlUnescape();
                    //         // var title = unescape.convert(catData[index].title);
                    //         // return

                    //         // CategoryListItem(
                    //         //   categoryId: catData[index].categoryId,
                    //         //   parentId: catData[index].parentId,
                    //         //   title: title,
                    //         //   thumbnail: catData[index].thumbnail,
                    //         //   backgroundColor: Colors.white,
                    //         // );
                    //       }),
                    // ),
                    const SizedBox(height: 100),
                  ],
                ),
              )
            : ListView(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                      left: 10, top: 15, right: 10, bottom: 5),
                  child: Form(
                    key: globalFormKey,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 2.0,
                                top: 0.0,
                                right: 8.0,
                                bottom: 8.0),
                            child: TextFormField(
                              style: const TextStyle(
                                fontSize: 17.0,
                              ),
                              textInputAction: TextInputAction.search,
                              keyboardType: TextInputType.text,
                              controller: _controller,
                              onFieldSubmitted: (String value) {
                                final String searchValue = _controller.text;
                                if (!globalFormKey.currentState!
                                    .validate()) {
                                  return;
                                }
                                if (searchValue.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchDetails(
                                          value: _controller.text),
                                    ),
                                  );
                                }
                              },
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      final String searchValue =
                                          _controller.text;
                                      if (!globalFormKey.currentState!
                                          .validate()) {
                                        return;
                                      }
                                      if (searchValue.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchDetails(
                                                    value:
                                                        _controller.text),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.search),
                                    iconSize: 30,
                                    color: const Color(0xFFB3B3B3),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: const TextStyle(
                                      color: Color(0xFFB3B3B3)),
                                  hintText: "Search for products",
                                  fillColor: kBackgroundColor,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14,
                                      top: 15,
                                      right: 10,
                                      bottom: 15)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 5, bottom: 8),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 2, top: 2),
                              child: MaterialButton(
                                child: Image.asset(
                                  'filter_icon.png',
                                  height: 20,
                                ),
                                onPressed: () => _showFilterModal(context),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
               /* Center(
                  child: Text(shopClosingTime.isNotEmpty
                      ? 'Open Time ${shopClosingTime[0]['opentime']} - Close Time ${shopClosingTime[0]['closetime']}'
                      : ""),
                ),*/
                imageitems.isNotEmpty
                    ? CarouselSlider(
                        items:
                            // items,

                            imageitems.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: const BoxDecoration(
                                      color: Color(0xff5B32BE)),
                                  child: GestureDetector(
                                      child: Image.network(i['imagelink'],
                                          fit: BoxFit.fill),
                                      onTap: () {
                                        if (i['type'] == "category") {
                                          Provider.of<Auth>(context,
                                                  listen: false)
                                              .changeAppBar(false);
                                          pushNewScreen(
                                            context,
                                            screen:
                                                SubCategoryAndProductScreen(
                                              categoryId: i['navigationid'],
                                              title: i['type'],
                                            ),
                                            withNavBar: false,
                                          );
                                        } else {
                                          Provider.of<Auth>(context,
                                                  listen: false)
                                              .changeAppBar(false);
                                          pushNewScreen(
                                            context,
                                            screen: ProductDetailScreen(
                                                productId:
                                                    i['navigationid']),
                                            withNavBar: false,
                                          );
                                        }
                                      }));
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                        ))
                    : const SizedBox(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
                  child: Row(
                    children: const <Widget>[
                      Text(
                        'Categories',
                        style: TextStyle(
                            
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Container(


                  //height: 140,
                  //width: 200,
                  // padding: EdgeInsets.only(bottom: 0),
                  // height: MediaQuery.of(context).size.height * 0.8,
                  margin:  EdgeInsets.only(
                      left: 8.0, bottom: 2, right: 8.0, top: 0),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.5,
                            mainAxisExtent: 155.0,
                          ),
                      padding: const EdgeInsets.all(2.0),
                      shrinkWrap: true,
                      itemCount: catData.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var unescape = HtmlUnescape();
                        var title = unescape.convert(catData[index].title);
                        return CategoryListItem(
                          categoryId: catData[index].categoryId,
                          parentId: catData[index].parentId,
                          title: title,
                          thumbnail: catData[index].thumbnail,
                          backgroundColor: Colors.white,
                        );
                      }),
                ),
                SizedBox(
                  height: 50
                )
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.symmetric(
                //       vertical: 5, horizontal: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       const Text(
                //         'Popular Products',
                //         style: TextStyle(
                //             
                //             fontSize: 18,
                //             color: Colors.black54),
                //       ),
                //       ButtonTheme(
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 4.0,
                //             horizontal:
                //                 8.0), //adds padding inside the button
                //         materialTapTargetSize: MaterialTapTargetSize
                //             .shrinkWrap, //limits the touch area to the button area
                //         minWidth: 0, //wraps child's width
                //         height: 0,
                //         child: MaterialButton(
                //           // color: Colors.black12,
                //           onPressed: () {
                //             Provider.of<Auth>(context, listen: false)
                //                 .changeAppBar(false);
                // pushNewScreen(
                //   context,
                //   screen: AllProductScreen(),
                //   withNavBar: false,
                // );
                //             // Navigator.push(
                //             //   context,
                //             //   MaterialPageRoute(
                //             //     builder: (context) =>
                //             //         const AllProductScreen(),
                //             //   ),
                //             // );
                //           },
                //           child: const Padding(
                //             padding: EdgeInsets.only(left: 4.0, right: 4.0),
                //             child: Text(
                //               "See all",
                //               style: TextStyle(color: Colors.black38),
                //             ),
                //           ),
                //           padding: const EdgeInsets.all(0),
                //           textColor: Colors.black87,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(6.0),
                //             //side: BorderSide(color: Color.fromRGBO(100, 186, 2, 1),)
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // Container(
                //   margin: const EdgeInsets.symmetric(vertical: 0.0),
                //   padding: const EdgeInsets.symmetric(horizontal: 4),
                //   height: 235,
                //   // width: 200,
                //   child: ListView.builder(
                //       shrinkWrap: true,
                //       itemCount: topProducts.length,
                //       scrollDirection: Axis.horizontal,
                //       itemBuilder: (context, index) {
                //         return ProductListItem(
                //           outOfStock: topProducts[index].outOfStock,
                //           productId: topProducts[index].productId,
                //           categoryId: topProducts[index].categoryId,
                //           name: topProducts[index].name,
                //           price: topProducts[index].price,
                //           discountPrice: topProducts[index].discountPrice,
                //           currency: topProducts[index].currency,
                //           currencyPosition:
                //               topProducts[index].currencyPosition,
                //           discount: topProducts[index].discount,
                //           thumbnail: topProducts[index].thumbnail,
                //           unit: topProducts[index].unit,
                //           isWishlist: topProducts[index].isWishlist,
                //           backgroundColor: Colors.white,
                //         );
                //         // var thumbnail = base_api +
                //         //     "uploads/category/optimized/" +
                //         //     catData[index].thumbnail;
                //         // var unescape = HtmlUnescape();
                //         // var title = unescape.convert(catData[index].title);
                //         // return

                //         // CategoryListItem(
                //         //   categoryId: catData[index].categoryId,
                //         //   parentId: catData[index].parentId,
                //         //   title: title,
                //         //   thumbnail: catData[index].thumbnail,
                //         //   backgroundColor: Colors.white,
                //         // );
                //       }),
                // ),

              ],
            ),
      );
    });
  }
}
