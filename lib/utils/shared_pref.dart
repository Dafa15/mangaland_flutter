import 'package:shared_preferences/shared_preferences.dart';

String _keyToken = 'token';
String _keyRefreshToken = 'refresh_token';

class SharedPref {
  static void saveToken({required String token}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString(_keyToken, token);
  }
  static void saveRefreshToken({required String token}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString(_keyRefreshToken, token);
  }

  static Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString(_keyToken);

    return token;
  }

  static Future<String?> getRefreshToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString(_keyRefreshToken);

    return token;
  }

  static void removeAllKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
