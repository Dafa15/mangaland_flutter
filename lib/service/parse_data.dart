import 'package:dio/dio.dart';
import 'package:mangaland_flutter/model/author.dart';
import 'package:mangaland_flutter/model/cover_art.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/model/tag.dart';
import 'package:mangaland_flutter/service/home_service.dart';

class ParseData {
  static Dio dio = Dio();
  static CoverArt? coverArtFromRelationship(dynamic relationData) {
    return relationData['attributes'] == null
        ? null
        : CoverArt(
            id: relationData['id'],
            filename: relationData['attributes']['fileName'],
            description: relationData['attributes']['description'],
            volume: relationData['attributes']['volume']);
  }

  static Future<List<Manga>> parseListManga(dynamic list) async {
    List<Manga> listManga = [];
    try {
      for (var mangaData in list) {
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
    } catch (e) {
      throw Exception(e);
    }
  }

  static Author? authorFromRelationship(dynamic relationData) {
    return relationData['attributes'] == null
        ? null
        : Author(
            id: relationData['id'], name: relationData['attributes']['name']);
  }

  static List<Tag> mangaTag(dynamic tagsData) {
    List<Tag> tags = [];

    for (var tag in tagsData) {
      var tagItem = Tag(
          id: tag['id'],
          group: tag['attributes']['group'],
          name: tag['attributes']['name']['en'],
          version: tag['attributes']['version']);
      tags.add(tagItem);
    }

    return tags;
  }
}
