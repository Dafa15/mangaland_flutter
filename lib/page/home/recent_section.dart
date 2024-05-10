import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/detail/detail_page.dart';
import 'package:mangaland_flutter/page/home/home_page.dart';
import 'package:mangaland_flutter/page/home/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class RecentSection extends StatefulWidget {
  const RecentSection({super.key});

  @override
  State<RecentSection> createState() => _RecentSectionState();
}

class _RecentSectionState extends State<RecentSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Recent Release",
                style: TextStyleConstant.header1,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const HomePage(index: 1)));
                },
                child: Text(
                  "See more",
                  style: TextStyleConstant.p1,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Consumer<HomeViewModel>(builder: (context, viewModel, index) {
          return SizedBox(
            width: double.infinity,
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.recentManga.length,
              itemBuilder: (context, int index) {
                final imgUrl = viewModel.getCoverUrl(
                    idCover: viewModel.recentManga[index].id,
                    fileNameCover:
                        viewModel.recentManga[index].coverArt!.filename);
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      final recentMangaData = viewModel.recentManga[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(mangaId: recentMangaData.id),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 120,
                      child: Column(
                        children: [
                          CachedNetworkImage(
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
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            viewModel.recentManga[index].title,
                            style: TextStyleConstant.p2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
