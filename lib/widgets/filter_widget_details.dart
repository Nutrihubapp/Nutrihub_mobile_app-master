// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/widgets/search_product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class FilterDetails extends StatefulWidget {
  final low;
  final high;
  final catg;
  final offer;

  const FilterDetails(this.low, this.high, this.catg, this.offer, {Key? key})
      : super(key: key);

  @override
  _FilterDetailsState createState() => _FilterDetailsState();
}

class _FilterDetailsState extends State<FilterDetails> {
  bool isLoading = false;
  var data = [];

  final ScrollController _scrollController = ScrollController();
  final ScrollController _xcrollController = ScrollController();

  final List<dynamic> _productList = [];
  dynamic _product;
  dynamic _totalItems;
  bool _isInitial = true;
  int _page = 1;
  bool _showLoadingContainer = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    fetchProducts();
    startTimer();

    _xcrollController.addListener(() {
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
    final url = BASE_URL +
        "api_frontend/product_filter?page_number=${_page.toString()}&lowest_price=${widget.low}&highest_price=${widget.high}&category_id=${widget.catg}&offer=${widget.offer}";
    // print(url);
    final response = await http.get(Uri.parse(url));
    var productResponse = jsonDecode(response.body);
    _product = productResponse['status'];
    _totalItems = productResponse['total_results'];
    _productList.addAll(productResponse['products']);
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
    Timer.periodic(const Duration(seconds: 2), (t) {
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
        appBar: AppBar(
          backgroundColor: kGreenColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Center(
              child: Align(
            alignment: Alignment(-0.3, 0),
            child: Text(
              "Search Result",
              style: TextStyle(color: Colors.white),
            ),
          )),
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
      return const Center(child: CircularProgressIndicator());
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
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Showing $_totalItems Products",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                StaggeredGridView.countBuilder(
                    padding: const EdgeInsets.all(2.0),
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _productList.length,
                    crossAxisCount: 2,
                    staggeredTileBuilder: (int index) =>
                        const StaggeredTile.fit(1),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 5.0,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return SearchListItem(
                          productId: _productList[index]['product_id'],
                          categoryId: _productList[index]['category_id'],
                          name: _productList[index]['name'],
                          price: _productList[index]['price'],
                          discountPrice: _productList[index]['discount_price'],
                          discount: _productList[index]['discount'],
                          thumbnail: _productList[index]['thumbnail'],
                          unit: _productList[index]['unit'],
                          currency: _productList[index]['currency'],
                          currencyPosition: _productList[index]
                              ['currency_position'],
                          backgroundColor: Colors.white);
                    }),
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
          const Text('No product found'),
        ],
      ));
    } else {
      return Container(); // should never be happening
    }
  }
}
