class OrderHistory {
  List<OrderList>? orderList;
  String? message;
  int? status;
  bool? validity;

  OrderHistory({this.orderList, this.message, this.status, this.validity});

  OrderHistory.fromJson(Map<String, dynamic> json) {
    if (json['order_list'] != null) {
      orderList = <OrderList>[];
      json['order_list'].forEach((v) {
        orderList!.add(OrderList.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderList != null) {
      data['order_list'] = orderList!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}

class OrderList {
  String? orderId;
  String? totalPrice;
  String? paymentType;
  String? status;
  int? totalItems;
  String? dateAdded;
  String? deliveryCharge;
  String? tax;

  OrderList(
      {this.orderId,
      this.totalPrice,
      this.paymentType,
      this.status,
      this.totalItems,
      this.dateAdded,
      this.deliveryCharge,
      this.tax});

  OrderList.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    totalPrice = json['total_price'];
    paymentType = json['payment_type'];
    status = json['status'];
    totalItems = json['total_items'];
    dateAdded = json['date_added'];
    deliveryCharge = json['delivery_charge'];
    tax = json['tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['total_price'] = totalPrice;
    data['payment_type'] = paymentType;
    data['status'] = status;
    data['total_items'] = totalItems;
    data['date_added'] = dateAdded;
    data['delivery_charge'] = deliveryCharge;
    data['tax'] = tax;
    return data;
  }
}
