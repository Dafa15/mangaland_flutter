import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class RecommendationViewModel extends ChangeNotifier {
  final gemini = Gemini.instance;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _result;
  String? get result => _result;

  void getRecommendation(String genre) async {
    _isLoading = true;
    notifyListeners();
    try {
      final value = await gemini.text(
          "Give me a list of manga recommendation with $genre genre with a little synopsis");
      _result = value?.output;
      notifyListeners();
    } catch (e) {
      throw ('streamGenerateContent exception', error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
