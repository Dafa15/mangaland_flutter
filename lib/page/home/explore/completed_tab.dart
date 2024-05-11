import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/page/global_widget/paged_grid_view_widget.dart';
import 'package:mangaland_flutter/service/home_service.dart';


class CompletedTab extends StatefulWidget {
  const CompletedTab({super.key});

  @override
  State<CompletedTab> createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  static const _limit = 10;
  final PagingController<int, Manga> _mangaController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _mangaController.addPageRequestListener((pageKey) {
      loadCompletedManga(pageKey);
    });
    super.initState();
  }

  Future<void> loadCompletedManga(int offSet) async {
    try {
      final newItems = await HomeService.getCompletedManga(offSet);
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
    return PagedGridViewCustom(mangaController: _mangaController);
  }
}
