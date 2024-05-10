import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/detail/detail_view_model.dart';
import 'package:provider/provider.dart';

class DetailGenre extends StatefulWidget {
  const DetailGenre({super.key});

  @override
  State<DetailGenre> createState() => _DetailGenreState();
}

class _DetailGenreState extends State<DetailGenre> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          width: double.infinity,
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.manga?.tags?.length ?? 0,
            itemBuilder: (context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstant.colorOnSecondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: Center(
                        child: Text(
                      viewModel.manga!.tags?[index].name ?? "",
                      style: TextStyleConstant.p3,
                    )),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
