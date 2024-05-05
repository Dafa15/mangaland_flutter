import 'package:flutter/cupertino.dart';
import 'package:mangaland_flutter/model/chapter.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/service/detail_service.dart';

class DetailViewModel extends ChangeNotifier {
  List<Chapter> listChapter = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getChapterList({required String id}) async {
    try {
      _isLoading = true;
      listChapter = await DetailService.getChapterList(mangaId: id);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getCoverUrl({required String idCover, required String fileNameCover}) {
    final coverUrl = DetailService.getCover(idCover, fileNameCover);
    return coverUrl;
  }

  Future<Manga> getMangaData({required String id}) async {
    try {
      _isLoading = true;
      final manga = await DetailService.getMangaDetail(id: id);
      notifyListeners();
      return manga;
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}