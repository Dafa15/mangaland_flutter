import 'package:mangaland_flutter/model/author.dart';
import 'package:mangaland_flutter/model/cover_art.dart';
import 'package:mangaland_flutter/model/statistik_response.dart';
import 'package:mangaland_flutter/model/tag.dart';

class Manga {
  final String id;
  final String title;
  final String? description;
  final String? status;
  final int? year;
  final List<Tag>? tags;
  final CoverArt? coverArt;
  final Author? author;
  final Statistics? statistics;

  Manga(
      {required this.coverArt,
      required this.author,
      required this.statistics,
      required this.id,
      required this.title,
      required this.description,
      required this.status,
      required this.year,
      required this.tags});
}
