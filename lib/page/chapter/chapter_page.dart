import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/chapter/chapter_view_model.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ChapterPage extends StatefulWidget {
  final String chapterId;
  const ChapterPage({super.key, required this.chapterId});

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: FutureBuilder(
        future: Provider.of<ChapterViewModel>(context, listen: false)
            .getChapterPages(id: widget.chapterId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to get chapter images"));
          } else {
            return Consumer<ChapterViewModel>(
              builder: (context, viewModel, child) {
                return NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      centerTitle: true,
                      iconTheme:
                          IconThemeData(color: ColorConstant.colorPrimary),
                      backgroundColor: ColorConstant.colorSecondary,
                      title: Text(
                        "Chapter ${viewModel.chapterData!.chapter.chapter}",
                        style: TextStyleConstant.header1,
                      ),
                    )
                  ],
                  body: ScrollWrapper(
                    promptAlignment: Alignment.bottomRight,
                    alwaysVisibleAtOffset: false,
                    promptDuration: const Duration(milliseconds: 100),
                    builder: (context, properties) => ListView.builder(
                      reverse: properties.reverse,
                      primary: properties.primary,
                      controller: properties.scrollController,
                      itemCount: viewModel.chapterData?.data.length,
                      itemBuilder: (context, int index) {
                        final imgUrl = viewModel.getImg(
                          fileName: viewModel.chapterData!.data[index],
                          hash: viewModel.chapterData!.hash,
                        );
                        return SizedBox(
                          width: double.infinity,
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return const Center(
                                  child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ));
                            },
                            image: imgUrl,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
