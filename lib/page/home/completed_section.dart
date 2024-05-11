import 'package:flutter/material.dart';
import 'package:mangaland_flutter/page/global_widget/list_view_widget.dart';
import 'package:mangaland_flutter/page/home/home_view_model.dart';
import 'package:provider/provider.dart';

class CompletedSection extends StatefulWidget {
  const CompletedSection({super.key});

  @override
  State<CompletedSection> createState() => _CompletedSectionState();
}

class _CompletedSectionState extends State<CompletedSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, viewModel, index) {
      return ListViewCustom(
          mangaList: viewModel.completedManga, listName: "Completed Manga");
    });
  }
}
