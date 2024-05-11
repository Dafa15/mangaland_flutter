import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/page/detail/detail_page.dart';
import 'package:mangaland_flutter/page/home/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PagedGridViewCustom extends StatefulWidget {
  final PagingController<int, Manga> mangaController;
  const PagedGridViewCustom({super.key, required this.mangaController});

  @override
  State<PagedGridViewCustom> createState() => _PagedGridViewCustomState();
}

class _PagedGridViewCustomState extends State<PagedGridViewCustom> {

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, viewModel, child) {
      return PagedGridView<int, Manga>(
        showNewPageProgressIndicatorAsGridChild: false,
        showNewPageErrorIndicatorAsGridChild: false,
        showNoMoreItemsIndicatorAsGridChild: false,
        pagingController: widget.mangaController,
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
