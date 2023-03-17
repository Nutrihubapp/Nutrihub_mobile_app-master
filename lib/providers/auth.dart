import 'dart:convert';
import 'dart:io';

import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/update_user_model.dart';
import 'package:checkout_app/models/user.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_pref_helper.dart';

class Auth with ChangeNotifier {
  String updatedName = "";
  String updatedImageUrl = "";
  bool showAppBar = true;
  void changeAppBar(bool val) {
    showAppBar = val;
    notifyListeners();
  }

  final PersistentTabController controller =
      PersistentTabController(initialIndex: 0);

  String? _token;
  String? _name;
  String? _email;
  String? _photo;
  User _user = User();

  bool load = false;
  String successfulMessage = "";
  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  User get user {
    return _user;
  }

  String usersDefaultAddress = '';
  Future<void> loginUser(String email, String password) async {
    const String apiUrl = BASE_URL + "api_frontend/login";

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'email': email.trim(),
        'password': password.trim(),
      });

      final responseData = json.decode(response.body);

      // print(responseData);

      if (responseData['validity'] == false) {
        throw const HttpException('Auth Failed');
      }

      _token = responseData['token'];
      _name = responseData['name'];
      _email = responseData['email'];
      _photo = responseData['photo'];

      final loadedUser = User(
        name: responseData['name'],
        email: responseData['email'],
        phone: responseData['phone'],
        address: responseData['address'],
        about: responseData['about'],
      );

      updatedImageUrl = responseData['photo'];
      usersDefaultAddress = responseData['address'];
      Box box1 = await Hive.openBox('user_info');
      await box1.put('user_info', {
        'mobile': responseData['phone'],
        'name': responseData['name'],
        'id': responseData['user_id'],
        'email': responseData['email'],
        'addres': responseData['address'],
      });

      _user = loadedUser;
      // print(_user.firstName);
      notifyListeners();

      _token = responseData['token'];
      notifyListeners();

      await SharedPreferenceHelper().setAuthToken(token!);

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'user': jsonEncode(_user),
      });
      await prefs.setString('userData', userData);
      await prefs.setString('token', _token!);
      await prefs.setString('name', _name!);
      await prefs.setString('email', _email!);
      await prefs.setString('photo', _photo!);
    } catch (error) {
      rethrow;
    }
  }

  dynamic count = 0;
  void changeCount(length) {
    count = length;
    notifyListeners();
  }

  void resetCount() {
    count = 0;
    notifyListeners();
  }

  dynamic userData;
  dynamic response;
  String? userToken;

  getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();

    userData = (prefs.getString('userData') ?? '');

    if (userData != null && userData.isNotEmpty) {
      response = json.decode(userData);
      userToken = response['token'];
    }
    notifyListeners();
  }

  Future<void> getUserInfo() async {
    var authToken = await SharedPreferenceHelper().getAuthToken();

    var url = BASE_URL + 'api_frontend/userdata?auth_token=$authToken';
    try {
      if (authToken == null) {
        throw const HttpException('No Auth User');
      }
      final prefs = await SharedPreferences.getInstance();

      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      await prefs.setString('updateImage', responseData['photo']);
      await prefs.setString('name', responseData['name']);
      updatedImageUrl = responseData['photo'];
      _user.photo = responseData['photo'];
      _user.name = responseData['name'];
      _user.phone = responseData['phone'];
      _user.address = responseData['address'];
      _user.email = responseData['email'];
      _user.about = responseData['about'];
      _user.userId = responseData['user_id'];
      usersDefaultAddress = responseData['address'];

      notifyListeners();
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  bool fromCheckout = false;
  changeFromCheckout(bool val) {
    fromCheckout = val;
    notifyListeners();
  }

  String userName = "";
  String userMobile = "";
  String id = "";
  List storedUsersAddress = [];
  List usersAddress = [];
  Future<void> getUserAddress() async {
    Box box1 = await Hive.openBox('address');
    Box box2 = await Hive.openBox('user_info');
    Map userInfoMap = await box2.get('user_info');
    id = user.userId ?? userInfoMap['id'];
    userName = userInfoMap['name'];
    userMobile = userInfoMap['mobile'];

    var url =
        "https://greenersapp.com/greenersapp/api_frontend/address?userid=${userInfoMap['id']}";
    try {
      usersAddress.clear();
      final response = await http.get(Uri.parse(url),
          headers: {'Content-type': ' application/json', 'Charset': 'utf-8'});
      if (response.statusCode == 200) {
        var parseJson = parse(response.body);
        List decodedAddress = jsonDecode(parseJson.body!.innerHtml);

        Map addresEntry = {};
        for (var element in decodedAddress) {
          DeepCollectionEquality dc = DeepCollectionEquality();
          if (usersAddress.length != decodedAddress.length) {
            addresEntry['street'] = element['street'];
            addresEntry['floor'] = element['floor'];
            addresEntry['remark'] = element['remark'];
            addresEntry['building'] = element['building'];
            addresEntry['postcode'] = element['postcode'];
            addresEntry['default'] = false;
            addresEntry['id'] = element['id'];
            addresEntry['fullname'] = element['fullname'] ?? '';

            usersAddress.add(addresEntry);
            addresEntry = {};
          } else {}
        }
        print(usersAddress.length);
        await box1.put('address', usersAddress);

        storedUsersAddress = await box1.get('address');
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> addUserAddress(
      {required String userid,
      street,
      building,
      floor,
      remark,
      name,
      postcode}) async {
    Box box1 = await Hive.openBox('user_info');
    final userName = await box1.get('user_info');
    print(
      userName['name'],
    );
    load = true;
    var url = "https://greenersapp.com/greenersapp/api_frontend/add_address";
    try {
      final response = await http.post(Uri.parse(url), body: {
        'userid': userid,
        'fullname': name,
        'street': street,
        'building': building,
        'floor': floor,
        'remark': remark,
        'postcode': postcode
      }, headers: {
        //  'Content-type': ' application/json',
        'Charset': 'utf-8',
      });
      if (response.statusCode == 200) {
        var parseJson = parse(response.body);
        print(parseJson);
        var decodedAddress = jsonDecode(parseJson.body!.innerHtml);
        print(decodedAddress);
        successfulMessage = decodedAddress['message'];
      }
      load = false;
      notifyListeners();
      return successfulMessage;
    } on SocketException {
      load = false;
      return 'no internet';
    } catch (error) {
      load = false;

      return error.toString();
    }
  }

  updateDefault(index) {
    for (var items in storedUsersAddress) {
      if (items['default'] == true) {
        items['default'] = false;
      }
    }
    storedUsersAddress[index]['default'] = true;
    for (var element in storedUsersAddress) {
      if (element['default'] == true) {
        usersDefaultAddress = '${element['postcode']}';
        updatedName = storedUsersAddress[index]['fullname'];
      }
    }
    notifyListeners();
  }

  Future<String> updateUserAddress(
      {required String userid,
      id,
      street,
      building,
      floor,
      remark,
      postcode,
      name,
      required int index,
      bool? defaultValue}) async {
    print(name);
    load = true;
    var url = "https://greenersapp.com/greenersapp/api_frontend/update_address";
    try {
      final response = await http.post(Uri.parse(url), body: {
        'userid': userid,
        'street': street,
        'building': building,
        'floor': floor,
        'remark': remark,
        'postcode': postcode,
        'fullname': name,
        'id': id,
      }, headers: {
        //  'Content-type': ' application/json',
        'Charset': 'utf-8',
      });
      if (response.statusCode == 200) {
        var parseJson = parse(response.body);

        var decodedAddress = jsonDecode(parseJson.body!.innerHtml);

        successfulMessage = decodedAddress['message'];

        notifyListeners();
        getUserAddress();
      }
      load = false;
      notifyListeners();
      return successfulMessage;
    } on SocketException {
      load = false;
      return 'no internet';
    } catch (error) {
      load = false;
      print(error.toString());
      return error.toString();
    }
  }

  Future<void> logout() async {
    userToken = null;
    _token = null;
    // _user = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  Future<UpdateUserModel?> UpdateUser(
      String name, String phone, String address, String authToken) async {
    String apiUrl = BASE_URL + "api_frontend/update_userdata";

    load = true;

    final response = await http.post(Uri.parse(apiUrl), body: {
      'name': name,
      'phone': phone,
      'address': address,
      'auth_token': authToken,
    });

    if (response.statusCode == 201) {
      final String responseString = response.body;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);

      load = false;
      notifyListeners();
      return updateUserModelFromJson(responseString);
    } else {
      notifyListeners();
      load = false;

      return null;
    }
  }
}
