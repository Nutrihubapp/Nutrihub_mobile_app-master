import 'dart:async';
import 'dart:convert';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/widgets/search_product_list_item.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SearchDetails extends StatefulWidget {
  final String? value;

  const SearchDetails({Key? key, this.value}) : super(key: key);

  @override
  _SearchDetailsState createState() => _SearchDetailsState();
}

class _SearchDetailsState extends State<SearchDetails> {
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

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchProducts();

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
    final response = await http.get(Uri.parse(BASE_URL +
        "api_frontend/product_search?search_value=${widget.value}&page_number=${_page.toString()}"));
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

  Future<void> _onRefresh() async {
    reset();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.value.toString();
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          elevation: 0.1,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: kGreenColor,
          title: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Form(
              key: globalFormKey,
              child: TextFormField(
                style: const TextStyle(
                  fontSize: 18.0,
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
                        builder: (context) =>
                            SearchDetails(value: _controller.text),
                      ),
                    );
                  }
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        final String searchValue = _controller.text;
                        if (!globalFormKey.currentState!.validate()) {
                          return;
                        }
                        if (searchValue.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //builder: (context) => SubCategory(item: subCat[index]),
                              builder: (context) =>
                                  SearchDetails(value: _controller.text),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.search),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    hintText: "Search Your Product",
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(left: 10, right: 10)),
              ),
            ),
          ),
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
                          outOfStock:  _productList[index]['outofstock'],
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