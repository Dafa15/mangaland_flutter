import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/page/home/completed_section.dart';
import 'package:mangaland_flutter/page/home/popular_section.dart';
import 'package:mangaland_flutter/page/home/recent_section.dart';
import 'package:mangaland_flutter/page/login/login_page.dart';
import 'package:mangaland_flutter/page/search/seach_page.dart';
import 'package:mangaland_flutter/utils/shared_pref.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBar(
        
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: ColorConstant.bgColor,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPage()));
              },
              icon: Icon(
                Icons.search,
                color: ColorConstant.colorPrimary,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: ColorConstant.bgColor,
            ),
            child: IconButton(
              onPressed: () {
                SharedPref.removeAllKey();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              icon: Icon(
                Icons.logout,
                color: ColorConstant.colorPrimary,
              ),
            ),
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            PopularSection(),
            SizedBox(
              height: 16,
            ),
            RecentSection(),
            SizedBox(
              height: 16,
            ),
            CompletedSection(),
          ],
        ),
      ),
    );
  }
}
