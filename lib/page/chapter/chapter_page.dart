import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/model/chapter_data.dart';
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
  ChapterData? chapterData;

  @override
  void initState() {
    super.initState();
    getChapterImg(id: widget.chapterId);
  }

  Future<void> getChapterImg({required String id}) async {
    chapterData = await Provider.of<ChapterViewModel>(context, listen: false)
        .getChapterPages(id: id);
    debugPrint("apakah disini ${chapterData?.data}");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.bgColor,
        body: Consumer<ChapterViewModel>(builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (chapterData == null) {
            return const Center(
              child: Text("Failed to get chapter images"),
            );
          } else {
            return NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        floating: true,
                        snap: true,
                        centerTitle: true,
                        backgroundColor: ColorConstant.colorSecondary,
                        title: Text(
                          "Chapter ${chapterData!.chapter.chapter}",
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
                    itemCount: chapterData?.data.length,
                    itemBuilder: (context, int index) {
                      final imgUrl = viewModel.getImg(
                          fileName: chapterData!.data[index],
                          hash: chapterData!.hash);
                      return Container(
                          width: double.infinity,
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage, image: imgUrl));
                    },
                  ),
                ));
          }
        }));
  }
}
