import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/detail/detail_page.dart';
import 'package:mangaland_flutter/page/home/home_view_model.dart';
import 'package:mangaland_flutter/utils/shared_pref.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchContoller = TextEditingController();
  String? userName;

  @override
  void initState() {
    super.initState();
    getUserName();
    Provider.of<HomeViewModel>(context, listen: false).getRecentList();
    Provider.of<HomeViewModel>(context, listen: false).getPopularList();
    Provider.of<HomeViewModel>(context, listen: false).getCompletedManga();
  }

  void getUserName() async {
    userName = await SharedPref.getName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: ColorConstant.colorSecondary,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.person,
                                color: ColorConstant.colorPrimary,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Welcome!!!",
                                  style: GoogleFonts.poppins(
                                      color: ColorConstant.colorPrimary,
                                      fontSize: 12),
                                ),
                                Text(
                                  "Dafa",
                                  style: GoogleFonts.poppins(
                                      color: ColorConstant.colorSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          Icons.search,
                          color: ColorConstant.colorPrimary,
                        )
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Most Popular",
                  style: TextStyleConstant.header1,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                height: 250,
                child: ListView.builder(
                    itemCount: homeViewModel.popularManga.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, int index) {
                      final imageUrl = homeViewModel.getCoverUrl(
                          homeViewModel.popularManga[index].id,
                          homeViewModel.popularManga[index].coverArt!.filename);

                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            final popularMangaData =
                                homeViewModel.popularManga[index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  mangaId: popularMangaData.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(imageUrl),
                                  )),
                              width: 200,
                              child: Stack(children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Container(
                                      height: 75,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        homeViewModel.popularManga[index].title,
                                        maxLines: 1,
                                        style: TextStyleConstant.header1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Color(0xFFFFFF00),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            '${homeViewModel.popularManga[index].statistics?.rating.average}',
                                            style: TextStyle(
                                                color:
                                                    ColorConstant.colorPrimary,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ])),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Recent Release",
                      style: TextStyleConstant.header1,
                    ),
                    Text(
                      "See more",
                      style: TextStyleConstant.p1,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeViewModel.recentManga.length,
                  itemBuilder: (context, int index) {
                    final imageUrl = homeViewModel.getCoverUrl(
                        homeViewModel.recentManga[index].id,
                        homeViewModel.recentManga[index].coverArt!.filename);
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          final recentMangaData =
                              homeViewModel.recentManga[index];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                mangaId: recentMangaData.id,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 120,
                          child: Column(
                            children: [
                              Image.network(
                                imageUrl,
                                width: 120,
                                height: 170,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                homeViewModel.recentManga[index].title,
                                style: TextStyleConstant.p2,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Completed Manga",
                      style: TextStyleConstant.header1,
                    ),
                    Text(
                      "See more",
                      style: TextStyleConstant.p1,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeViewModel.completedManga.length,
                  itemBuilder: (context, int index) {
                    final imageUrl = homeViewModel.getCoverUrl(
                        homeViewModel.completedManga[index].id,
                        homeViewModel.completedManga[index].coverArt!.filename);
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          final completedMangaData =
                              homeViewModel.completedManga[index];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(mangaId: completedMangaData.id),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 120,
                          child: Column(
                            children: [
                              Image.network(
                                imageUrl,
                                width: 120,
                                height: 170,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                homeViewModel.completedManga[index].title,
                                style: TextStyleConstant.p2,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
