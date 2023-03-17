class CartProduct {
  final int? id;
  final String productId;
  final String name;
  final dynamic discountPrice;
  final dynamic mainPrice, normalPrice;
  final String currency;
  final String currencyPosition;
  final String thumbnail;
  final String unit;
  final String? shopId;
  final int quantity;


  CartProduct(
      {this.id,
      this.shopId,
      required this.productId,
      required this.name,
      required this.discountPrice,
      required this.mainPrice,
      required this.currency,
      required this.currencyPosition,this.normalPrice,
      required this.thumbnail,
      required this.unit,
      required this.quantity});

  factory CartProduct.fromMap(Map<String, dynamic> json) => CartProduct(
        id: json['id'],
        shopId: json['shopId'],
        productId: json['productId'],
        normalPrice:json['normalPrice'],
        name: json['name'],
        discountPrice: json['discountPrice'],
        mainPrice: json['mainPrice'],
        currency: json['currency'],
        currencyPosition: json['currencyPosition'],
        thumbnail: json['thumbnail'],
        unit: json['unit'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'normalPrice':normalPrice,
      'id': id,
      'product_id': productId,
      'name': name,
      'discount_price': discountPrice,
      'main_price': mainPrice,
      'currency': currency,
      'currency_position': currencyPosition,
      'thumbnail': thumbnail,
      'unit': unit,
      'quantity': quantity,
    };
  }
}
