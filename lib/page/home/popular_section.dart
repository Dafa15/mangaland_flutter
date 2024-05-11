import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/detail/detail_page.dart';
import 'package:mangaland_flutter/page/home/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PopularSection extends StatefulWidget {
  const PopularSection({super.key});

  @override
  State<PopularSection> createState() => _PopularSectionState();
}

class _PopularSectionState extends State<PopularSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlutterCarousel.builder(
              itemCount: viewModel.popularManga.length,
              options: CarouselOptions(
                  height: 400,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  autoPlayAnimationDuration: const Duration(seconds: 1)),
              itemBuilder: (context, int itemIndex, int pageIndex) {
                final imageUrl = viewModel.getCoverUrl(
                    idCover: viewModel.popularManga[itemIndex].id,
                    fileNameCover:
                        viewModel.popularManga[itemIndex].coverArt!.filename);
                return GestureDetector(
                  onTap: () {
                    final popularMangaData = viewModel.popularManga[itemIndex];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(mangaId: popularMangaData.id),
                      ),
                    );
                  },
                  child: SizedBox(
                      width: double.infinity,
                      child: Stack(children: [
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: double.infinity,
                          fit: BoxFit.fill,
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
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 300,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  ColorConstant.bgColor.withOpacity(0.0),
                                  ColorConstant.bgColor
                                ])),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.popularManga[itemIndex].title,
                                maxLines: 1,
                                style: TextStyleConstant.header1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xFFFFFF00),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    '${viewModel.popularManga[itemIndex].statistics?.rating.average}',
                                    style: TextStyle(
                                        color: ColorConstant.colorPrimary,
                                        fontSize: 12),
                                  )
                                ],
                              ),
                              Text(
                                "${viewModel.popularManga[itemIndex].tags?[0].name}, ${viewModel.popularManga[itemIndex].tags?[1].name}, ${viewModel.popularManga[itemIndex].tags?[2].name}..",
                                maxLines: 1,
                                style: TextStyleConstant.p2,
                              ),
                            ],
                          ),
                        ),
                      ])),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
