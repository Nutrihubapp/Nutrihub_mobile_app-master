
import 'package:checkout_app/screens/sub_category_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


import '../constants.dart';

class CategoryListItem extends StatelessWidget {
  final String? categoryId;
  final String? parentId;
  final String? title;
  final String? thumbnail;
  final Color? backgroundColor;

  const CategoryListItem(
      {Key? key,
      this.categoryId,
      this.parentId,
      this.title,
      this.thumbnail,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     height: 200,
      width: 200,
      child: InkWell(
        onTap: () {
        
          pushNewScreen(
            context,
            screen: SubCategoryAndProductScreen(
              categoryId: categoryId,
              title: title,
            ),
            withNavBar: true,
          );
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return SubCategoryAndProductScreen(
          //     categoryId: categoryId,
          //     title: title,
          //   );
          // }));
        },
        child: Card(
          color: backgroundColor,
          elevation: 0.1,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: <Widget>[
                thumbnail!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/loading_animated.gif',
                            image: BASE_URL +
                                "uploads/category/optimized/" +
                                thumbnail.toString(),
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'image-not-found.png',
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      
                           title.toString(),
                        
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 13.0,

                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
