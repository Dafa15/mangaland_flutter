import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/page/chapter/chapter_page.dart';
import 'package:mangaland_flutter/page/detail/detail_view_model.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final String mangaId;
  const DetailPage({
    super.key,
    required this.mangaId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? coverUrl;
  Manga? manga;

  @override
  void initState() {
    super.initState();
    loadMangaData();
    Provider.of<DetailViewModel>(context, listen: false)
        .getChapterList(id: widget.mangaId);
  }

  Future<void> loadMangaData() async {
    final viewModel = Provider.of<DetailViewModel>(context, listen: false);
    manga = await viewModel.getMangaData(id: widget.mangaId);
    if (manga != null && manga!.coverArt != null) {
      coverUrl = viewModel.getCoverUrl(
        fileNameCover: manga!.coverArt!.filename,
        idCover: widget.mangaId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.bookmark,
                  color: ColorConstant.colorPrimary,
                ))
          ],
        ),
        body: Consumer<DetailViewModel>(builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (manga == null) {
            return const Center(
              child: Text("Failed to load manga details "),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 140,
                      child: Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 110,
                                height: 140,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: SizedBox(
                                  width: 120,
                                  child: Image.network(
                                    coverUrl!,
                                    width: 120,
                                    height: 170,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    manga?.title != null ? manga!.title : '',
                                    style: TextStyleConstant.header1,
                                  ),
                                  Text(
                                    manga?.status ?? '',
                                    style: TextStyleConstant.p2,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.bookmark_added,
                                        color: ColorConstant.colorSecondary,
                                      ),
                                      Text(
                                        "${manga?.statistics?.follows}",
                                        style: TextStyleConstant.p1,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: ColorConstant.colorSecondary,
                                      ),
                                      Text(
                                        "${manga?.statistics?.rating.average}",
                                        style: TextStyleConstant.p1,
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: ColorConstant.colorOnPrimary,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        manga?.author?.name ?? "-",
                                        style: TextStyleConstant.p4,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Description",
                      style: TextStyleConstant.header2,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      manga?.description ?? '-',
                      style: TextStyleConstant.p4,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: manga?.tags?.length ?? 0,
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorConstant.colorhattrick,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8.0),
                              child: Center(
                                  child: Text(
                                manga!.tags?[index].name ?? "",
                                style: TextStyleConstant.p3,
                              )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Latest Chapters",
                      style: TextStyleConstant.header3,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: ColorConstant.colorOnPrimary,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.listChapter.length,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChapterPage(
                                          chapterId: viewModel
                                              .listChapter[index].id)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorConstant.colorhattrick,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Chapter ${viewModel.listChapter[index].chapter}",
                                          style: TextStyleConstant.p5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            viewModel.listChapter[index]
                                                        .title !=
                                                    null
                                                ? " - ${viewModel.listChapter[index].title}"
                                                : '',
                                            style: TextStyleConstant.p5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(viewModel.listChapter[index].publishAt,
                                        style: TextStyleConstant.p4)
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            );
          }
        }));
  }
}
