import 'package:flutter/material.dart';
import 'package:mangaland_flutter/service/login_service.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<bool> postLogin(
      {required String userName, required String password}) async {
    try {
      _isLoading = true;
      final result =
          await LoginService.postLogin(userName: userName, password: password);
      debugPrint("ini Login provider $result");
      return result;
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}