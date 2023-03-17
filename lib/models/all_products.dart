class AllProducts {
  List<Products>? products;
  String? pageNumber;
  String? message;
  int? status;
  bool? validity;

  AllProducts(
      {this.products,
      this.pageNumber,
      this.message,
      this.status,
      this.validity});

  AllProducts.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    // pageNumber = json['page_number'];
    // message = json['message'];
    // status = json['status'];
    // validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['page_number'] = pageNumber;
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
  String? discount;
  String? price;
  String? discountPrice;
  String? currency;
  String? currencyPosition;
  String? unit;
  String? thumbnail;
  int? isWishlist;
  int? isCart;
  String? outOfStock;

  Products(
      {this.productId,
      this.categoryId,
      this.outOfStock,
      this.name,
      this.discount,
      this.price,
      this.discountPrice,
      this.currency,
      this.currencyPosition,
      this.unit,
      this.thumbnail,
      this.isWishlist,
      this.isCart});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    categoryId = json['category_id'];
    name = json['name'];
    outOfStock = json['outofstock'];
    discount = json['discount'];
    price = json['price'];
    discountPrice = json['discount_price'];
    currency = json['currency'];
    currencyPosition = json['currency_position'];
    unit = json['unit'];
    thumbnail = json['thumbnail'];
    isWishlist = json['is_wishlist'];
    isCart = json['is_cart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['discount'] = discount;
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['currency'] = currency;
    data['currency_position'] = currencyPosition;
    data['unit'] = unit;
    data['thumbnail'] = thumbnail;
    data['is_wishlist'] = isWishlist;
    data['is_cart'] = isCart;
    return data;
  }
}
