import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mangaland_flutter/model/manga.dart';
import 'package:mangaland_flutter/global_widget/paged_grid_view_widget.dart';
import 'package:mangaland_flutter/service/home_service.dart';

class OngoingTab extends StatefulWidget {
  const OngoingTab({super.key});

  @override
  State<OngoingTab> createState() => _OngoingTabState();
}

class _OngoingTabState extends State<OngoingTab> {
  static const _limit = 10;
  final PagingController<int, Manga> _mangaController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _mangaController.addPageRequestListener((pageKey) {
      loadOngoingManga(pageKey);
    });
    super.initState();
  }

  Future<void> loadOngoingManga(int offSet) async {
    try {
      final newItems = await HomeService.getOnGoingManga(offSet);
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
