import 'package:flutter/cupertino.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/service/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  List<Manga> recentManga = [];
  List<Manga> popularManga = [];
  List<Manga> completedManga = [];

  void getPopularList() async {
    popularManga = await HomeService.getPopularManga();
    notifyListeners();
  }

  void getRecentList() async {
    recentManga = await HomeService.getRecentListManga();
    notifyListeners();
  }

  void getCompletedManga() async {
    completedManga = await HomeService.getCompletedManga();
    notifyListeners();
  }

  String getCoverUrl(String idCover, String fileNameCover) {
    final coverUrl = HomeService.getCover(idCover, fileNameCover);
    notifyListeners();
    return coverUrl;
  }
}
