import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';

class TextStyleConstant {
  final double fontSizeCustom;

  TextStyleConstant(this.fontSizeCustom);

  static TextStyle header2 = GoogleFonts.oswald(
      fontWeight: FontWeight.w500,
      color: ColorConstant.colorPrimary,
      fontSize: 16);
  static TextStyle header3 = GoogleFonts.oswald(
      fontWeight: FontWeight.w500,
      color: ColorConstant.colorSecondary,
      fontSize: 16);
  static TextStyle header1 = GoogleFonts.oswald(
      fontWeight: FontWeight.bold,
      color: ColorConstant.colorPrimary,
      fontSize: 24);
  static TextStyle p1 = GoogleFonts.oswald(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: ColorConstant.colorSecondary);
  static TextStyle p2 = GoogleFonts.poppins(
      fontWeight: FontWeight.w300,
      fontSize: 12,
      color: ColorConstant.colorPrimary);
}
