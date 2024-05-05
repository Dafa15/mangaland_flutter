import 'chapter.dart';

class ChapterData {
  Chapter chapter;
  String hash;
  List<String> data;

  ChapterData({
    required this.chapter,
    required this.hash,
    required this.data,
  });

  @override
  String toString() {
    return 'ChapterData{chapter: $chapter, hash: $hash, data: $data}';
  }

}
