import 'package:flutter/material.dart';
import 'package:mangaland_flutter/service/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  Future<bool> postLogin(
      {required String userName, required String password}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final result =
          await AuthService.postLogin(userName: userName, password: password);
      return result;
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
