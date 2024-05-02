import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mangaland_flutter/model/login_response.dart';
import 'package:mangaland_flutter/utils/base_url.dart';
import 'package:mangaland_flutter/utils/client.dart';
import 'package:mangaland_flutter/utils/shared_pref.dart';

class LoginService {
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
      debugPrint("$data");
      final response = await dio.post(BaseUrl.loginUrl,
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          }));
          

      if (response.statusCode == 200) {
        final convertFromJson = jsonEncode(response.data);
        final loginResponse = loginResponseFromJson(convertFromJson);
        SharedPref.saveToken(token: loginResponse.accessToken);
        SharedPref.saveName(name: userName);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
