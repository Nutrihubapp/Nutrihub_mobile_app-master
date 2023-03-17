import 'dart:convert';
import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/cart_product.dart';
import 'package:checkout_app/models/parent_categories.dart';
import 'package:checkout_app/models/top_products.dart';
import 'package:checkout_app/providers/hive_database_helper.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'database_helper.dart';

class FetchData with ChangeNotifier {
  List<ParentCategories> _items = [];
  List<TopProducts> _topItems = [];
  List<CartProduct> _listProducts = [];
  List imageItems = [];
  List<ParentCategories> get items {
    return [..._items];
  }

  List<TopProducts> get topItems {
    return [..._topItems];
  }

  List<CartProduct> get listProducts {
    return [..._listProducts];
  }

  Future<void> fetchCategories() async {
    var url = BASE_URL + "api_frontend/parent_categories";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData =
          json.decode(response.body)['parent_categories'] as List;
      if (extractedData.isNotEmpty) {
        final List<ParentCategories> loadedCategories = [];

        for (var catData in extractedData) {
          loadedCategories.add(ParentCategories(
            categoryId: catData['category_id'],
            title: catData['title'],
            parentId: catData['parent_id'],
            thumbnail: catData['thumbnail'],
            categoryType: catData['category_type'],
            top: catData['top'],
            status: catData['status'],
          ));

          // print(catData['name']);
        }
        _items = loadedCategories;
        notifyListeners();
      } else {
        return;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchTopProducts() async {
    var _authToken = await SharedPreferenceHelper().getAuthToken();
    String token;
    String url;
    if (_authToken != null) {
      token = _authToken;
      url = BASE_URL + "api_frontend/top_products?auth_token=$token";
    } else {
      url = BASE_URL + "api_frontend/top_products";
    }
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body)['top_products'] as List;
      if (extractedData.isNotEmpty) {
        final List<TopProducts> loadedProducts = [];

        for (var catData in extractedData) {
          loadedProducts.add(TopProducts(
            outOfStock:catData['outofstock'],
            productId: catData['product_id'],
            categoryId: catData['category_id'],
            name: catData['name'],
            thumbnail: catData['thumbnail'],
            price: catData['price'],
            discountPrice: catData['discount_price'],
            currency: catData['currency'],
            currencyPosition: catData['currency_position'],
            discount: catData['discount'],
            unit: catData['unit'],
            isWishlist: catData['is_wishlist'],
          ));

          // print(catData['name']);
        }
        _topItems = loadedProducts;
        notifyListeners();
      } else {
        return;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future getCart() async {
   
    List listMap =
      await HiveDatabase.getAllCartItems();
    final List<CartProduct> loadedProducts = [];
    for (var map in listMap) {
      loadedProducts.add(CartProduct.fromMap( Map<String, dynamic>.from(map)));
    }
    _listProducts = loadedProducts;
    notifyListeners();
    // for (int i = 0; i < listProducts.length; i++) {
    //   totalPrice = totalPrice + listProducts[i].mainPrice;
    //   currency = listProducts[i].currency;
    //   currencyPosition = listProducts[i].currencyPosition;
    // }
  }

  List closingTime = [];
  Future checkShopTime() async {
    try {
      String url = "https://greenersapp.com/greenersapp/api_frontend/time";
      final response = await http.get(Uri.parse(url),
          headers: {'Content-type': ' application/json', 'Charset': 'utf-8'});
      if (response.statusCode == 200) {
        var parseJson = parse(response.body);
        //   imageItems = [parseJson.body!.innerHtml];
        closingTime = jsonDecode(parseJson.body!.innerHtml);
        
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchImages() async {
    var url = "http://greenersapp.com/greenersapp/api_frontend/slideshowbanner";
    try {
      final response = await http.get(Uri.parse(url),
          headers: {'Content-type': ' application/json', 'Charset': 'utf-8'});
      if (response.statusCode == 200) {
        var parseJson = parse(response.body);
        //   imageItems = [parseJson.body!.innerHtml];
        imageItems = jsonDecode(parseJson.body!.innerHtml);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
  List couponList = [];
  Future<void> fetchCuponCode() async {
    var url = "https://greenersapp.com/greenersapp/api_frontend/discountcode";
    try {
      final response = await http.get(Uri.parse(url),
          headers: {'Content-type': ' application/json', 'Charset': 'utf-8'});
      if (response.statusCode == 200) {
        var parseJson = parse(response.body);
        //   imageItems = [parseJson.body!.innerHtml];
        couponList = jsonDecode(parseJson.body!.innerHtml);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

}


class Item {
  String name;
  String age;
  Item(this.age, this.name);
  static fromJson(Map data) {
    print(data);
  }
}
