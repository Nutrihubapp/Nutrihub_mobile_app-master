class PriceRange {
  int? highestPrice;
  String? activeCurrency;
  int? lowestPrice;
  String? message;

  PriceRange(
      {this.highestPrice, this.activeCurrency, this.lowestPrice, this.message});

  PriceRange.fromJson(Map<String, dynamic> json) {
    highestPrice = json['highest_price'];
    activeCurrency = json['active_currency'];
    lowestPrice = json['lowest_price'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['highest_price'] = highestPrice;
    data['active_currency'] = activeCurrency;
    data['lowest_price'] = lowestPrice;
    data['message'] = message;
    return data;
  }
}
