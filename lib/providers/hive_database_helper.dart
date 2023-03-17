import 'package:checkout_app/constants.dart';
import 'package:checkout_app/providers/shared_pref_helper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class HiveDatabase {
  static Future checkForItem(var cartElementId) async {
    Box userBox = await Hive.openBox('user_info');
    Map userMapBox = await userBox.get('user_info');

    Box box1 = await Hive.openBox(userMapBox['email']);
    //  await box1.delete('cart');
    List cartItems = await box1.get(userMapBox['email']) ?? [];
    //  print(cartItems);
    if (cartItems.isEmpty) {
      return false;
    } else {
      for (var element in cartItems) {
        if (element['productId'] == cartElementId) {
          //   print(true);
          // CommonFunctions.showSuccessToast('Item already added');
          return true;
        } else {
          //  print(false);

          return false;
        }
      }
    }
  }

  static Future getAllCartItems() async {
    Box userBox = await Hive.openBox('user_info');
    Map userMapBox = await userBox.get('user_info');
    if (userMapBox != null) {
      Box box1 = await Hive.openBox(userMapBox['email']);

      List cartItems = await box1.get(userMapBox['email']) ?? [];
      //print(cartItems);
      return cartItems;
    }
  }

  static Future updateQuantity(cartQuantity, productId) async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    //print(authToken);
    var url = BASE_URL +
        "api_frontend/modify_cart_items?product_id=$productId&quantity=$cartQuantity&auth_token=$authToken";
    final result = await http.get(Uri.parse(url));
    print(result.body);
  }

  static addItemToCart(Map item, productId, mainPrice,) async {
    Box userBox = await Hive.openBox('user_info');
    Map userMapBox = await userBox.get('user_info');
    Box box1 = await Hive.openBox(userMapBox['email']);
    List oldItems = await box1.get(userMapBox['email']) ?? [];
   // int price = 0;
    final check =
        oldItems.where((element) => element['productId'] == item['productId']);
    if (check.isEmpty) {
      oldItems.add(item);
     // price = item['mainPrice'];
      await box1.put(userMapBox['email'], oldItems);
      //CommonFunctions.showSuccessToast('Item has been added');
    } else {
      oldItems.forEach((e) async {
        if (e['productId'] == item['productId']) {
          print(e['mainPrice']);
          await updateQuantity(e['quantity'] + 1, item['productId']);
          e['quantity']++;

          e['mainPrice'] =double.parse(mainPrice.toString()) + double.parse(e['mainPrice'].toString());

          print(e['mainPrice']);
        }
      });
      // CommonFunctions.showSuccessToast('Item already added');
    }
  }

  static deleteItems(index) async {
    Box userBox = await Hive.openBox('user_info');
    Map userMapBox = await userBox.get('user_info');
    Box box1 = await Hive.openBox(userMapBox['email']);
    List cartItems = await box1.get(userMapBox['email']);
    cartItems.removeAt(index);
    print(cartItems.length);
    await box1.put(userMapBox['email'], cartItems);
  }

  static updateCartItems(id, int? quantity, dynamic price) async {
    Box userBox = await Hive.openBox('user_info');
    Map userMapBox = await userBox.get('user_info');
    Box box1 = await Hive.openBox(userMapBox['email']);
    List cartItems = await box1.get(userMapBox['email']);
    cartItems.forEach((element) {
      if(element['productId'] == id){
        element['quantity'] = quantity;
        element['mainPrice'] = price;
      }
    } );
    for (var element in cartItems) {
      // if (element['productId'] == id) {
       
      // }
    }
  }

  static clearCart() async {
    Box userBox = await Hive.openBox('user_info');
    Map userMapBox = await userBox.get('user_info');
    Box box1 = await Hive.openBox(userMapBox['email']);
    List cartItems = await box1.get(userMapBox['email']);
    await box1.put(userMapBox['email'], []);
  }
}
