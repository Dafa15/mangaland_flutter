import 'package:dio/dio.dart';
import 'package:mangaland_flutter/model/author.dart';
import 'package:mangaland_flutter/model/cover_art.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/service/home_service.dart';
import 'package:mangaland_flutter/service/parse_data.dart';
import 'package:mangaland_flutter/utils/base_url.dart';
import 'package:mangaland_flutter/utils/shared_pref.dart';

class FollowService {
  static Dio dio = Dio();

  static Future<List<Manga>> getFollowedManga(int offset) async {
    List<Manga> listManga = [];
      final token = await SharedPref.getToken();
      Map<String, dynamic> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', 
      };
      final response = await dio.get("${BaseUrl.baseUrl}/user/follows/manga",
          options: Options(headers: headers),
          queryParameters: {
            'limit': 10,
            'includes[]': ['cover_art', 'author', 'tag'],
            'offset': offset
          });

      final resultData = response.data['data'];

      for (var mangaData in resultData) {
        Manga? manga;
        Author? authorManga;
        CoverArt? coverArtManga;
        for (var relation in mangaData['relationships']) {
          switch (relation['type']) {
            case "author":
              authorManga = ParseData.authorFromRelationship(relation);
              break;
            case "cover_art":
              coverArtManga = ParseData.coverArtFromRelationship(relation);
              break;
          }
        }

        final mangaStatistics =
            await HomeService.getMangaStatistic(mangaData['id']);
        final mangaTag = ParseData.mangaTag(mangaData['attributes']['tags']);

        manga = Manga(
            coverArt: coverArtManga,
            author: authorManga,
            statistics: mangaStatistics,
            id: mangaData['id'],
            title: mangaData['attributes']['title']['en'].toString(),
            description:
                mangaData['attributes']['description']['en'].toString(),
            status: mangaData['attributes']['status'].toString(),
            year: mangaData['attributes']['year'],
            tags: mangaTag);
        listManga.add(manga);
      }
      return listManga;
  }
}
