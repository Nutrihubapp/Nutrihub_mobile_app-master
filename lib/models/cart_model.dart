class CartModel {
  List<CartItems>? cartItems;
  String? totalPrice;
  String? totalDiscountedPrice;
  bool? discountType;
  int? status;

  CartModel(
      {this.cartItems,
      this.totalPrice,
      this.totalDiscountedPrice,
      this.discountType,
      this.status});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['cart_items'] != null) {
      cartItems = <CartItems>[];
      json['cart_items'].forEach((v) {
        cartItems!.add(CartItems.fromJson(v));
      });
    }
    totalPrice = json['total_price'];
    totalDiscountedPrice = json['total_discounted_price'];
    discountType = json['discount_type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cartItems != null) {
      data['cart_items'] = cartItems!.map((v) => v.toJson()).toList();
    }
    data['total_price'] = totalPrice;
    data['total_discounted_price'] = totalDiscountedPrice;
    data['discount_type'] = discountType;
    data['status'] = status;
    return data;
  }
}

class CartItems {
  String? productId;
  String? productName;
  String? unit;
  String? mainPrice;
  String? mainDiscountPrice;
  String? price;
  String? discountPrice;
  bool? discountType;
  String? quantity;
  String? productThumbnail;

  CartItems(
      {this.productId,
      this.productName,
      this.unit,
      this.mainPrice,
      this.mainDiscountPrice,
      this.price,
      this.discountPrice,
      this.discountType,
      this.quantity,
      this.productThumbnail});

  CartItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    unit = json['unit'];
    mainPrice = json['main_price'];
    mainDiscountPrice = json['main_discount_price'];
    price = json['price'];
    discountPrice = json['discount_price'];
    discountType = json['discount_type'];
    quantity = json['quantity'];
    productThumbnail = json['product_thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['unit'] = unit;
    data['main_price'] = mainPrice;
    data['main_discount_price'] = mainDiscountPrice;
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['discount_type'] = discountType;
    data['quantity'] = quantity;
    data['product_thumbnail'] = productThumbnail;
    return data;
  }
}
