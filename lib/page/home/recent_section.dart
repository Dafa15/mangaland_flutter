import 'package:flutter/material.dart';
import 'package:mangaland_flutter/page/global_widget/list_view_widget.dart';
import 'package:mangaland_flutter/page/home/home_view_model.dart';
import 'package:provider/provider.dart';

class RecentSection extends StatefulWidget {
  const RecentSection({super.key});

  @override
  State<RecentSection> createState() => _RecentSectionState();
}

class _RecentSectionState extends State<RecentSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, viewModel, index) {
      return ListViewCustom(
          mangaList: viewModel.recentManga, listName: "Recent Release");
    });
  }
}
