import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
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
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_3_outlined),
                  ),
                  title: Text(
                    "Welcome!!!",
                    style: GoogleFonts.poppins(
                        color: ColorConstant.colorPrimary, fontSize: 12),
                  ),
                  subtitle: Text(userName ?? '-',
                      style: GoogleFonts.poppins(
                          color: ColorConstant.colorSecondary, fontSize: 16)),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        size: 24,
                        Icons.search,
                        color: ColorConstant.colorPrimary,
                      )),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
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
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(imageUrl),
                                )),
                            width: 250,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              color: ColorConstant.colorPrimary,
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ])),
                      );
                    }),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
