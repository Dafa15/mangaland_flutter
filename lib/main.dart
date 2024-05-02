import 'package:flutter/material.dart';
import 'package:mangaland_flutter/page/home/home_page.dart';
import 'package:mangaland_flutter/page/home/home_view_model.dart';
import 'package:mangaland_flutter/page/login/login_view_model.dart';
import 'package:provider/provider.dart';

void main() {
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
      ],
      child: const MaterialApp(
        title: 'Mini Project',
        home: HomePage(),
      ),
    );
  }
}
