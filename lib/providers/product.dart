import 'dart:convert';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/order_details_model.dart';
import 'package:checkout_app/models/order_history.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'auth.dart';

class Product with ChangeNotifier {
  dynamic authToken;
  List<OrderList> _orderHistoryItems = [];
  List<Products> _orderProducts = [];

  // dynamic price;
  // dynamic quantity;

  List<OrderList> get orderHistoryItems {
    return [..._orderHistoryItems];
  }

  List<Products> get orderProducts {
    return [..._orderProducts];
  }

  final authClass = Auth();

  Future<void> fetchOrderHistories() async {
    authToken = await SharedPreferenceHelper().getAuthToken();
    print(authClass.userToken);
    var url = BASE_URL + "api_frontend/order_histories?auth_token=$authToken";
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      final extractedData = json.decode(response.body)['order_list'] as List;
      if (extractedData.isNotEmpty) {
        _orderHistoryItems = buildOrderHistoryList(extractedData);
        notifyListeners();
      } else {
        return;
      }
      // print(extractedData);
    } catch (error) {
      rethrow;
    }
  }

  List<OrderList> buildOrderHistoryList(List extractedData) {
    final List<OrderList> loadedOrder = [];
    for (var orderData in extractedData) {
      print(orderData['paid_price'],);
      //   print(orderData['paid_price']);
      loadedOrder.add(OrderList(
        orderId: orderData['order_id'],
        totalPrice: orderData['total_price'],
        paymentType: orderData['payment_type'],
        status: orderData['status'],
        totalItems: orderData['total_items'],
        dateAdded: orderData['date_added'],
        deliveryCharge: orderData['delivery_charge'],
        tax: orderData['tax'],
      ));
      // print(catData['name']);
    }
    return loadedOrder;
  }

  Future<void> orderDetails(String id) async {
    
    var url = BASE_URL +
        "api_frontend/order_history_details?order_id=$id&auth_token=$authToken";

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body)['products'] as List;
      // print(extractedData);
      if (extractedData.isEmpty) {
        return;
      }

      _orderProducts = buildOrderDetailList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Products> buildOrderDetailList(List extractedData) {
    final List<Products> loadedOrder = [];
    for (var orderData in extractedData) {

      loadedOrder.add(Products(
        productId: orderData['product_id'],
        categoryId: orderData['category_id'],
        name: orderData['name'],
        price: orderData['price'],
        discountPrice: orderData['discount_price'],
        discount: orderData['discount'],
        unit: orderData['unit'],
        thumbnail: orderData['thumbnail'],
        itemQuantity: orderData['item_quantity'],
      ));
      // print(catData['name']);
    }
    return loadedOrder;
  }
}
