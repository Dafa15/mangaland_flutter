import 'package:flutter/material.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/service/search_service.dart';

class SearchViewModel extends ChangeNotifier {
  List<Manga> listManga = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getSearchList(String query) async {
    try {
      _isLoading = true;
      notifyListeners();
      listManga = await SearchService.getSearchManga(query);
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void deleteList() {
    listManga = [];
  }
}
