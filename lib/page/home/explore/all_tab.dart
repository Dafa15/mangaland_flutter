import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/page/detail/detail_page.dart';
import 'package:mangaland_flutter/page/home/home_view_model.dart';
import 'package:mangaland_flutter/service/home_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AllTab extends StatefulWidget {
  const AllTab({super.key});

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  static const _limit = 10;
  final PagingController<int, Manga> _mangaController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _mangaController.addPageRequestListener((pageKey) {
      loadAllManga(pageKey);
    });
    super.initState();
  }

  Future<void> loadAllManga(int offSet) async {
    try {
      final newItems = await HomeService.getRecentListManga(offSet);
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        _mangaController.appendLastPage(newItems);
      } else {
        final nextPageKey = offSet + _limit;
        _mangaController.appendPage(newItems, nextPageKey);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void dispose() {
    _mangaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, viewModel, child) {
      return PagedGridView<int, Manga>(
        showNewPageProgressIndicatorAsGridChild: false,
        showNewPageErrorIndicatorAsGridChild: false,
        showNoMoreItemsIndicatorAsGridChild: false,
        pagingController: _mangaController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            mainAxisExtent: 290),
        padding: const EdgeInsets.all(16),
        builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, Manga item, int index) {
          final imgUrl = viewModel.getCoverUrl(
              idCover: item.id, fileNameCover: item.coverArt!.filename);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(mangaId: item.id),
                ),
              );
            },
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    height: 170,
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
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: TextStyleConstant.header2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
