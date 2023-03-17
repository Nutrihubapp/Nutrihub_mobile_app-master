import 'package:carousel_slider/carousel_slider.dart';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/providers/fetch_data.dart';
import 'package:checkout_app/widgets/category_list_item.dart';
import 'package:checkout_app/widgets/filter_widget.dart';
import 'package:checkout_app/widgets/product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import 'all_product_screen.dart';
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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<FetchData>(context).fetchCategories().then((_) {
        setState(() {
          _isLoading = false;
          catData = Provider.of<FetchData>(context, listen: false).items;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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

  List<Widget> items = [
    Image.network(
        'https://cdn.britannica.com/17/196817-050-6A15DAC3/vegetables.jpg'),
    Image.network(
        'https://cdn.accentuate.io/383292833839/4504505778223/vegetables-v1574121382010.jpg?2000x1500'),
    Image.network(
        'https://www.finedininglovers.com/sites/g/files/xknfdk626/files/styles/article_1200_800_fallback/public/2020-07/Mango_hack_Becky_Mattson_Unsplash.jpg?itok=0Vouk2zP'),
    Image.network(
        'https://www.reyesgutierrez.com/wp-content/uploads/2020/07/Mango-Noticias.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
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
                                  left: 2.0, top: 0.0, right: 8.0, bottom: 8.0),
                              child: TextFormField(
                                style: const TextStyle(
                                  fontSize: 17.0,
                                ),
                                textInputAction: TextInputAction.search,
                                keyboardType: TextInputType.text,
                                controller: _controller,
                                onFieldSubmitted: (String value) {
                                  final String searchValue = _controller.text;
                                  if (!globalFormKey.currentState!.validate()) {
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
                                                      value: _controller.text),
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
                  CarouselSlider(
                      items: items,
                      options: CarouselOptions(
                        // height: 200,
                        // aspectRatio: 16 / 9,
                        // viewportFraction: 0.9,
                        // initialPage: 0,
                        // enableInfiniteScroll: true,
                        // reverse: false,
                        autoPlay: true,
                        // autoPlayInterval: const Duration(seconds: 3),
                        // autoPlayAnimationDuration:
                        //     const Duration(milliseconds: 800),
                        // autoPlayCurve: Curves.fastOutSlowIn,
                        // enlargeCenterPage: false,
                        // //  onPageChanged: (){},
                        // scrollDirection: Axis.horizontal,
                      )),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Popular Products',
                          style: TextStyle(
                              
                              fontSize: 18,
                              color: Colors.black54),
                        ),
                        ButtonTheme(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0), //adds padding inside the button
                          materialTapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, //limits the touch area to the button area
                          minWidth: 0, //wraps child's width
                          height: 0,
                          child: MaterialButton(
                            // color: Colors.black12,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AllProductScreen(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Text(
                                "See all",
                                style: TextStyle(color: Colors.black38),
                              ),
                            ),
                            padding: const EdgeInsets.all(0),
                            textColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              //side: BorderSide(color: Color.fromRGBO(100, 186, 2, 1),)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 0.0),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 250,
                    // width: 200,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: topProducts.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ProductListItem(
                              productId: topProducts[index].productId,
                              categoryId: topProducts[index].categoryId,
                              name: topProducts[index].remark,
                              price: topProducts[index].price,
                              discountPrice: topProducts[index].discountPrice,
                              currency: topProducts[index].currency,
                              currencyPosition:
                                  topProducts[index].currencyPosition,
                              discount: topProducts[index].discount,
                              thumbnail: topProducts[index].thumbnail,
                              unit: topProducts[index].unit,
                              isWishlist: topProducts[index].isWishlist,
                              backgroundColor: Colors.white);
                          // var thumbnail = base_api +
                          //     "uploads/category/optimized/" +
                          //     catData[index].thumbnail;
                          // var unescape = HtmlUnescape();
                          // var title = unescape.convert(catData[index].title);
                          // return

                          // CategoryListItem(
                          //   categoryId: catData[index].categoryId,
                          //   parentId: catData[index].parentId,
                          //   title: title,
                          //   thumbnail: catData[index].thumbnail,
                          //   backgroundColor: Colors.white,
                          // );
                        }),
                  ),
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
                    height: MediaQuery.of(context).size.height / 1.35,
                    margin: const EdgeInsets.only(
                        left: 8.0, bottom: 2.0, right: 8.0, top: 0),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 150),
                        padding: const EdgeInsets.all(2.0),
                        shrinkWrap: true,
                        itemCount: catData.length,

                        // staggeredTileBuilder: (int index) =>
                        //     const StaggeredTile.fit(1),
                        // mainAxisSpacing: 8.0,
                        // crossAxisSpacing: 5.0,
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

                          //  ProductListItem(
                          //     productId: topProducts[index].productId,
                          //     categoryId: topProducts[index].categoryId,
                          //     name: topProducts[index].name,
                          //     price: topProducts[index].price,
                          //     discountPrice: topProducts[index].discountPrice,
                          //     currency: topProducts[index].currency,
                          //     currencyPosition:
                          //         topProducts[index].currencyPosition,
                          //     discount: topProducts[index].discount,
                          //     thumbnail: topProducts[index].thumbnail,
                          //     unit: topProducts[index].unit,
                          //     isWishlist: topProducts[index].isWishlist,
                          //     backgroundColor: Colors.white);
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}




//import 'package:checkout_app/constants.dart';
// import 'package:checkout_app/providers/fetch_data.dart';
// import 'package:checkout_app/widgets/category_list_item.dart';
// import 'package:checkout_app/widgets/filter_widget.dart';
// import 'package:checkout_app/widgets/product_list_item.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:html_unescape/html_unescape.dart';
// import 'package:provider/provider.dart';

// import 'all_product_screen.dart';
// import 'search_details.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   final TextEditingController _controller = TextEditingController();

//   var _isInit = true;
//   var _isLoading = false;
//   var catData = [];
//   var topProducts = [];

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       setState(() {
//         _isLoading = true;
//       });

//       Provider.of<FetchData>(context).fetchCategories().then((_) {
//         setState(() {
//           _isLoading = false;
//           catData = Provider.of<FetchData>(context, listen: false).items;
//         });
//       });

//       Provider.of<FetchData>(context).fetchTopProducts().then((_) {
//         setState(() {
//           _isLoading = false;
//           topProducts = Provider.of<FetchData>(context, listen: false).topItems;
//         });
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void setState(fn) {
//     if (mounted) super.setState(fn);
//   }

//   void _showFilterModal(BuildContext ctx) {
//     showModalBottomSheet(
//       context: ctx,
//       isScrollControlled: true,
//       builder: (_) {
//         return const FilterWidget();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       body: _isLoading
//           ? SizedBox(
//               height: MediaQuery.of(context).size.height * .5,
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     color: Colors.white,
//                     padding: const EdgeInsets.only(
//                         left: 10, top: 15, right: 10, bottom: 5),
//                     child: Form(
//                       key: globalFormKey,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 8,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 2.0, top: 0.0, right: 8.0, bottom: 8.0),
//                               child: TextFormField(
//                                 style: const TextStyle(
//                                   fontSize: 17.0,
//                                 ),
//                                 textInputAction: TextInputAction.search,
//                                 keyboardType: TextInputType.text,
//                                 controller: _controller,
//                                 onFieldSubmitted: (String value) {
//                                   final String searchValue = _controller.text;
//                                   if (!globalFormKey.currentState!.validate()) {
//                                     return;
//                                   }
//                                   if (searchValue.isNotEmpty) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => SearchDetails(
//                                             value: _controller.text),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 decoration: InputDecoration(
//                                     enabledBorder: const OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(8.0)),
//                                       borderSide: BorderSide(
//                                           color: Colors.white, width: 2),
//                                     ),
//                                     focusedBorder: const OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(8.0)),
//                                       borderSide: BorderSide(
//                                           color: Colors.white, width: 2),
//                                     ),
//                                     suffixIcon: IconButton(
//                                       onPressed: () async {
//                                         final String searchValue =
//                                             _controller.text;
//                                         if (!globalFormKey.currentState!
//                                             .validate()) {
//                                           return;
//                                         }
//                                         if (searchValue.isNotEmpty) {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   SearchDetails(
//                                                       value: _controller.text),
//                                             ),
//                                           );
//                                         }
//                                       },
//                                       icon: const Icon(Icons.search),
//                                       iconSize: 30,
//                                       color: const Color(0xFFB3B3B3),
//                                     ),
//                                     border: const OutlineInputBorder(
//                                       borderSide:
//                                           BorderSide(color: Colors.white),
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(5.0),
//                                       ),
//                                     ),
//                                     filled: true,
//                                     hintStyle: const TextStyle(
//                                         color: Color(0xFFB3B3B3)),
//                                     hintText: "Search for products",
//                                     fillColor: kBackgroundColor,
//                                     contentPadding: const EdgeInsets.only(
//                                         left: 14,
//                                         top: 15,
//                                         right: 10,
//                                         bottom: 15)),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 5, bottom: 8),
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.only(bottom: 2, top: 2),
//                                 child: MaterialButton(
//                                   child: Image.asset(
//                                     'filter_icon.png',
//                                     height: 20,
//                                   ),
//                                   onPressed: () => _showFilterModal(context),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: double.infinity,
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                     child: const Text(
//                       'Categories',
//                       style: TextStyle(
//                           
//                           fontSize: 18,
//                           color: Colors.black54),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(vertical: 0.0),
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     height: 140,
//                     child: ListView.builder(
//                         itemCount: catData.length,
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) {
//                           // var thumbnail = base_api +
//                           //     "uploads/category/optimized/" +
//                           //     catData[index].thumbnail;
//                           var unescape = HtmlUnescape();
//                           var title = unescape.convert(catData[index].title);
//                           return CategoryListItem(
//                             categoryId: catData[index].categoryId,
//                             parentId: catData[index].parentId,
//                             title: title,
//                             thumbnail: catData[index].thumbnail,
//                             backgroundColor: Colors.white,
//                           );
//                         }),
//                   ),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10, horizontal: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         const Text(
//                           'Popular Products',
//                           style: TextStyle(
//                               
//                               fontSize: 18,
//                               color: Colors.black54),
//                         ),
//                         ButtonTheme(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 4.0,
//                               horizontal: 8.0), //adds padding inside the button
//                           materialTapTargetSize: MaterialTapTargetSize
//                               .shrinkWrap, //limits the touch area to the button area
//                           minWidth: 0, //wraps child's width
//                           height: 0,
//                           child: MaterialButton(
//                             // color: Colors.black12,
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       const AllProductScreen(),
//                                 ),
//                               );
//                             },
//                             child: const Padding(
//                               padding: EdgeInsets.only(left: 4.0, right: 4.0),
//                               child: Text(
//                                 "See all",
//                                 style: TextStyle(color: Colors.black38),
//                               ),
//                             ),
//                             padding: const EdgeInsets.all(0),
//                             textColor: Colors.black87,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6.0),
//                               //side: BorderSide(color: Color.fromRGBO(100, 186, 2, 1),)
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     // height: MediaQuery.of(context).size.height / 1.35,
//                     margin: const EdgeInsets.only(
//                         left: 8.0, bottom: 2.0, right: 8.0, top: 0),
//                     child: SingleChildScrollView(
//                       child: StaggeredGridView.countBuilder(
//                           padding: const EdgeInsets.all(2.0),
//                           shrinkWrap: true,
//                           itemCount: topProducts.length,
//                           crossAxisCount: 2,
//                           staggeredTileBuilder: (int index) =>
//                               const StaggeredTile.fit(1),
//                           mainAxisSpacing: 8.0,
//                           crossAxisSpacing: 5.0,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return ProductListItem(
//                                 productId: topProducts[index].productId,
//                                 categoryId: topProducts[index].categoryId,
//                                 name: topProducts[index].name,
//                                 price: topProducts[index].price,
//                                 discountPrice: topProducts[index].discountPrice,
//                                 currency: topProducts[index].currency,
//                                 currencyPosition:
//                                     topProducts[index].currencyPosition,
//                                 discount: topProducts[index].discount,
//                                 thumbnail: topProducts[index].thumbnail,
//                                 unit: topProducts[index].unit,
//                                 isWishlist: topProducts[index].isWishlist,
//                                 backgroundColor: Colors.white);
//                           }),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

