import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mangaland_flutter/model/chapter.dart';
import 'package:mangaland_flutter/model/chapter_data.dart';
import 'package:mangaland_flutter/utils/base_url.dart';

class ChapterService {
  static Dio dio = Dio();

  static Future<Chapter> getChapter({required String chapterId}) async {
    Chapter? chapter;
    try {
      final response = await dio.get("${BaseUrl.baseUrl}/chapter/$chapterId");

      final responseData = response.data['data'];

      String publishAt = responseData['attributes']['publishAt'];
      DateTime dateTime = DateTime.parse(publishAt);
      String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);

      chapter = Chapter(
          id: responseData['id'],
          volume: responseData['attributes']['volume'],
          chapter: responseData['attributes']['chapter'],
          title: responseData['attributes']['title'],
          pages: responseData['attributes']['pages'],
          publishAt: formattedDate,
          version: responseData['attributes']['version']);

      return chapter;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<ChapterData> getChapterData({required String chapterId}) async {
    List<String> imgList = [];
    ChapterData? chapterData;
    try {
      final response =
          await dio.get("${BaseUrl.baseUrl}/at-home/server/$chapterId");
      final responseData = response.data['chapter'];
      final chapterImgs = response.data['chapter']['dataSaver'];
      for (var img in chapterImgs) {
        imgList.add(img);
      }
      Chapter chapter = await getChapter(chapterId: chapterId);
      chapterData = ChapterData(
          chapter: chapter, hash: responseData['hash'], data: imgList);

      return chapterData;
    } catch (e) {
      throw Exception(e);
    }
  }

  static String getImageUrl({required String hash, required String fileName}) {
    return "https://uploads.mangadex.org/data-saver/$hash/$fileName";
  }
}
