// To parse this JSON data, do
//
//     final chapterPages = chapterPagesFromJson(jsonString);

import 'dart:convert';

ChapterPages chapterPagesFromJson(String str) => ChapterPages.fromJson(json.decode(str));

String chapterPagesToJson(ChapterPages data) => json.encode(data.toJson());

class ChapterPages {
    String result;
    String baseUrl;
    Chapter chapter;

    ChapterPages({
        required this.result,
        required this.baseUrl,
        required this.chapter,
    });

    factory ChapterPages.fromJson(Map<String, dynamic> json) => ChapterPages(
        result: json["result"],
        baseUrl: json["baseUrl"],
        chapter: Chapter.fromJson(json["chapter"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result,
        "baseUrl": baseUrl,
        "chapter": chapter.toJson(),
    };
}

class Chapter {
    String hash;
    List<String> data;
    List<String> dataSaver;

    Chapter({
        required this.hash,
        required this.data,
        required this.dataSaver,
    });

    factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        hash: json["hash"],
        data: List<String>.from(json["data"].map((x) => x)),
        dataSaver: List<String>.from(json["dataSaver"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "hash": hash,
        "data": List<dynamic>.from(data.map((x) => x)),
        "dataSaver": List<dynamic>.from(dataSaver.map((x) => x)),
    };
}
