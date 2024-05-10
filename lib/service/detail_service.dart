import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mangaland_flutter/model/author.dart';
import 'package:mangaland_flutter/model/chapter.dart';
import 'package:mangaland_flutter/model/cover_art.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/service/home_service.dart';
import 'package:mangaland_flutter/service/parse_data.dart';
import 'package:mangaland_flutter/utils/base_url.dart';
import 'package:mangaland_flutter/utils/shared_pref.dart';

class DetailService {
  static Dio dio = Dio();

  static Future<List<Chapter>> getChapterList(
      {required String mangaId, required int offSet}) async {
    List<Chapter> listChapter = [];
    String chapterNow = "-1";
    try {
      final response =
          await dio.get("${BaseUrl.baseUrl}/chapter", queryParameters: {
        'limit': 100,
        'offset': offSet,
        'contentRating[]': ['safe', 'suggestive', 'erotica'],
        'manga': mangaId,
        'order[chapter]': 'desc'
      });

      final responseData = response.data['data'];
      for (var data in responseData) {
        Chapter? chapter;

        String publishAt = data['attributes']['publishAt'];

        DateTime dateTime = DateTime.parse(publishAt);

        String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
        if (data['attributes']['chapter'] != chapterNow) {
          chapter = Chapter(
              id: data['id'],
              volume: data['attributes']['volume'],
              chapter: data['attributes']['chapter'],
              title: data['attributes']['title'],
              pages: data['attributes']['pages'],
              publishAt: formattedDate,
              version: data['attributes']['version']);

          listChapter.add(chapter);
          chapterNow = data['attributes']['chapter'];
        }
      }
      return listChapter;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Manga> getMangaDetail({required String id}) async {
    Manga? manga;
    Author? authorManga;
    CoverArt? coverArtManga;

    try {
      final responseManga =
          await dio.get("${BaseUrl.baseUrl}/manga/$id", queryParameters: {
        'includes[]': ['cover_art', 'author', 'tag']
      });

      final resultData = responseManga.data['data'];

      for (var relationType in resultData['relationships']) {
        switch (relationType['type']) {
          case "author":
            authorManga = ParseData.authorFromRelationship(relationType);
            break;
          case "cover_art":
            coverArtManga = ParseData.coverArtFromRelationship(relationType);
            break;
        }
      }

      final mangaStatistics = await HomeService.getMangaStatistic(id);
      final mangaTag = ParseData.mangaTag(resultData['attributes']['tags']);
      manga = Manga(
          coverArt: coverArtManga,
          author: authorManga,
          statistics: mangaStatistics,
          id: resultData['id'],
          title: resultData['attributes']['title']['en'],
          description: resultData['attributes']['description']['en'],
          status: resultData['attributes']['status'],
          year: resultData['attributes']['year'],
          tags: mangaTag);
    } catch (e) {
      throw Exception(e);
    }

    return manga;
  }

  static Future<String> postFollow(String id) async {
      final token = await SharedPref.getToken();
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final response = await dio.post("${BaseUrl.baseUrl}/manga/$id/follow",
          options: Options(headers: headers));
      final result = response.data['result'];
      return result;
  }

  static Future<String> checkFollow(String id) async {
      final token = await SharedPref.getToken();
      Map<String, dynamic> headers = {
        'Authorization':
            'Bearer $token',
        'Content-Type': 'application/json',
      };
      final response = await dio.get(
          "${BaseUrl.baseUrl}/user/follows/manga/$id",
          options: Options(headers: headers));
      final result = response.data['result'];
      return result;
  }

  static Future<String> deleteFollow(String id) async {
      final token = await SharedPref.getToken();
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Example header
      };
      final response = await dio.delete("${BaseUrl.baseUrl}/manga/$id/follow",
          options: Options(headers: headers));
      final result = response.data['result'];
      return result;
  }

  static String getCover(String id, String fileName) {
    return "https://uploads.mangadex.org/covers/$id/$fileName";
  }
}
