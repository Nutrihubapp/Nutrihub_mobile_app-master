import 'package:checkout_app/screens/sub_category_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../constants.dart';

class CategoryListItemVertical extends StatelessWidget {
  final String? categoryId;
  final String? parentId;
  final String? title;
  final String? thumbnail;
  final Color? backgroundColor;

  const CategoryListItemVertical(
      {Key? key,
      this.categoryId,
      this.parentId,
      this.title,
      this.thumbnail,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen:
              SubCategoryAndProductScreen(categoryId: categoryId, title: title),
          withNavBar: false,
        );
      },
      child: Card(
        elevation: 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 4.0, left: 8.0, right: 8.0),
              child: thumbnail!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/loading_animated.gif',
                        image: BASE_URL +
                            "/uploads/category/" +
                            thumbnail.toString(),
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          'image-not-found.png',
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              // child: CircleAvatar(
              //   radius: 50,
              //   backgroundImage: NetworkImage(thumbnail),
              //   backgroundColor: Colors.grey,
              // ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 4.0, bottom: 8.0, right: 4.0, top: 4.0),
                child: Text(
                  title.toString(),
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
