class Wishlist {
  List<WishlistItems>? wishlistItems;
  String? message;
  int? status;
  bool? validity;

  Wishlist({this.wishlistItems, this.message, this.status, this.validity});

  Wishlist.fromJson(Map<String, dynamic> json) {
    if (json['wishlist_items'] != null) {
      wishlistItems = <WishlistItems>[];
      json['wishlist_items'].forEach((v) {
        wishlistItems!.add(WishlistItems.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wishlistItems != null) {
      data['wishlist_items'] = wishlistItems!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}

class WishlistItems {
  String? productId;
  String? categoryId;
  String? name, outOfStock;
  String? price;
  String? discountPrice;
  String? currency;
  String? currencyPosition;
  String? discount;
  String? unit;
  String? thumbnail;

  WishlistItems(
      {this.productId,
      this.categoryId,
      this.name,
      this.price,
      this.discountPrice,
      this.currency,
      this.currencyPosition,
      this.discount,
      this.outOfStock,
      this.unit,
      this.thumbnail});

  WishlistItems.fromJson(Map<String, dynamic> json) {
    outOfStock = json['outofstock'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    name = json['name'];
    price = json['price'];
    discountPrice = json['discount_price'];
    currency = json['currency'];
    currencyPosition = json['currency_position'];
    discount = json['discount'];
    unit = json['unit'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['outofstock'] = outOfStock;
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['currency'] = currency;
    data['currencyPosition'] = currencyPosition;
    data['discount'] = discount;
    data['unit'] = unit;
    data['thumbnail'] = thumbnail;
    return data;
  }
}
