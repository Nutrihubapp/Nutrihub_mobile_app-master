import 'dart:io';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/providers/fetch_data.dart';
import 'package:checkout_app/widgets/category_list_item_vertical.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kAppBarColor,
        leading:    Platform.isIOS? IconButton(icon:const Icon(Icons.arrow_back_ios,color:kBackgroundColor), onPressed:()=>Navigator.pop(context)) : IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              //    Provider.of<Auth>(context, listen: false).changeAppBar(true);
              Navigator.pop(context);
            }),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              'Categories',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future:
            Provider.of<FetchData>(context, listen: false).fetchCategories(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              //period:Duration(seconds:5),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 0.0),
                padding: const EdgeInsets.all(6),
                height: MediaQuery.of(context).size.height * 88 / 100,
                child: StaggeredGridView.countBuilder(
                    padding: const EdgeInsets.all(2.0),
                    shrinkWrap: true,
                    itemCount: 5,
                    crossAxisCount: 2,
                    staggeredTileBuilder: (int index) =>
                        const StaggeredTile.fit(1),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 5.0,
                    // physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // var thumbnail = base_api +
                      //     "/uploads/category/" +
                      //     category[index].thumbnail;
                      var unescape = HtmlUnescape();
                      // var title = unescape
                      //     .convert(category[index].title.toString());
                      return IgnorePointer(
                        child: const CategoryListItemVertical(
                          categoryId: '',
                          parentId: '',
                          title: '',
                          thumbnail: '',
                          backgroundColor: Colors.white,
                        ),
                      );
                    }),
              ),
            );
          } else {
            if (dataSnapshot.error != null) {
              //error
              return const Center(
                child: Text('Error Occured'),
              );
            } else {
              return Consumer<FetchData>(builder: (context, authData, child) {
                final category = authData.items;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                       // margin: const EdgeInsets.symmetric(vertical: 100.0),
                        padding: const EdgeInsets.all(6),
                        height: MediaQuery.of(context).size.height * 80 / 100,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: 230),
                          padding: const EdgeInsets.all(2.0),
                          shrinkWrap: true,
                          itemCount: category.length,
                        //  physics: const BouncingScrollPhysics(),
                       
                            // physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              // var thumbnail = base_api +
                              //     "/uploads/category/" +
                              //     category[index].thumbnail;
                              var unescape = HtmlUnescape();
                              var title = unescape
                                  .convert(category[index].title.toString());
                              return CategoryListItemVertical(
                                categoryId: category[index].categoryId,
                                parentId: category[index].parentId,
                                title: title,
                                thumbnail: category[index].thumbnail,
                                backgroundColor: Colors.white,
                              );
                            }),
                      ),  
                    ],
                  ),
                );
              });
            }
          }
        },
      ),
    );
  }
}
