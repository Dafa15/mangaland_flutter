import 'package:flutter/cupertino.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/service/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  List<Manga> recentManga = [];
  List<Manga> popularManga = [];
  List<Manga> completedManga = [];
  List<Manga> onGoingManga = [];

  Future<void> getAllList() async {
    popularManga = await HomeService.getPopularManga();
    recentManga = await HomeService.getRecentListManga(0);
    completedManga = await HomeService.getCompletedManga(0);
    onGoingManga = await HomeService.getOnGoingManga(0);
    notifyListeners();
  }

  String getCoverUrl({required String idCover, required String fileNameCover}) {
    final coverUrl = HomeService.getCover(idCover, fileNameCover);
    return coverUrl;
  }
}
