import 'dart:async';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/providers/product_repository.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:checkout_app/widgets/app_bar.dart';
import 'package:checkout_app/widgets/product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({Key? key}) : super(key: key);

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _xcrollController = ScrollController();

  final List<dynamic> _productList = [];
  dynamic _product;
  bool _isInitial = true;
  int _page = 1;
  bool _showLoadingContainer = false;
  dynamic _authToken;

  @override
  void initState() {
    super.initState();

    fetchProducts();
    startTimer();

    _xcrollController.addListener(() {
      // print("position: " + _xcrollController.position.pixels.toString());
      // print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  fetchProducts() async {
    _authToken = await SharedPreferenceHelper().getAuthToken();
    if (_authToken == null) {
      setState(() {
        _authToken = '';
      });
    }
    var productResponse = await ProductRepository()
        .getAllProducts(page: _page, token: _authToken);
    _product = productResponse.status;
    _productList.addAll(productResponse.products!);
    // print(_productList[1].productId);
    // print(_productList[1].categoryId);
    // print(_productList[1].name);
    // print(_productList[1].price);
    // print(_productList[1].discountPrice);
    // print(_productList[1].discount);
    // print(_productList[1].thumbnail);
    // print(_productList[1].unit);
    // print(_productList[1].isWishlist);
    // print(_productList[1].currency);
    _isInitial = false;
    // _totalData = productResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _productList.clear();
    _isInitial = true;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _isInitial = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  Future<void> _onRefresh() async {
    reset();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: CustomAppBar(
          title: 'All Products',
        ),
        body: Stack(
          children: [
            buildProductList(),
            Align(
                alignment: Alignment.bottomCenter,
                child: buildLoadingContainer())
          ],
        ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 20 : 0,
      width: double.infinity,
      color: kBackgroundColor,
      child: Center(
        child: Text(
            _product == 403 ? "No More Products" : "Loading More Products ..."),
      ),
    );
  }

  buildProductList() {
    if (_isInitial && _productList.isEmpty) {
      return Shimmer.fromColors(
        //period:Duration(seconds:5),
        baseColor: Colors.white,
        highlightColor: Colors.grey,
        child: Column(
          children: [
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 240),
                padding: const EdgeInsets.all(2.0),
                shrinkWrap: true,
                itemCount: _productList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                  height:120, width:120, color:Colors.white,
                  );
                }),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      );
    } else if (_productList.isNotEmpty) {
      return RefreshIndicator(
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: Column(
              children: [
                GridView.builder(
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
                          discountPrice: _productList[index].discountPrice,
                          currency: _productList[index].currency,
                          currencyPosition:
                              _productList[index].currencyPosition,
                          discount: _productList[index].discount,
                          thumbnail: _productList[index].thumbnail,
                          unit: _productList[index].unit,
                          isWishlist: _productList[index].isWishlist,
                          backgroundColor: Colors.white);
                    }),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_product == 403) {
      return Center(
          child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .25),
          Align(
            alignment: const Alignment(-0.3, 0),
            child: Image.asset(
              'no-product-found.png',
              height: 220,
            ),
          ),
          const SizedBox(height: 20),
          const Text('No listed product found'),
        ],
      ));
    } else {
      return Shimmer.fromColors(
        //period:Duration(seconds:5),
        baseColor: Colors.white,
        highlightColor: Colors.grey,
        child: Column(
          children: [
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 240),
                padding: const EdgeInsets.all(2.0),
                shrinkWrap: true,
                itemCount: 9,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                  height:120, width:120, color:Colors.white,
                  );
                }),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ); // should never be happening
    }
  }
}
