import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mangaland_flutter/model/author.dart';
import 'package:mangaland_flutter/model/chapter.dart';
import 'package:mangaland_flutter/model/cover_art.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/model/statistik_response.dart';
import 'package:mangaland_flutter/service/parse_data.dart';
import 'package:mangaland_flutter/utils/base_url.dart';

class DetailService {
  static Dio dio = Dio();

  static Future<List<Chapter>> getChapterList({required String mangaId}) async {
    List<Chapter> listChapter = [];
    try {
      final response =
          await dio.get("${BaseUrl.baseUrl}/chapter", queryParameters: {
        'limit': 100,
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
        debugPrint("apakah disini ${data['attributes']['translatedLanguage']}");
        if (data['attributes']['translatedLanguage'] == 'en' ||
            data['attributes']['translatedLanguage'] == 'jp') {
          chapter = Chapter(
              id: data['id'],
              volume: data['attributes']['volume'],
              chapter: data['attributes']['chapter'],
              title: data['attributes']['title'],
              pages: data['attributes']['pages'],
              publishAt: formattedDate,
              version: data['attributes']['version']);

          listChapter.add(chapter);
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

      final mangaStatistics = await getMangaStatistic(id);
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

  static Future<Statistics> getMangaStatistic(String id) async {
    try {
      final response = await dio.get('${BaseUrl.baseUrl}/statistics/manga',
          queryParameters: {'manga[]': id});
      final resultData = response.data['statistics'][id];
      Statistics statistics = Statistics(
        follows: resultData['follows'],
        rating: Rating(
          average: resultData['rating']['average'],
          bayesian: resultData['rating']['bayesian'],
        ),
      );

      return statistics;
    } catch (e) {
      throw Exception(e);
    }
  }

  static String getCover(String id, String fileName) {
    return "https://uploads.mangadex.org/covers/$id/$fileName";
  }
}
