import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mangaland_flutter/model/login_response.dart';
import 'package:mangaland_flutter/utils/base_url.dart';
import 'package:mangaland_flutter/utils/client.dart';
import 'package:mangaland_flutter/utils/shared_pref.dart';

class AuthService {
  static Dio dio = Dio();

  static Future<bool> postLogin(
      {required String userName, required String password}) async {
    try {
      Map<String, dynamic> data = {
        'grant_type': 'password',
        'username': userName,
        'password': password,
        'client_id': ClientKey.clientId,
        'client_secret': ClientKey.clientSecretKey,
      };
      final response = await dio.post(BaseUrl.loginUrl,
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          }));

      if (response.statusCode == 200) {
        final convertFromJson = jsonEncode(response.data);
        final loginResponse = loginResponseFromJson(convertFromJson);
        SharedPref.saveToken(token: loginResponse.accessToken);
        SharedPref.saveRefreshToken(token: loginResponse.refreshToken);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> postRefreshToken() async {
    try {
      final refreshToken = await SharedPref.getRefreshToken();
      Map<String, dynamic> data = {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': ClientKey.clientId,
        'client_secret': ClientKey.clientSecretKey,
      };
      final response = await dio.post(BaseUrl.loginUrl,
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          }));

      if (response.statusCode == 200) {
        final convertFromJson = jsonEncode(response.data);
        final loginResponse = loginResponseFromJson(convertFromJson);
        SharedPref.saveToken(token: loginResponse.accessToken);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkToken(String userToken) async {
    try {
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json', // Example header
      };
      final response = await dio.get('https://api.mangadex.org/auth/check',
          options: Options(headers: headers));
      final bool result = response.data['isAuthenticated'];

      return result;
    } catch (e) {
      return false;
    }
  }
}
