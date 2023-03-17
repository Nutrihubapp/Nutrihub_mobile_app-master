import 'dart:convert';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/cart_product.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/models/http_exception.dart';
import 'package:checkout_app/providers/database_helper.dart';
import 'package:checkout_app/providers/hive_database_helper.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:checkout_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SearchListItem extends StatefulWidget {
  final String? productId;
  final String? categoryId, outOfStock;
  final dynamic name;
  final String? price;
  final String? discountPrice;
  final String? discount;
  final String? thumbnail;
  final String? unit;
  final String? currency;
  final String? currencyPosition;
  final Color? backgroundColor;

  const SearchListItem(
      {Key? key,
      this.productId,
      this.categoryId,
      this.name,
      this.price,
      this.discountPrice,
      this.discount,this.outOfStock,
      this.thumbnail,
      this.unit,
      this.currency,
      this.currencyPosition,
      this.backgroundColor})
      : super(key: key);

  @override
  _SearchListItemState createState() => _SearchListItemState();
}

class _SearchListItemState extends State<SearchListItem> {
  var _isInit = true;
  var isLoading = false;
  dynamic _authToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    var token = await SharedPreferenceHelper().getAuthToken();
    if (_isInit) {
      setState(() {
        isLoading = true;
        _authToken = token;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
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
        // ignore: non_constant_identifier_names
        var Msg = extractedData['message'];
        return CommonFunctions.showSuccessToast(Msg);
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
        //     arguments: widget.productId);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         ProductDetailScreen(productId: widget.productId.toString()),
        //   ),
        // );
        pushNewScreen(
                                  context,
                                  screen: ProductDetailScreen(
                                    screen: 'filter',
                                    
                                    outOfStock: widget.outOfStock,
                                    productId: widget.productId.toString()),
                                  withNavBar: false,
                                );
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 0.1,
          shadowColor: Colors.white,
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 42,
                                  child: Text(
                                    widget.name!.length < 38
                                        ? widget.name
                                        : widget.name.substring(0, 37),
                                    style: const TextStyle(
                                      fontSize: 14.0,
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
                                Row(
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
                                        fontSize: 16.0,
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
                                          fontSize: 12.0,
                                          color: Colors.black38,

                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    const Expanded(
                                      flex: 1,
                                      child: Text(''),
                                    ),
                                    ButtonTheme(
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
                                        onPressed: widget.outOfStock == "no" ||
                                    widget.outOfStock == null ? () async {
                                          if (_authToken != null) {
                                                   Map cartItem = {
                                    'productId':
                                        widget.productId.toString(),
                                    'name': widget.name,
                                    'discountPrice': widget.discountPrice
                                        .toString(),
                                    'mainPrice': widget.discountPrice
                                        .toString(),
                                    'currency':
                                         widget.currency.toString(),
                                    'currencyPosition':  widget.currencyPosition
                                        .toString(),
                                    'thumbnail':
                                      widget.thumbnail.toString(),
                                    'unit': widget.unit,
                                    'quantity': 1,  'normalPrice':  widget.discountPrice
                                        .toString(),
                                  };
                                  //  if (item == false) {
                                  await HiveDatabase.addItemToCart(
                                      cartItem, widget.productId, widget.discountPrice);
                                  _submit(widget.productId.toString());
                                          } else {
                                            var errorMsg =
                                                'Sign in to continue';
                                            CommonFunctions.showErrorDialog(
                                                errorMsg, context);
                                          }
                                        } : () {
                                   
                                    CommonFunctions.showSuccessToast(
                                        'Item is out of stock');
                                  },
                                        child:  Container(
                                              height: 35,
                                              width: 35,
                                              child: Icon(Icons.add,
                                                  color: Colors.white),
                                              decoration: BoxDecoration(
                                                color: widget.outOfStock == "yes"
                                                    ? Colors.grey
                                                    : kGreenColor,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              )),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
