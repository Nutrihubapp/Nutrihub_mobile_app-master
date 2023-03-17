class OrderDetailsModel {
  List<Products>? products;
  int? totalItems;
  String? totalPrice;
  String? deliveryCharge;
  String? grandTotalPrice;
  String? dateAdded;
  String? userName;
  String? phone;
  String? address;
  String? message;
  int? status;
  bool? validity;

  OrderDetailsModel(
      {this.products,
      this.totalItems,
      this.totalPrice,
      this.deliveryCharge,
      this.grandTotalPrice,
      this.dateAdded,
      this.userName,
      this.phone,
      this.address,
      this.message,
      this.status,
      this.validity});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    totalItems = json['total_items'];
    totalPrice = json['total_price'];
    deliveryCharge = json['delivery_charge'];
    grandTotalPrice = json['grand_total_price'];
    dateAdded = json['date_added'];
    userName = json['user_name'];
    phone = json['phone'];
    address = json['address'];
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['total_items'] = totalItems;
    data['total_price'] = totalPrice;
    data['delivery_charge'] = deliveryCharge;
    data['grand_total_price'] = grandTotalPrice;
    data['date_added'] = dateAdded;
    data['user_name'] = userName;
    data['phone'] = phone;
    data['address'] = address;
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}

class Products {
  String? productId;
  String? categoryId;
  String? name;
  String? price;
  String? discountPrice;
  String? discount;
  String? unit;
  String? thumbnail;
  String? itemQuantity;

  Products(
      {this.productId,
      this.categoryId,
      this.name,
      this.price,
      this.discountPrice,
      this.discount,
      this.unit,
      this.thumbnail,
      this.itemQuantity});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    categoryId = json['category_id'];
    name = json['name'];
    price = json['price'];
    discountPrice = json['discount_price'];
    discount = json['discount'];
    unit = json['unit'];
    thumbnail = json['thumbnail'];
    itemQuantity = json['item_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['discount'] = discount;
    data['unit'] = unit;
    data['thumbnail'] = thumbnail;
    data['item_quantity'] = itemQuantity;
    return data;
  }
}
