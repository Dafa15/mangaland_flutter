import 'package:flutter/cupertino.dart';
import 'package:mangaland_flutter/model/chapter_data.dart';
import 'package:mangaland_flutter/service/chapter_service.dart';

class ChapterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<ChapterData> getChapterPages({required String id}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final chapterData = await ChapterService.getChapterData(chapterId: id);
      return chapterData;
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getImg({required String hash, required String fileName}) {
    final imgUrl = ChapterService.getImageUrl(hash: hash, fileName: fileName);
    return imgUrl;
  }
}
