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

  @override
  String toString() {
    return 'Chapter{id: $id, volume: $volume, chapter: $chapter, title: $title, pages: $pages, publishAt: $publishAt, version: $version}';
  }
}
