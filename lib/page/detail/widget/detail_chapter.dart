import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/model/chapter.dart';
import 'package:mangaland_flutter/page/chapter/chapter_page.dart';
import 'package:mangaland_flutter/page/detail/detail_view_model.dart';
import 'package:provider/provider.dart';

class DetailChapter extends StatefulWidget {
  final id;
  const DetailChapter({super.key, required this.id});

  @override
  State<DetailChapter> createState() => _DetailChapterState();
}

class _DetailChapterState extends State<DetailChapter> {
  static const _limit = 100;
  final PagingController<int, Chapter> _chapterController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _chapterController.addPageRequestListener((pageKey) {
      loadChapterDataa(pageKey);
    });
    super.initState();
  }

  Future<void> loadChapterDataa(int offSet) async {
    try {
      final newItems =
          await Provider.of<DetailViewModel>(context, listen: false)
              .getChapterList(id: widget.id, offSet: offSet);
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        _chapterController.appendLastPage(newItems);
      } else {
        final nextPageKey = offSet + _limit;
        _chapterController.appendPage(newItems, nextPageKey);
      }
    } catch (e) {
      _chapterController.error = e;
    }
  }

  @override
  void dispose() {
    _chapterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailViewModel>(
      builder: (context, viewModel, child) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PagedListView<int, Chapter>(
                pagingController: _chapterController,
                builderDelegate: PagedChildBuilderDelegate(
                    firstPageProgressIndicatorBuilder: (context) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.colorPrimary,
                    ),
                  );
                }, firstPageErrorIndicatorBuilder: (context) {
                  return Center(
                    child: Text(
                      "There is no chapter",
                      style: TextStyleConstant.header2,
                    ),
                  );
                }, itemBuilder: (context, Chapter item, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChapterPage(chapterId: item.id)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorConstant.colorOnSecondary, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Chapter ${item.chapter}",
                                  style: TextStyleConstant.p2,
                                ),
                                Expanded(
                                  child: Text(
                                    item.title != null && item.title != ''
                                        ? " - ${item.title}"
                                        : '',
                                    style: TextStyleConstant.p2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Text(item.publishAt, style: TextStyleConstant.p4)
                          ],
                        ),
                      ),
                    ),
                  );
                })),
          ),
        );
      },
    );
  }
}
