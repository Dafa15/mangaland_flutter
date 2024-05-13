import 'package:dio/dio.dart';
import 'package:mangaland_flutter/model/author.dart';
import 'package:mangaland_flutter/model/cover_art.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/model/statistic.dart';
import 'package:mangaland_flutter/service/parse_data.dart';
import 'package:mangaland_flutter/utils/base_url.dart';

class HomeService {
  static Dio dio = Dio();

  static Future<Manga> getManga({required String id}) async {
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

  static Future<List<Manga>> getPopularManga() async {
    List<Manga> popularList = [];
    try {
      final responsePopularList = await dio
          .get("${BaseUrl.baseUrl}/list/79597a8b-4071-4bf0-91e0-3032730c106b");
      final listMangaResponse = responsePopularList.data['data'];

      for (var mangaData in listMangaResponse['relationships']) {
        if (mangaData['type'] == 'manga') {
          String idManga = mangaData['id'];
          final mangaResponse = await getManga(id: idManga);

          popularList.add(mangaResponse);
        }
      }

      return popularList;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Manga>> getRecentListManga(int offset) async {
    try {
      final response =
          await dio.get("${BaseUrl.baseUrl}/manga", queryParameters: {
        'contentRating[]': 'safe',
        'limit': 10,
        'offset': offset,
        'includes[]': ['cover_art', 'author', 'tag']
      });
      final resultData = response.data['data'];

      final listManga = ParseData.parseListManga(resultData);

      return listManga;
    } catch (e) {
      throw Exception(e);
    }
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

  static Future<List<Manga>> getCompletedManga(int offset) async {
    try {
      final response =
          await dio.get("${BaseUrl.baseUrl}/manga", queryParameters: {
        'contentRating[]': 'safe',
        'limit': 10,
        'offset': offset,
        'includes[]': ['cover_art', 'author', 'tag'],
        'status[]': 'completed'
      });
      final resultData = response.data['data'];

      final completedManga = ParseData.parseListManga(resultData);

      return completedManga;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Manga>> getOnGoingManga(int offset) async {
    try {
      final response =
          await dio.get("${BaseUrl.baseUrl}/manga", queryParameters: {
        'contentRating[]': 'safe',
        'limit': 10,
        'offset': offset,
        'includes[]': ['cover_art', 'author', 'tag'],
        'status[]': 'ongoing'
      });
      final resultData = response.data['data'];

      final onGoingManga = ParseData.parseListManga(resultData);

      return onGoingManga;
    } catch (e) {
      throw Exception(e);
    }
  }

  static String getCover(String id, String fileName) {
    return "https://uploads.mangadex.org/covers/$id/$fileName";
  }
}
