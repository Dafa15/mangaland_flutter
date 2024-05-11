import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mangaland_flutter/model/chapter.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/service/auth_service.dart';
import 'package:mangaland_flutter/service/detail_service.dart';

class DetailViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool follow = false;
  Manga? manga;

  Future<List<Chapter>> getChapterList(
      {required String id, required int offSet}) async {
    try {
      final listChapter =
          await DetailService.getChapterList(mangaId: id, offSet: offSet);
      notifyListeners();
      return listChapter;
    } catch (e) {
      throw Exception(e);
    }
  }

  void postFollowManga(String id) async {
    try {
      final result = await DetailService.postFollow(id);
      if (result == "ok") {
        follow = true;
        notifyListeners();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final response = await AuthService.postRefreshToken();
        if (response == true) {
          postFollowManga(id);
        }
      } else {
        throw Exception(e);
      }
    }
  }

  void deleteFollowManga(String id) async {
    try {
      final result = await DetailService.deleteFollow(id);
      if (result == "ok") {
        follow = false;
        notifyListeners();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final response = await AuthService.postRefreshToken();
        if (response == true) {
          deleteFollowManga(id);
        }
      } else {
        throw Exception(e);
      }
    }
  }

  void checkFollowManga(String id) async {
    follow = false;
    notifyListeners();
    try {
      final result = await DetailService.checkFollow(id);
      if (result == "ok") {
        follow = true;
        notifyListeners();
      } else {
        follow = false;
        notifyListeners();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final response = await AuthService.postRefreshToken();
        if (response == true) {
          checkFollowManga(id);
        }
      } else {
        throw Exception(e);
      }
    }
  }

  String getCoverUrl({required String idCover, required String fileNameCover}) {
    final coverUrl = DetailService.getCover(idCover, fileNameCover);
    return coverUrl;
  }

  Future<void> getMangaData({required String id}) async {
    manga = null;
    notifyListeners();
    try {
      checkFollowManga(id);
      manga = await DetailService.getMangaDetail(id: id);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }
}
