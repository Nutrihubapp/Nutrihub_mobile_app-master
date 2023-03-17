class ProductDetail {
  String? productId;
  String? name;
  String? category;
  String? categoryId;
  String? unit;
  String? price;
  String? discount;
  String? discountPrice;
  bool? discountType;
  int? isWishlist;
  int? isCart;
  List? thumbnail;
  String? outOfStock;
  String? currency;
  String? currencyPosition;
  String? description;

  ProductDetail(
      {this.productId,
        this.name,
        this.category,
        this.categoryId,
        this.outOfStock,
        this.unit,
        this.price,
        this.discount,
        this.discountPrice,
        this.discountType,
        this.isWishlist,
        this.isCart,
        this.thumbnail,
        this.currency,
        this.description,
        this.currencyPosition});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    outOfStock = json['outofstock'];
    name = json['name'];
    category = json['category'];
    categoryId = json['category_id'];
    unit = json['unit'];
    description = json['description'];
    price = json['price'];
    discount = json['discount'];
    discountPrice = json['discount_price'];
    discountType = json['discount_type'];
    isWishlist = json['is_wishlist'];
    isCart = json['is_cart'];
    thumbnail = json['productimages'];
    currency = json['currency'];
    currencyPosition = json['currency_position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;

    data['name'] = name;
    data['category'] = category;
    data['category_id'] = categoryId;
    data['unit'] = unit;
    data['price'] = price;
    data['discount'] = discount;
    data['discount_price'] = discountPrice;
    data['discount_type'] = discountType;
    data['is_wishlist'] = isWishlist;
    data['is_cart'] = isCart;
    data['currency'] = thumbnail;
    data['currency_position'] = currencyPosition;
    return data;
  }
}
