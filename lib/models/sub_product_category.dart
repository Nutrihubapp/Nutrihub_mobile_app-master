class SubProductCategory {
  List<SubCategories>? subCategories;
  List<ProductsByCategory>? productsByCategory;
  String? message;
  int? status;
  bool? validity;

  SubProductCategory(
      {this.subCategories,
      this.productsByCategory,
      this.message,
      this.status,
      this.validity});

  SubProductCategory.fromJson(Map<String, dynamic> json) {
    if (json['sub_categories'] != null) {
      subCategories = <SubCategories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(SubCategories.fromJson(v));
      });
    }
    if (json['products_by_category'] != null) {
      productsByCategory = <ProductsByCategory>[];
      json['products_by_category'].forEach((v) {
        productsByCategory!.add(ProductsByCategory.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    if (productsByCategory != null) {
      data['products_by_category'] =
          productsByCategory!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}

class SubCategories {
  String? categoryId;
  String? title;
  String? parentId;
  String? thumbnail;
  String? categoryType;
  String? top;
  String? status;

  SubCategories(
      {this.categoryId,
      this.title,
      this.parentId,
      this.thumbnail,
      this.categoryType,
      this.top,
      this.status});

  SubCategories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    title = json['title'];
    parentId = json['parent_id'];
    thumbnail = json['thumbnail'];
    categoryType = json['category_type'];
    top = json['top'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['title'] = title;
    data['parent_id'] = parentId;
    data['thumbnail'] = thumbnail;
    data['category_type'] = categoryType;
    data['top'] = top;
    data['status'] = status;
    return data;
  }
}

class ProductsByCategory {
  String? productId;
  String? categoryId;
  String? name;
  String? price;
  String? discountPrice;
  String? discount;
  String? currency;
  String? currencyPosition;
  String? unit;
  String? outOfStock;
  String? thumbnail;
  int? isWishlist;
  int? isCart;

  ProductsByCategory(
      {this.productId,
      this.categoryId,
      this.name,
      this.outOfStock,
      this.price,
      this.discountPrice,
      this.currency,
      this.currencyPosition,
      this.discount,
      this.unit,
      this.thumbnail,
      this.isWishlist,
      this.isCart});

  ProductsByCategory.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    categoryId = json['category_id'];
    outOfStock = json['outofstock'];
    name = json['name'];
    price = json['price'];
    discountPrice = json['discount_price'];
    currency = json['currency'];
    currencyPosition = json['currency_position'];
    discount = json['discount'];
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
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['currency'] = currency;
    data['currency_position'] = currencyPosition;
    data['discount'] = discount;
    data['unit'] = unit;
    data['thumbnail'] = thumbnail;
    data['is_wishlist'] = isWishlist;
    data['is_cart'] = isCart;
    return data;
  }
}
