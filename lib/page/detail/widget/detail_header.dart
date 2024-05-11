import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/detail/detail_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetailHeader extends StatefulWidget {
  const DetailHeader({super.key});

  @override
  State<DetailHeader> createState() => _DetailHeaderState();
}

class _DetailHeaderState extends State<DetailHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailViewModel>(
      builder: (context, viewModel, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 140,
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
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://uploads.mangadex.org/covers/${viewModel.manga?.id}/${viewModel.manga?.coverArt!.filename}",
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.manga?.title != null
                            ? viewModel.manga!.title
                            : '',
                        style: TextStyleConstant.header4,
                        maxLines: 2,
                      ),
                      Text(
                        viewModel.manga?.status ?? '',
                        style: TextStyleConstant.p2,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.bookmark_added,
                            color: Colors.greenAccent,
                          ),
                          Text(
                            "${viewModel.manga?.statistics?.follows}",
                            style: TextStyleConstant.p2,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.star,
                            color: ColorConstant.statisicColor,
                          ),
                          Text(
                            "${viewModel.manga?.statistics?.rating.average}",
                            style: TextStyleConstant.p2,
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            viewModel.manga?.author?.name ?? "-",
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
        );
      },
    );
  }
}
