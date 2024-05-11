import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';
import 'package:mangaland_flutter/constant/text_style_constant.dart';
import 'package:mangaland_flutter/page/detail/detail_page.dart';
import 'package:mangaland_flutter/page/search/search_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SearchViewModel>(context, listen: false).deleteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstant.colorPrimary),
        centerTitle: true,
        title: Text(
          "Search Manga",
          style: TextStyleConstant.header1,
        ),
        backgroundColor: ColorConstant.bgColor,
      ),
      backgroundColor: ColorConstant.bgColor,
      body: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onSubmitted: (value) async {
                  viewModel.getSearchList(value);
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        viewModel.getSearchList(searchController.text);
                      },
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    fillColor: ColorConstant.colorPrimary,
                    filled: true,
                    hintText: "Input manga title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
              ),
            ),
            viewModel.isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : viewModel.listManga.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            "Manga is empty",
                            style: TextStyleConstant.header2,
                          ),
                        ),
                      )
                    : Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16.0,
                                    mainAxisSpacing: 16.0,
                                    mainAxisExtent: 290),
                            itemCount: viewModel.listManga.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                          mangaId:
                                              viewModel.listManga[index].id),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 250,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://uploads.mangadex.org/covers/${viewModel.listManga[index].id}/${viewModel.listManga[index].coverArt!.filename}",
                                        height: 170,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) {
                                          return const Center(
                                              child: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ));
                                        },
                                        placeholder: (context, url) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: Container(
                                              color: Colors.grey,
                                              height: 170,
                                              width: 120,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      viewModel.listManga[index].title,
                                      style: TextStyleConstant.header2,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            }))
          ]);
        },
      ),
    );
  }
}
