import 'package:shared_preferences/shared_preferences.dart';

String _keyToken = 'token';
String _keyName = 'name';

class SharedPref {
  static void saveToken({required String token}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString(_keyToken, token);
  }

  static void saveName({required String name}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString(_keyName, name);
  }

  static Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString(_keyToken);

    return token;
  }

  static Future<String?> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? name = preferences.getString(_keyName);

    return name;
  }
}
