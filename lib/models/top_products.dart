class TopProducts {
  String? productId;
  String? categoryId;
  String? name;
  String? outOfStock;
  String? discount;
  String? price;
  String? discountPrice;
  String? currency;
  String? currencyPosition;
  String? unit;
  String? thumbnail;
  int? isWishlist;
  int? isCart;

  TopProducts(
      {this.productId,
      this.categoryId,
      this.name,
      this.outOfStock,
      this.discount,
      this.price,
      this.discountPrice,
      this.currency,
      this.currencyPosition,
      this.unit,
      this.thumbnail,
      this.isWishlist,
      this.isCart});
}
