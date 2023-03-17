import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  Future<bool> setAuthToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userPref.AuthToken.toString(), token);
  }

  Future<String?> getAuthToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userPref.AuthToken.toString());
  }
}

enum userPref {
  // ignore: constant_identifier_names
  AuthToken,
}
