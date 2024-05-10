import 'package:flutter/cupertino.dart';
import 'package:mangaland_flutter/model/chapter_data.dart';
import 'package:mangaland_flutter/service/chapter_service.dart';

class ChapterViewModel extends ChangeNotifier {
  ChapterData? chapterData;

  Future<void> getChapterPages({required String id}) async {
    try {
      chapterData = null;
      chapterData = await ChapterService.getChapterData(chapterId: id);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  String getImg({required String hash, required String fileName}) {
    final imgUrl = ChapterService.getImageUrl(hash: hash, fileName: fileName);
    return imgUrl;
  }
}
