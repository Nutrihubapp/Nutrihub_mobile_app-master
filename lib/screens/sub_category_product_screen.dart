import 'dart:async';
import 'dart:io';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/providers/product_repository.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:checkout_app/widgets/category_list_item.dart';
import 'package:checkout_app/widgets/product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SubCategoryAndProductScreen extends StatefulWidget {
  static const routeName = '/category-product';

  final String? categoryId;
  final String? title;

  const SubCategoryAndProductScreen({Key? key, this.categoryId, this.title})
      : super(key: key);

  @override
  _SubCategoryAndProductScreenState createState() =>
      _SubCategoryAndProductScreenState();
}

class _SubCategoryAndProductScreenState
    extends State<SubCategoryAndProductScreen> {
  final List<dynamic> _categoryList = [];
  final List<dynamic> _productList = [];
  bool _isInitial = true;
  var title = '';
  dynamic _authToken;

  @override
  void initState() {
    super.initState();
    fetchSubCat();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
     super.didChangeDependencies();
  }

  fetchSubCat() async {
    _authToken = await SharedPreferenceHelper().getAuthToken();
    if (_authToken == null) {
      setState(() {
        _authToken = '';
      });
    }
    var productResponse = await ProductRepository()
        .fetchSubCategoriesById(value: widget.categoryId, token: _authToken);
    _categoryList.addAll(productResponse.subCategories!);
    _productList.addAll(productResponse.productsByCategory!);
    _isInitial = false;
    // _totalData = productResponse.meta.total;
    setState(() {});
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        _isInitial = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
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
              Provider.of<Auth>(context, listen: false).userToken;
              Navigator.pop(context);
            }),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Text(
              '${widget.title}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: buildCategoryList(),
      ),
    );
  }

  buildCategoryList() {
    if (_isInitial && _categoryList.isEmpty) {
      return Shimmer.fromColors(
          //period:Duration(seconds:5),
          baseColor: Colors.white,
          highlightColor: Colors.grey,
          child: SizedBox(
            height: 700,
            //width:120,
            child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 240),
                padding: const EdgeInsets.all(2.0),
                shrinkWrap: true,
                itemCount: 5,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return const IgnorePointer(
                    child: ProductListItem(
                        outOfStock: '',
                        productId: '',
                        categoryId: '',
                        name: '',
                        price: '',
                        discountPrice: '',
                        discount: '',
                        currency: '',
                        currencyPosition: '',
                        thumbnail: '',
                        unit: '',
                        isWishlist: 0,
                        backgroundColor: Colors.white),
                  );
                }),
          ));
    } else {
      return _categoryList.isEmpty && _productList.isEmpty
          ? Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .15),
                  Align(
                    alignment: const Alignment(-0.3, 0),
                    child: Image.asset(
                      'no-product-found.png',
                      height: 220,
                    ),
                  ),
                  const Text(
                    "No product found.",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (_categoryList.isNotEmpty)
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 20, top: 5),
                          child: Text(
                            widget.title.toString(),
                            style: const TextStyle(

                                fontSize: 18,
                                color: Colors.black54),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 0.0),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                         // height: 140,
                          child:GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 25,
                                  mainAxisExtent: 150),
                          padding: const EdgeInsets.all(2.0),
                          shrinkWrap: true,
                          itemCount: _categoryList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                                // var thumbnail = base_api + "uploads/category/optimized/" + _categoryList[index].thumbnail;
                                var unescape = HtmlUnescape();
                                var title = unescape
                                    .convert(_categoryList[index].title);
                                return CategoryListItem(
                                  categoryId: _categoryList[index].categoryId,
                                  parentId: _categoryList[index].parentId,
                                  title: title,
                                  thumbnail: _categoryList[index].thumbnail,
                                  backgroundColor: Colors.white,

                                );
                              }),
                        ),
                      ],
                    ),
                  if (_productList.isNotEmpty)

                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 20, top: 5),
                          child: Text(
                            '${widget.title}',
                            style: const TextStyle(

                                fontSize: 18,
                                color: Colors.black54),
                          ),
                        ),
                        Container(
                          // height: MediaQuery.of(context).size.height / 1.35,
                          margin: const EdgeInsets.only(
                              left: 8.0, bottom: 2.0, right: 8.0, top: 0),
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 10,
                                      mainAxisExtent: 240),
                              padding: const EdgeInsets.all(2.0),
                              shrinkWrap: true,
                              itemCount: _productList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ProductListItem(
                                    outOfStock: _productList[index].outOfStock,
                                    productId: _productList[index].productId,
                                    categoryId: _productList[index].categoryId,
                                    name: _productList[index].name,
                                    price: _productList[index].price,
                                    discountPrice:
                                        _productList[index].discountPrice,
                                    discount: _productList[index].discount,
                                    currency: _productList[index].currency,
                                    currencyPosition:
                                        _productList[index].currencyPosition,
                                    thumbnail: _productList[index].thumbnail,
                                    unit: _productList[index].unit,
                                    isWishlist: _productList[index].isWishlist,
                                    backgroundColor: Colors.white);
                              }),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                ],
              ),
            ); // should never be happening
    }
  }

  buildProductList() {
    if (_isInitial && _productList.isEmpty) {
      return Shimmer.fromColors(
          //period:Duration(seconds:5),
          baseColor: Colors.white,
          highlightColor: Colors.grey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  //  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20, top: 5),
                  child: const Text(
                    'Products',
                    style: TextStyle(

                        fontSize: 18,
                        color: Colors.black54),
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height / 1.35,
                  margin: const EdgeInsets.only(
                      left: 8.0, bottom: 2.0, right: 8.0, top: 0),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              mainAxisExtent: 240),
                      padding: const EdgeInsets.all(2.0),
                      shrinkWrap: true,
                      itemCount: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.grey,
                        );
                      }),
                ),
              ],
            ),
          ));
    } else {
      return _productList.isEmpty
          ? Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .15),
                  Align(
                    alignment: const Alignment(-0.3, 0),
                    child: Image.asset(
                      'no-product-found.png',
                      height: 220,
                    ),
                  ),
                  const Text(
                    "No product found.",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 20, top: 5),
                    child: const Text(
                      'Products',
                      style: TextStyle(
                          
                          fontSize: 18,
                          color: Colors.black54),
                    ),
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height / 1.35,
                    margin: const EdgeInsets.only(
                        left: 8.0, bottom: 2.0, right: 8.0, top: 0),
                    child: StaggeredGridView.countBuilder(
                        padding: const EdgeInsets.all(2.0),
                        shrinkWrap: true,
                        itemCount: _productList.length,
                        crossAxisCount: 2,
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 5.0,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          print(_productList[index].thumbnail);
                          return ProductListItem(

                              productId: _productList[index].productId,
                              categoryId: _productList[index].categoryId,
                              name: _productList[index].name.toString(),
                              price: _productList[index].price,
                              discountPrice: _productList[index].discountPrice,
                              discount: _productList[index].discount,
                              thumbnail: _productList[index].thumbnail,
                              unit: _productList[index].unit,
                              isWishlist: _productList[index].isWishlist,
                              backgroundColor: Colors.white);

                        }),

                  ),
                ],
              ),
            ); // should never be happening
    }
  }
}