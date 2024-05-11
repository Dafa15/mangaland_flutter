import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/page/detail/detail_page.dart';
import 'package:mangaland_flutter/service/auth_service.dart';
import 'package:mangaland_flutter/service/follow_service.dart';
import 'package:shimmer/shimmer.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({super.key});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  static const _limit = 10;
  final PagingController<int, Manga> _mangaController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _mangaController.addPageRequestListener((pageKey) {
      loadFollowedManga(pageKey);
    });
    super.initState();
  }

  Future<void> loadFollowedManga(int offSet) async {
    try {
      final newItems = await FollowService.getFollowedManga(offSet);
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        _mangaController.appendLastPage(newItems);
      } else {
        final nextPageKey = offSet + _limit;
        _mangaController.appendPage(newItems, nextPageKey);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final response = await AuthService.postRefreshToken();
        if (response == true) {
          loadFollowedManga(offSet);
        }
      } else {
        _mangaController.error = e;
      }
    }
  }

  @override
  void dispose() {
    _mangaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Favorite",
          style: TextStyleConstant.header1,
        ),
        backgroundColor: ColorConstant.bgColor,
      ),
      body: PagedGridView<int, Manga>(
          showNewPageProgressIndicatorAsGridChild: false,
          showNewPageErrorIndicatorAsGridChild: false,
          showNoMoreItemsIndicatorAsGridChild: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: 2,
              mainAxisExtent: 290),
          padding: const EdgeInsets.all(16),
          pagingController: _mangaController,
          builderDelegate: PagedChildBuilderDelegate(
              noItemsFoundIndicatorBuilder: (context) {
            return Center(
              child: Text(
                "There is no followed manga",
                style: TextStyleConstant.header2,
              ),
            );
          }, firstPageErrorIndicatorBuilder: (context) {
            return Center(
              child: Text(
                "Failed to load followed manga",
                style: TextStyleConstant.header2,
              ),
            );
          }, itemBuilder: (context, Manga item, int index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(mangaId: item.id)))
                      .then((value) => _mangaController.refresh());
                },
                child: Column(
                  children: [
                    CachedNetworkImage(
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        errorWidget: (context, url, error) {
                          return const Center(
                              child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ));
                        },
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              color: Colors.grey,
                              height: 170,
                              width: 120,
                            ),
                          );
                        },
                        imageUrl:
                            "https://uploads.mangadex.org/covers/${item.id}/${item.coverArt!.filename}"),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      item.title,
                      style: TextStyleConstant.header2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ));
          })),
    );
  }
}
