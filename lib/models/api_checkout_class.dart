class ApiCheckoutClass {
  int? totalItems;
  String? totalPrice;
  String? deliveryCharge;
  String? tax;
  String? taxVal;
  String? grandTotalPrice;
  String? paypal;
  String? razorpay;
  String? paytm;
  String? userId;
  String? userName;
  String? phone;
  String? address;
  String? message;
  int? status;
  bool? validity;
  String? stripe;

  ApiCheckoutClass(
      {this.totalItems,
      this.totalPrice,
      this.stripe,
      this.deliveryCharge,
      this.tax,
      this.taxVal,
      this.grandTotalPrice,
      this.paypal,
      this.razorpay,
      this.paytm,
      this.userId,
      this.userName,
      this.phone,
      this.address,
      this.message,
      this.status,
      this.validity});

  ApiCheckoutClass.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    totalPrice = json['total_price'];
    deliveryCharge = json['delivery_charge'];
    tax = json['tax'];
    taxVal = json['tax_val'];
    grandTotalPrice = json['grand_total_price'];
    paypal = json['paypal'];
    razorpay = json['razorpay'];
    paytm = json['paytm'];
    stripe = json['stripe'];
    userId = json['user_id'];
    userName = json['user_name'];
    phone = json['phone'];
    address = json['address'];
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['total_items'] = totalItems;
  //   data['total_price'] = totalPrice;
  //   data['delivery_charge'] = deliveryCharge;
  //   data['tax'] = tax;
  //   data['tax_val'] = taxVal;
  //   data['grand_total_price'] = grandTotalPrice;
  //   data['paypal'] = paypal;
  //   data['razorpay'] = razorpay;
  //   data['paytm'] = paytm;
  //   data['stripe'] = stripe;
  //   data['user_id'] = userId;
  //   data['user_name'] = userName;
  //   data['phone'] = phone;
  //   data['address'] = address;
  //   data['message'] = message;
  //   data['status'] = status;
  //   data['validity'] = validity;
  //   return data;
  // }
}
