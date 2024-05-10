import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/home/explore/all_tab.dart';
import 'package:mangaland_flutter/page/home/explore/completed_tab.dart';
import 'package:mangaland_flutter/page/home/explore/ongoing_tab.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: ColorConstant.bgColor,
          appBar: AppBar(
            title: Text(
              "Explore",
              style: TextStyleConstant.header1,
            ),
            iconTheme: IconThemeData(color: ColorConstant.colorPrimary),
            backgroundColor: ColorConstant.bgColor,
            bottom: TabBar(
              tabs: const [
                Tab(
                  text: "All",
                ),
                Tab(
                  text: "Ongoing",
                ),
                Tab(
                  text: "Completed",
                ),
              ],
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(8),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ColorConstant.colorSecondary,
              ),
              labelColor: ColorConstant.colorPrimary,
            ),
          ),
          body: const TabBarView(
              children: [AllTab(), OngoingTab(), CompletedTab()])),
    );
  }
}
