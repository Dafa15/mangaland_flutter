import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/follow/follow_page.dart';
import 'package:mangaland_flutter/page/explore/explore.page.dart';
import 'package:mangaland_flutter/page/home/widget/home_screen.dart';
import 'package:mangaland_flutter/page/home/home_view_model.dart';
import 'package:mangaland_flutter/page/recommendation/recommend_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final int index;
  const HomePage({super.key, required this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<void> _getAllListFuture;

  @override
  void initState() {
    _selectedIndex = widget.index;
    _getAllListFuture =
        Provider.of<HomeViewModel>(context, listen: false).getAllList();
    super.initState();
  }

  List<Widget> widgetOptions = <Widget>[
    const HomeScreen(),
    const ExploreScreen(),
    const FollowScreen(),
    const RecommendationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: FutureBuilder(
          future: _getAllListFuture,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Failed to load manga",
                  style: TextStyleConstant.header2,
                ),
              );
            } else {
              return RefreshIndicator(
                  onRefresh: () {
                    setState(() {
                      _getAllListFuture =
                          Provider.of<HomeViewModel>(context, listen: false)
                              .getAllList();
                    });
                    return _getAllListFuture;
                  },
                  child: widgetOptions.elementAt(_selectedIndex));
            }
          })),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorConstant.colorSecondary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.home),
              icon: Icon(
                Icons.home_outlined,
              ),
              label: "Home"),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.explore),
            icon: Icon(Icons.explore_outlined),
            label: "Explore",
          ),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.bookmark),
              icon: Icon(Icons.bookmark_outline),
              label: "Follow"),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.auto_awesome),
              icon: Icon(Icons.auto_awesome_outlined),
              label: "Recommend"),
        ],
        selectedItemColor: ColorConstant.colorPrimary,
        currentIndex: _selectedIndex,
        unselectedItemColor: ColorConstant.colorOnPrimary,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
