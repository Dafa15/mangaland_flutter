import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/detail/detail_view_model.dart';
import 'package:mangaland_flutter/page/detail/widget/detail_chapter.dart';
import 'package:mangaland_flutter/page/detail/widget/detail_genre.dart';
import 'package:mangaland_flutter/page/detail/widget/detail_header.dart';
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<DetailViewModel>(context, listen: false)
            .getMangaData(id: widget.mangaId),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: ColorConstant.bgColor,
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Scaffold(
                backgroundColor: ColorConstant.bgColor,
                body: Center(
                  child: Text(
                    "Failed to load manga",
                    style: TextStyleConstant.header2,
                  ),
                ),
              ),
            );
          } else {
            return Consumer<DetailViewModel>(
              builder: (context, viewModel, child) {
                return Scaffold(
                  backgroundColor: ColorConstant.bgColor,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    iconTheme: IconThemeData(color: ColorConstant.colorPrimary),
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DetailHeader(),
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
                          viewModel.manga?.description ?? '-',
                          style: TextStyleConstant.p4,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Genres",
                          style: TextStyleConstant.header2,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const DetailGenre(),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Chapters",
                          style: TextStyleConstant.header2,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: ColorConstant.colorOnPrimary,
                      ),
                      DetailChapter(
                        id: widget.mangaId,
                      )
                    ],
                  ),
                  floatingActionButton: FloatingActionButton( 
                      backgroundColor: ColorConstant.colorSecondary,
                      onPressed: () {},
                      child: viewModel.follow == true
                          ? IconButton(
                              onPressed: () async {
                                Provider.of<DetailViewModel>(context,
                                        listen: false)
                                    .deleteFollowManga(widget.mangaId);
                              },
                              icon: Icon(
                                size: 32,
                                Icons.bookmark_rounded,
                                color: ColorConstant.colorPrimary,
                              ))
                          : IconButton(
                              onPressed: () async {
                                Provider.of<DetailViewModel>(context,
                                        listen: false)
                                    .postFollowManga(widget.mangaId);
                              },
                              icon: Icon(
                                size: 32,
                                Icons.bookmark_add_outlined,
                                color: ColorConstant.colorPrimary,
                              ))),
                );
              },
            );
          }
        }));
  }
}
