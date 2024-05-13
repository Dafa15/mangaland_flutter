import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/image_constant.dart';
import 'package:mangaland_flutter/page/home/home_page.dart';
import 'package:mangaland_flutter/page/login/login_page.dart';
import 'package:mangaland_flutter/service/auth_service.dart';
import 'package:mangaland_flutter/utils/shared_pref.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isValid = false;
  void checkToken() async {
    final token = await SharedPref.getToken();
    if (token != null) {
      isValid = await AuthService.checkToken(token);
    }
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (token != null && isValid) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(
                index: 0,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    checkToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: Center(child: Image.asset(ImageConstant.iconApp)),
    );
  }
}
