class OrderConfirm {
  String? paymentType;
  String? totalPrice;
  int? orderId;
  String? message;
  int? status;
  bool? validity;

  OrderConfirm(
      {this.paymentType,
      this.totalPrice,
      this.orderId,
      this.message,
      this.status,
      this.validity});

  OrderConfirm.fromJson(Map<String, dynamic> json) {
    paymentType = json['payment_type'];
    totalPrice = json['total_price'];
    orderId = json['order_id'];
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_type'] = paymentType;
    data['total_price'] = totalPrice;
    data['order_id'] = orderId;
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}
