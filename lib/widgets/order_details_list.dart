import 'package:flutter/material.dart';

class OrderDetailsList extends StatelessWidget {
  final String? productId;
  final String? categoryId;
  final String? name;
  final String? price;
  final String? discountPrice;
  final String? discount;
  final String? unit;
  final String? thumbnail;
  final String? itemQuantity;

  const OrderDetailsList(
      {Key? key,
      this.productId,
      this.categoryId,
      this.name,
      this.price,
      this.discountPrice,
      this.discount,
      this.unit,
      this.thumbnail,
      this.itemQuantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.center,
      children: [
        Column(
          children: <Widget>[
            Row(
              children: [
                thumbnail!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/loading_animated.gif',
                          image: thumbnail.toString(),
                          height: 70,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'image-not-found.png',
                            height: 70,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.toString(),
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          unit.toString(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black45,
                          ),
                        ),
                        Text(
                          discountPrice.toString(),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            discountPrice.toString(),
                            style: const TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Quantity: " + itemQuantity.toString(),
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
