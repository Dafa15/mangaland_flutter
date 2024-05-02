import 'package:mangaland_flutter/model/author.dart';
import 'package:mangaland_flutter/model/cover_art.dart';
import 'package:mangaland_flutter/model/tag.dart';

class ParseData {
  static CoverArt? coverArtFromRelationship(dynamic relationData) {
    return relationData['attributes'] == null
        ? null
        : CoverArt(
            id: relationData['id'],
            filename: relationData['attributes']['fileName'],
            description: relationData['attributes']['description'],
            volume: relationData['attributes']['volume']);
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
