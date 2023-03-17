import 'dart:convert';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/all_products.dart';
import 'package:checkout_app/models/price_range.dart';
import 'package:checkout_app/models/sub_product_category.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<AllProducts> getAllProducts({@required page, String? token}) async {
    dynamic url;
    url =
        BASE_URL + "api_frontend/products?page_number=$page&auth_token=$token";

    final response = await http.get(Uri.parse(url));
    return AllProducts.fromJson(jsonDecode(response.body));
  }

  Future<SubProductCategory> fetchSubCategoriesById(
      {@required value, String? token}) async {
    dynamic url;
    url = BASE_URL +
        "api_frontend/categories_and_products_by_category?category_id=$value&auth_token=$token";
    final response = await http.get(Uri.parse(url));
    return SubProductCategory.fromJson(jsonDecode(response.body));
  }

  Future<PriceRange> getRange() async {
    final response = await http
        .get(Uri.parse(BASE_URL + "api_frontend/highest_and_lowest_price"));
    return PriceRange.fromJson(jsonDecode(response.body));
  }
}
