class Chapter {
  String id;
  String? volume;
  String? chapter;
  String? title;
  int pages;
  String publishAt;

  int version;

  Chapter({
    required this.id,
    required this.volume,
    required this.chapter,
    required this.title,
    required this.pages,
    required this.publishAt,
    required this.version,
  });
}
