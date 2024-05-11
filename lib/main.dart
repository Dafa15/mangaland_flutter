import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mangaland_flutter/page/recommendation/recommendation_view_model.dart';
import 'package:mangaland_flutter/utils/gemini_key.dart';
import 'package:mangaland_flutter/page/chapter/chapter_view_model.dart';
import 'package:mangaland_flutter/page/detail/detail_view_model.dart';
import 'package:mangaland_flutter/page/home/home_view_model.dart';
import 'package:mangaland_flutter/page/login/login_view_model.dart';
import 'package:mangaland_flutter/page/search/search_view_model.dart';
import 'package:mangaland_flutter/page/splash/splash_page.dart';
import 'package:provider/provider.dart';

void main() {
  Gemini.init(apiKey: apiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChapterViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecommendationViewModel(),
        ),
      ],
      child: const MaterialApp(
        title: 'Mini Project',
        home: SplashPage(),
      ),
    );
  }
}
