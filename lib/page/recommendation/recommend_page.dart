import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/image_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/recommendation/recommendation_view_model.dart';
import 'package:provider/provider.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  List<String> genres = [
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Fantasy',
    'Horror',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Slice of Life',
    'Supernatural',
    'Thriller',
    'Sports',
    'Psychological',
    'Mecha',
    'Historical',
    'School Life',
    'Martial Arts',
    'Shoujo',
    'Shounen',
  ];
  String? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<RecommendationViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Get manga recommendation!!",
                          style: TextStyleConstant.header1,
                        ),
                        Text(
                          "Find the best manga based on your genre",
                          style: TextStyleConstant.p4,
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Image.asset(
                      ImageConstant.luffyImg,
                      height: 100,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<String>(
                  menuMaxHeight: 300,
                  elevation: 10,
                  value: _selectedGenre,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGenre = newValue;
                    });
                  },
                  items: genres.map((String genre) {
                    return DropdownMenuItem<String>(
                      value: genre,
                      child: Text(genre),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorConstant.colorPrimary,
                    hintText: 'Select Manga Genre',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: const MaterialStatePropertyAll(
                            Size(double.infinity, 50)),
                        backgroundColor: MaterialStatePropertyAll(
                            ColorConstant.colorSecondary)),
                    onPressed: () {
                      if (_selectedGenre != null) {
                        viewModel.getRecommendation(_selectedGenre!);
                      }
                    },
                    child: Text(
                      "Get recommendation",
                      style: TextStyleConstant.p3,
                    )),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Center(
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : viewModel.result != null
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorConstant.colorOnSecondary),
                                  borderRadius:
                                      BorderRadiusDirectional.circular(30),
                                ),
                                width: double.infinity,
                                child: Markdown(
                                  shrinkWrap: true,
                                  data: viewModel.result!,
                                  styleSheet: MarkdownStyleSheet(
                                      p: TextStyleConstant.p2),
                                  selectable: true,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No recommendations",
                                    style: TextStyleConstant.p4,
                                  ),
                                  const SizedBox(height: 16),
                                  Lottie.asset(
                                    ImageConstant.chainsawLottie,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
